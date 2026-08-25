#!/usr/bin/env python3
"""Render the three somawork formulae from one exact, verified release manifest.

The tap consumes a single document — `somawork-manifest.json`, produced by
soma-work's `scripts/release/render-manifest.ts` — plus the immutable identity
the release dispatch carried. Nothing is discovered: there is no "latest
release" lookup, no tag guessing, no filename re-derivation from a URL. If the
manifest and the dispatch do not describe exactly one release, this exits 1 and
writes nothing.

**One channel, two formulae, both or neither.** A release announces a channel,
and the channel selects exactly one runtime: a `preview` dispatch renders
`somawork-cli` and `somawork-preview`; a `stable` dispatch renders `somawork-cli`
and `somawork`. The opposite channel's formula is not written, not created, and
not named on the command line at all — a preview manifest does carry a
production-profile archive, but that archive is *preview-channel bits with the
production profile marker*, and publishing it as the stable formula would put
unreleased code behind the stable gate.

Within a channel it is both or neither. A run that wrote `somawork-cli.rb` and
then rejected `somawork-preview.rb` would leave a tap whose controller and
runtime disagree about which bytes they came from, which is worse than not
bumping at all. So both formulae are validated and rendered in memory first, the
replacements happen only after both exist as staged files in their target
directories, and a failure during the replacement phase restores whatever was
there before.

**The Homebrew version is not always the package version.** A preview release
reuses soma-work's `package.json` version across runs, so publishing it verbatim
would produce two different releases claiming the same Homebrew version and
`brew upgrade` would never see the second. The preview tag carries the run id
that distinguishes them — `somawork-preview-v<version>-<run id>` — so the preview
formula version is `<version>.<run id>`, which is dotted-numeric and strictly
increasing with the run. Stable publishes `<version>` unchanged. Nothing is
invented: both halves are manifest/tag fields, and the exact tag relation is
verified rather than assumed.

**The package version has to be dotted-numeric.** The composed version is
ordered as a tuple of integers, so `0.2.0-rc.1` — which soma-work's own manifest
grammar accepts — is refused here rather than published at a version Homebrew and
this renderer would disagree about. That is a constraint this tap imposes on
soma-work's release grammar; it fails closed and is recorded in the task report.

**The license is fixed metadata, not release input.** soma-work is ISC — its
tracked LICENSE and its `package.json` agree — so the templates declare
`license "ISC"` outright and every formula rendered here carries exactly that
line. It is deliberately not read from the manifest: schema version 1 has no
license field, a payload that tries to add one is refused as an inexact
document, and the contract test requires the exact line in every rendered
formula so that deleting or changing it turns the suite red.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import posixpath
import re
import stat
import sys
import tempfile
from pathlib import Path
from typing import Any


# --- The producer's document, restated as the only shape this tap accepts -----

SCHEMA_VERSION = 1
LAYOUT_VERSION = 1
RELEASE_ORIGIN = "https://github.com"
SOURCE_REPOSITORY = "2lab-ai/soma-work"
MANIFEST_FILENAME = "somawork-manifest.json"
PLATFORM = "darwin-arm64"
INSTALL_MODE = "prefix"

MANIFEST_KEYS = {
    "schemaVersion",
    "layoutVersion",
    "channel",
    "version",
    "tag",
    "sourceSha",
    "platform",
    "minimumNode",
    "baseUrl",
    "layout",
    "assets",
}
LAYOUT_KEYS = {"install", "controller", "runtime"}
CONTROLLER_LAYOUT_KEYS = {"entry", "manifest"}
RUNTIME_LAYOUT_KEYS = {"marker", "manifest", "controllerEntry", "supervisor", "daemon"}
ASSET_KEYS = {"package", "profile", "filename", "url", "sha256", "bytes"}

# Order is part of the document: the producer emits this list, in this order.
EXPECTED_ASSETS = (
    ("somawork-cli", None),
    ("somawork", "production"),
    ("somawork-preview", "preview"),
)

# Which formula name a release channel is allowed to announce itself as. The
# dispatch carries a `package` field; binding it to the manifest's channel means
# a payload that claims the wrong stream fails closed instead of rendering a
# formula nobody checked.
CHANNEL_PACKAGE = {"preview": "somawork-preview", "stable": "somawork"}

# Each channel's tag shape is a contract, not a convention: it is where the run id
# that orders the Homebrew version comes from. A release under any other tag has
# no run id to read and is refused rather than published at a version that cannot
# be ordered.
#
# The run id is GitHub's, and GitHub run ids increase across the whole repository
# regardless of which workflow produced them. That is the property the shared
# controller formula needs: `somawork-cli` is written by whichever channel bumped
# last, so if preview composed a run id and stable did not, a stable release would
# *lower* the controller's version and no `brew upgrade` would ever move a user
# onto it. Both channels compose, so the controller advances monotonically no
# matter what order the two channels fire in.
CHANNEL_TAG_TEMPLATE = {
    "preview": "somawork-preview-v{version}-{run_id}",
    "stable": "somawork-v{version}-{run_id}",
}
RUN_ID_RE = re.compile(r"^[1-9][0-9]*$")

# The Node floor this tap has actually checked Homebrew's `node` against. The
# formulae say `depends_on "node"`, which is a moving target we do not control,
# so a manifest that raises its floor past this constant must fail closed and
# make a human re-check rather than silently render an install that cannot run.
MAXIMUM_MINIMUM_NODE = (20, 0, 0)

VERSION_RE = re.compile(r"^[0-9A-Za-z][0-9A-Za-z.+_-]{0,63}$")
TAG_RE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$")
SOURCE_SHA_RE = re.compile(r"^[0-9a-f]{40}$")
SHA256_RE = re.compile(r"^[0-9a-f]{64}$")
SEMVER_RE = re.compile(r"^(\d+)\.(\d+)\.(\d+)$")
REPOSITORY_RE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9._-]*/[A-Za-z0-9][A-Za-z0-9._-]*$")
# A path a formula will join onto its keg prefix: relative, normalized, no `..`,
# no `.`, no backslash, no control character.
LAYOUT_PATH_RE = re.compile(
    r"^[A-Za-z0-9._][A-Za-z0-9._-]*(?:/[A-Za-z0-9._][A-Za-z0-9._-]*)*$"
)
PLACEHOLDER_RE = re.compile(r"@[A-Z0-9_]+@")
# How this renderer reads back a version it wrote earlier. It is the same
# line the templates emit, so a formula this tool did not produce simply has
# no baseline to contribute.
INSTALLED_VERSION_RE = re.compile(r'^  version "([^"]*)"$', re.MULTILINE)


class ContractError(ValueError):
    """Raised when release input cannot safely render a formula."""


# --- Parsing primitives -------------------------------------------------------


def unique_object(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    value: dict[str, Any] = {}
    for key, item in pairs:
        if key in value:
            raise ContractError(f"duplicate JSON object key: {key}")
        value[key] = item
    return value


def exact_object(value: Any, keys: set[str], label: str) -> dict[str, Any]:
    if not isinstance(value, dict) or set(value) != keys:
        raise ContractError(f"{label} fields are not exact")
    return value


def exact_string(value: Any, pattern: re.Pattern[str], label: str) -> str:
    if not isinstance(value, str) or pattern.fullmatch(value) is None:
        raise ContractError(f"{label} is invalid")
    return value


def exact_integer(value: Any, expected: int, label: str) -> int:
    # `type(...) is not int` rather than isinstance: JSON `true` is an int
    # subclass in Python, and 1.0 is a float that compares equal to 1.
    if type(value) is not int or value != expected:
        raise ContractError(f"{label} is not the exact integer {expected}")
    return value


def positive_integer(value: Any, label: str) -> int:
    if type(value) is not int or value < 1:
        raise ContractError(f"{label} is not a positive integer")
    return value


def layout_path(value: Any, label: str, depth: int | None = None) -> str:
    if (
        not isinstance(value, str)
        or LAYOUT_PATH_RE.fullmatch(value) is None
        or ".." in value.split("/")
        or "." in value.split("/")
        or posixpath.normpath(value) != value
    ):
        raise ContractError(f"layout {label} is not a safe, normalized relative path")
    if depth is not None and len(value.split("/")) != depth:
        raise ContractError(f"layout {label} must be {depth} path segments deep")
    return value


def semver(value: str, label: str) -> tuple[int, int, int]:
    match = SEMVER_RE.fullmatch(value)
    if match is None:
        raise ContractError(f"{label} is not a three-part version")
    return (int(match.group(1)), int(match.group(2)), int(match.group(3)))


def formula_version(channel: str, version: str, tag: str) -> str:
    """The version Homebrew will compare: `<package version>.<run id>`.

    The run id is read out of the channel's tag, and the tag has to be exactly
    the one that version and run id compose to. Both channels do this, so every
    formula this tap writes — including the controller both channels share — is
    ordered by a number that only ever goes up for the repository.

    This is not the version the software reports. `somawork --version` and the
    runtime marker both carry the package version, and the formulae assert
    against that; see `@PACKAGE_VERSION@` in the templates.
    """
    # Split from the front against the version the manifest declares, not with
    # `rsplit`: `somawork-preview-vWHATEVER-7` has a plausible-looking run id on
    # the end, and reading one out of it would publish a version that has nothing
    # to do with the release. The prefix match plus the run-id grammar leave
    # exactly one accepted spelling, since the run id is by construction the
    # entire remainder of the tag.
    prefix = CHANNEL_TAG_TEMPLATE[channel].format(version=version, run_id="")
    if not tag.startswith(prefix):
        raise ContractError(f"{channel} tag does not name the manifest version")
    run_id = tag[len(prefix):]
    if RUN_ID_RE.fullmatch(run_id) is None:
        raise ContractError(f"{channel} tag does not end in a positive decimal run id")
    composed = f"{version}.{run_id}"
    # Ordering is the whole point of composing it, so it has to be orderable.
    ordered_version(composed, "composed formula version")
    return composed


def ordered_version(value: str, label: str) -> tuple[int, ...]:
    """A comparable key for two versions that are both plain dotted numbers.

    Deliberately narrow. soma-work's version grammar allows `+`, `_` and `-`,
    and there is no agreed ordering for those here, so anything that is not a
    dotted numeric string is unorderable and refused rather than guessed at.
    """
    parts = value.split(".")
    if not all(part.isdigit() for part in parts):
        raise ContractError(f"{label} is not a comparable dotted numeric version")
    return tuple(int(part) for part in parts)


def regular_file(path: Path, label: str) -> bytes:
    try:
        metadata = path.lstat()
    except OSError as error:
        raise ContractError(f"{label} is unavailable") from error
    if stat.S_ISLNK(metadata.st_mode) or not stat.S_ISREG(metadata.st_mode):
        raise ContractError(f"{label} must be a regular file, not a symlink")
    try:
        return path.read_bytes()
    except OSError as error:
        raise ContractError(f"{label} is unreadable") from error


# --- Manifest validation ------------------------------------------------------


def validate(document: Any, args: argparse.Namespace) -> dict[str, Any]:
    """Return the render context, or raise. Reads nothing outside `document`."""

    # The dispatch identity first: the manifest is only trusted once the bytes
    # it arrived as have been pinned to the digest the release announced.
    tag = exact_string(args.tag, TAG_RE, "dispatch tag")
    exact_string(args.source_sha, SOURCE_SHA_RE, "dispatch source SHA")
    exact_string(args.manifest_sha256, SHA256_RE, "dispatch manifest SHA-256")
    exact_string(args.source_repository, REPOSITORY_RE, "dispatch source repository")
    if args.source_repository != SOURCE_REPOSITORY:
        raise ContractError("dispatch source repository is not the somawork project")
    base_url = f"{RELEASE_ORIGIN}/{SOURCE_REPOSITORY}/releases/download/{tag}"
    if args.manifest_url != f"{base_url}/{MANIFEST_FILENAME}":
        raise ContractError("dispatch manifest URL is not the exact immutable release URL")

    manifest = exact_object(document, MANIFEST_KEYS, "manifest")
    exact_integer(manifest["schemaVersion"], SCHEMA_VERSION, "manifest schema version")
    exact_integer(manifest["layoutVersion"], LAYOUT_VERSION, "manifest layout version")
    channel = manifest["channel"]
    if channel not in CHANNEL_PACKAGE:
        raise ContractError("manifest channel is not a known release channel")
    if args.package != CHANNEL_PACKAGE[channel]:
        raise ContractError("dispatch package does not match the manifest channel")
    if manifest["tag"] != tag:
        raise ContractError("manifest tag does not match the dispatch")
    if manifest["sourceSha"] != args.source_sha:
        raise ContractError("manifest source SHA does not match the resolved release commit")
    if manifest["platform"] != PLATFORM:
        raise ContractError("manifest platform is not the supported platform")
    if manifest["baseUrl"] != base_url:
        raise ContractError("manifest base URL is not the canonical release origin")
    version = exact_string(manifest["version"], VERSION_RE, "manifest version")
    minimum_node = exact_string(manifest["minimumNode"], SEMVER_RE, "manifest minimum Node")
    if semver(minimum_node, "manifest minimum Node") > MAXIMUM_MINIMUM_NODE:
        raise ContractError(
            "manifest raises the Node floor above the version this tap has verified"
        )
    rendered_version = formula_version(channel, version, tag)
    enforce_floors(args, rendered_version)

    layout = exact_object(manifest["layout"], LAYOUT_KEYS, "manifest layout")
    if layout["install"] != INSTALL_MODE:
        raise ContractError("manifest layout install mode is not prefix-rooted")
    controller_layout = exact_object(
        layout["controller"], CONTROLLER_LAYOUT_KEYS, "manifest controller layout"
    )
    runtime_layout = exact_object(
        layout["runtime"], RUNTIME_LAYOUT_KEYS, "manifest runtime layout"
    )
    # Depth is load-bearing, not decoration: the controller resolves its own
    # package.json two directories above its entry, so a two-segment entry would
    # install fine and then report an unknown version.
    controller_entry = layout_path(controller_layout["entry"], "controller.entry", 3)
    controller_manifest = layout_path(controller_layout["manifest"], "controller.manifest", 1)
    runtime = {
        "marker": layout_path(runtime_layout["marker"], "runtime.marker", 1),
        "manifest": layout_path(runtime_layout["manifest"], "runtime.manifest", 1),
        "controllerEntry": layout_path(runtime_layout["controllerEntry"], "runtime.controllerEntry"),
        "supervisor": layout_path(runtime_layout["supervisor"], "runtime.supervisor"),
        "daemon": layout_path(runtime_layout["daemon"], "runtime.daemon"),
    }

    assets_value = manifest["assets"]
    if not isinstance(assets_value, list) or len(assets_value) != len(EXPECTED_ASSETS):
        raise ContractError("manifest must describe exactly three assets")
    assets: dict[str, dict[str, Any]] = {}
    for index, (value, (package, profile)) in enumerate(zip(assets_value, EXPECTED_ASSETS)):
        asset = exact_object(value, ASSET_KEYS, f"manifest asset {index}")
        if asset["package"] != package:
            raise ContractError(f"manifest asset {index} must be {package}")
        if asset["profile"] != profile:
            raise ContractError(f"manifest asset {package} must install profile {profile}")
        filename = f"{package}-{version}-{PLATFORM}.tar.gz"
        if asset["filename"] != filename:
            raise ContractError(f"manifest asset {package} filename must be {filename}")
        if asset["url"] != f"{base_url}/{filename}":
            raise ContractError(f"manifest asset {package} URL is not the immutable release URL")
        exact_string(asset["sha256"], SHA256_RE, f"manifest asset {package} SHA-256")
        positive_integer(asset["bytes"], f"manifest asset {package} byte count")
        assets[package] = asset

    return {
        "version": rendered_version,
        "package_version": version,
        "tag": tag,
        "source_sha": args.source_sha,
        "channel": channel,
        "platform": PLATFORM,
        "layout_version": str(LAYOUT_VERSION),
        "minimum_node": minimum_node,
        "manifest_url": args.manifest_url,
        "manifest_sha256": args.manifest_sha256,
        "controller_entry": controller_entry,
        "controller_manifest": controller_manifest,
        "runtime": runtime,
        "assets": assets,
    }


# --- Rendering ----------------------------------------------------------------


def installed_version(output: Path) -> str | None:
    """The version currently written in a formula this run would replace."""
    if output.is_symlink() or not output.is_file():
        return None
    try:
        existing = output.read_text(encoding="utf-8")
    except (OSError, UnicodeDecodeError):
        # Not something this renderer wrote. `write_all_or_nothing` refuses
        # anything that is not a plain readable file; do not guess a floor here.
        return None
    match = INSTALLED_VERSION_RE.search(existing)
    return None if match is None else match.group(1)


def enforce_floors(args: argparse.Namespace, rendered_version: str) -> None:
    """Refuse a release older than anything this run would overwrite.

    The floors are **intrinsic first**: this tool reads the version out of each
    formula it is about to replace, so "never downgrade" is a property of the
    renderer rather than of the workflow remembering to pass `--not-below`. A
    caller may add floors — the write job passes what it read, which is a useful
    cross-check against a mid-run change — but nothing a caller passes can remove
    one, because the two sets are merged and every member binds independently.

    Every floor is checked separately rather than reduced to a maximum. Same
    arithmetic, but the result does not depend on whoever computed the maximum
    having done it right.
    """
    rendered_order = ordered_version(rendered_version, "rendered formula version")
    intrinsic = [
        version
        for version in (installed_version(args.controller_output), installed_version(args.runtime_output))
        if version is not None
    ]
    for baseline in [*intrinsic, *args.not_below]:
        if rendered_order < ordered_version(baseline, "installed formula version"):
            raise ContractError("rendered version is below an installed formula version")


def render(template: str, replacements: dict[str, str], label: str) -> str:
    rendered = template
    for placeholder, value in replacements.items():
        if placeholder not in rendered:
            raise ContractError(f"{label} never uses the placeholder {placeholder}")
        rendered = rendered.replace(placeholder, value)
    leftover = PLACEHOLDER_RE.search(rendered)
    if leftover is not None:
        raise ContractError(f"{label} contains an unknown placeholder: {leftover.group(0)}")
    return rendered


def common_replacements(context: dict[str, Any]) -> dict[str, str]:
    return {
        "@VERSION@": context["version"],
        "@PACKAGE_VERSION@": context["package_version"],
        "@TAG@": context["tag"],
        "@SOURCE_SHA@": context["source_sha"],
        "@CHANNEL@": context["channel"],
        "@PLATFORM@": context["platform"],
        "@LAYOUT_VERSION@": context["layout_version"],
        "@MANIFEST_URL@": context["manifest_url"],
        "@MANIFEST_SHA256@": context["manifest_sha256"],
    }


def runtime_replacements(context: dict[str, Any]) -> dict[str, str]:
    runtime = context["runtime"]
    return {
        "@RUNTIME_MARKER@": runtime["marker"],
        "@RUNTIME_MANIFEST@": runtime["manifest"],
        "@RUNTIME_CONTROLLER_ENTRY@": runtime["controllerEntry"],
        "@RUNTIME_SUPERVISOR@": runtime["supervisor"],
        "@RUNTIME_DAEMON@": runtime["daemon"],
    }


def plan(context: dict[str, Any], args: argparse.Namespace) -> list[tuple[Path, str]]:
    """The controller and exactly one runtime — never the other channel's."""

    assets = context["assets"]
    controller = assets["somawork-cli"]
    # `args.package` is the channel's formula name, already checked against the
    # manifest's channel, so this is the selected runtime by construction.
    runtime = assets[args.package]

    controller_replacements = {
        **common_replacements(context),
        "@MINIMUM_NODE@": context["minimum_node"],
        "@CONTROLLER_URL@": controller["url"],
        "@CONTROLLER_SHA256@": controller["sha256"],
        "@CONTROLLER_ENTRY@": context["controller_entry"],
        "@CONTROLLER_MANIFEST@": context["controller_manifest"],
    }
    runtime_replacements_all = {
        **common_replacements(context),
        **runtime_replacements(context),
        "@RUNTIME_URL@": runtime["url"],
        "@RUNTIME_SHA256@": runtime["sha256"],
    }

    outputs: list[tuple[Path, str]] = []
    for template_path, output_path, replacements, label in (
        (args.controller_template, args.controller_output, controller_replacements, "controller template"),
        (args.runtime_template, args.runtime_output, runtime_replacements_all, f"{args.package} template"),
    ):
        template = regular_file(template_path, label).decode("utf-8")
        outputs.append((output_path, render(template, replacements, label)))
    return outputs


def check_paths(args: argparse.Namespace) -> None:
    """Bind the output paths to the channel before anything is rendered.

    The renderer cannot write the other channel's formula because it is never
    handed its path — but only if the paths it *is* handed are the ones the
    channel owns. A dispatch that passed `--runtime-output Formula/somawork.rb`
    with `--package somawork-preview` would otherwise publish preview bits as
    stable, and that is the exact confusion this check exists to make impossible.
    """
    if args.controller_template.name != "somawork-cli.rb.tmpl":
        raise ContractError("controller template is not the controller's template")
    if args.controller_output.name != "somawork-cli.rb":
        raise ContractError("controller output is not the controller's formula")
    if args.runtime_template.name != f"{args.package}.rb.tmpl":
        raise ContractError("runtime template does not belong to the dispatched channel")
    if args.runtime_output.name != f"{args.package}.rb":
        raise ContractError("runtime output does not belong to the dispatched channel")
    if args.package not in set(CHANNEL_PACKAGE.values()):
        raise ContractError("dispatch package is not a somawork release channel")
    if args.controller_output.resolve() == args.runtime_output.resolve():
        raise ContractError("controller and runtime would be written to one path")


def check_no_silent_replacement(outputs: list[tuple[Path, str]], rendered_version: str) -> None:
    """An equal version may only ever mean "the very same release, again".

    `--not-below` refuses a version that went backwards, but it cannot see the
    case where a release renders the *same* version as the file already on disk
    while saying something different — a different tag, a different commit, a
    different digest. Homebrew would not treat that as an upgrade, so the tap
    would be serving bytes nobody could get to. The only equal-version write this
    renderer allows is the byte-for-byte identical one, which is exactly what an
    idempotent re-dispatch of the same release produces.
    """
    for output, content in outputs:
        if output.is_symlink() or not output.exists():
            continue
        try:
            existing = output.read_bytes().decode("utf-8")
        except (OSError, UnicodeDecodeError):
            # Not something this renderer wrote. The write path refuses anything
            # that is not a plain readable file, so leave the message to it.
            continue
        match = INSTALLED_VERSION_RE.search(existing)
        if match is None or match.group(1) != rendered_version:
            continue
        if existing != content:
            raise ContractError(
                f"{output.name} already exists at this version with different contents"
            )


def write_all_or_nothing(outputs: list[tuple[Path, str]]) -> None:
    """Stage every formula, then swap them in; restore on any failure."""

    staged: list[tuple[Path, Path]] = []
    previous: dict[Path, bytes | None] = {}
    replaced: list[Path] = []
    try:
        for output, content in outputs:
            if output.is_symlink():
                raise ContractError(f"output must be a regular file, not a symlink: {output}")
            if output.exists() and not output.is_file():
                raise ContractError(f"output must be a regular file: {output}")
            previous[output] = output.read_bytes() if output.exists() else None
            output.parent.mkdir(parents=True, exist_ok=True)
            descriptor, temporary_name = tempfile.mkstemp(
                dir=output.parent, prefix=f".{output.name}.", suffix=".tmp"
            )
            temporary = Path(temporary_name)
            staged.append((temporary, output))
            with os.fdopen(descriptor, "w", encoding="utf-8", newline="\n") as handle:
                handle.write(content)
                handle.flush()
                os.fsync(handle.fileno())
            os.chmod(temporary, 0o644)

        # Nothing above this line changed a tracked file; nothing below it can
        # fail for a reason the caller could have detected earlier.
        for temporary, output in staged:
            os.replace(temporary, output)
            replaced.append(output)
        for directory in {output.parent for _, output in staged}:
            handle = os.open(directory, os.O_RDONLY)
            try:
                os.fsync(handle)
            finally:
                os.close(handle)
    except BaseException:
        for output in replaced:
            original = previous.get(output)
            if original is None:
                output.unlink(missing_ok=True)
            else:
                output.write_bytes(original)
        raise
    finally:
        for temporary, _ in staged:
            temporary.unlink(missing_ok=True)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--tag", required=True)
    parser.add_argument("--package", required=True)
    parser.add_argument("--source-repository", required=True)
    parser.add_argument("--source-sha", required=True)
    parser.add_argument("--manifest-url", required=True)
    parser.add_argument("--manifest-sha256", required=True)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--not-below", action="append", default=[])
    parser.add_argument("--controller-template", required=True, type=Path)
    parser.add_argument("--controller-output", required=True, type=Path)
    parser.add_argument("--runtime-template", required=True, type=Path)
    parser.add_argument("--runtime-output", required=True, type=Path)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        check_paths(args)
        manifest_bytes = regular_file(args.manifest, "manifest")
        if hashlib.sha256(manifest_bytes).hexdigest() != args.manifest_sha256:
            raise ContractError("manifest SHA-256 does not match the dispatch")
        try:
            document = json.loads(manifest_bytes, object_pairs_hook=unique_object)
        except (UnicodeDecodeError, json.JSONDecodeError) as error:
            raise ContractError("manifest is not valid UTF-8 JSON") from error
        context = validate(document, args)
        outputs = plan(context, args)
        check_no_silent_replacement(outputs, context["version"])
        write_all_or_nothing(outputs)
    except (ContractError, OSError, UnicodeDecodeError) as error:
        print(f"somawork formulae: {error}", file=sys.stderr)
        return 1
    print(f"somawork formulae: ok: {args.controller_output}, {args.runtime_output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
