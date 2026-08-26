#!/usr/bin/env python3
"""Measure and inspect one somawork release payload, without running any of it.

This is the unprivileged half of the tap bump. It runs in a job that holds no
repository credential, on bytes that were downloaded from a public release, and
its whole output is a small non-secret JSON receipt the privileged job then
re-derives from the manifest and compares against.

**It never executes the payload.** dbotter's equivalent runs a Linux candidate
binary to read its identity; there is no such option here, because the somawork
assets are macOS-arm64 Node trees and the runner is Linux — and because a
formula does not need the payload to run in order to be correct. What a formula
needs is that the tree it will drop at a keg prefix actually contains the paths
the formula asserts. So this reads the archives with `tarfile` and checks:

- the bytes match the manifest's SHA-256 and byte count, asset by asset;
- no member escapes the extraction root, and no member is a device, a FIFO or a
  setuid file;
- the controller archive carries its declared entry, executable, plus a
  `package.json` naming that same entry as `bin.somawork`;
- each runtime archive carries every path the controller's discovery requires,
  and a release marker whose package/profile/version/commit agree with the
  manifest;
- no archive carries a top-level directory Homebrew would link (`bin`, `lib`,
  `share`, …), which for the controller would collide with the symlink the
  formula creates itself;
- every top-level entry is reachable by `Dir["*"] + Dir[".[^.]*"]`, which is
  literally what the formula's `install` runs — an entry named `..foo` would be
  silently left behind in the build directory;
- the archive presents at least two non-dot top-level entries, so Homebrew does
  not re-root the build. `AbstractFileDownloadStrategy#chdir` descends into the
  single entry when `Dir["*"].length == 1 && File.directory?`, and if it did that
  here `prefix.install Dir["*"]` would install that directory's *contents* at the
  keg root — one level above where the manifest says they are. Task 1's layout
  always has at least `package.json` plus a directory, so this is a precondition
  being made explicit rather than a restriction being added.

There is no network access here either: the caller downloads, this measures.
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
import tarfile
import tempfile
from pathlib import Path
from typing import Any


SCHEMA_VERSION = 1
LAYOUT_VERSION = 1
RELEASE_ORIGIN = "https://github.com"
SOURCE_REPOSITORY = "2lab-ai/soma-work"
PLATFORM = "darwin-arm64"
INSTALL_MODE = "prefix"
PROOF_SCHEMA = "somawork.tap-preflight.v1"

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
MARKER_KEYS = {
    "schemaVersion",
    "package",
    "profile",
    "channel",
    "version",
    "sourceSha",
    "platform",
    "layoutVersion",
}
EXPECTED_ASSETS = (
    ("somawork-cli", None),
    ("somawork", "production"),
    ("somawork-preview", "preview"),
)
CHANNELS = {"preview", "stable"}

# Homebrew links exactly these top-level directories out of a keg. A release
# archive that carried one would put the two runtime kegs, or the controller and
# its own `bin/somawork` symlink, in a fight over the same path.
RESERVED_TOP_LEVEL = {"bin", "sbin", "lib", "include", "share", "etc", "var", "Frameworks"}

VERSION_RE = re.compile(r"^[0-9A-Za-z][0-9A-Za-z.+_-]{0,63}$")
TAG_RE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$")
SOURCE_SHA_RE = re.compile(r"^[0-9a-f]{40}$")
SHA256_RE = re.compile(r"^[0-9a-f]{64}$")
SEMVER_RE = re.compile(r"^\d+\.\d+\.\d+$")
LAYOUT_PATH_RE = re.compile(
    r"^[A-Za-z0-9._][A-Za-z0-9._-]*(?:/[A-Za-z0-9._][A-Za-z0-9._-]*)*$"
)
# The upper bound on what this job will unpack. The real archives are ~62 MB
# compressed; a decompression bomb is the one way a read-only inspector can
# still take a runner down.
MAX_MEMBERS = 200_000
MAX_EXTRACTED_BYTES = 4 * 1024 * 1024 * 1024


class PreflightError(ValueError):
    """Raised when a release payload cannot safely back a formula."""


def unique_object(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    value: dict[str, Any] = {}
    for key, item in pairs:
        if key in value:
            raise PreflightError(f"duplicate JSON object key: {key}")
        value[key] = item
    return value


def exact_object(value: Any, keys: set[str], label: str) -> dict[str, Any]:
    if not isinstance(value, dict) or set(value) != keys:
        raise PreflightError(f"{label} fields are not exact")
    return value


def exact_string(value: Any, pattern: re.Pattern[str], label: str) -> str:
    if not isinstance(value, str) or pattern.fullmatch(value) is None:
        raise PreflightError(f"{label} is invalid")
    return value


def exact_integer(value: Any, expected: int, label: str) -> int:
    if type(value) is not int or value != expected:
        raise PreflightError(f"{label} is not the exact integer {expected}")
    return value


def positive_integer(value: Any, label: str) -> int:
    if type(value) is not int or value < 1:
        raise PreflightError(f"{label} is not a positive integer")
    return value


def layout_path(value: Any, label: str, depth: int | None = None) -> str:
    if (
        not isinstance(value, str)
        or LAYOUT_PATH_RE.fullmatch(value) is None
        or ".." in value.split("/")
        or "." in value.split("/")
        or posixpath.normpath(value) != value
    ):
        raise PreflightError(f"layout {label} is not a safe, normalized relative path")
    if depth is not None and len(value.split("/")) != depth:
        raise PreflightError(f"layout {label} must be {depth} path segments deep")
    return value


def load_json_file(path: Path, label: str) -> dict[str, Any]:
    try:
        metadata = path.lstat()
        if stat.S_ISLNK(metadata.st_mode) or not stat.S_ISREG(metadata.st_mode):
            raise PreflightError(f"{label} must be a regular file, not a link")
        with path.open("r", encoding="utf-8") as handle:
            value = json.load(handle, object_pairs_hook=unique_object)
    except FileNotFoundError as error:
        raise PreflightError(f"{label} does not exist") from error
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise PreflightError(f"{label} is not valid readable UTF-8 JSON") from error
    if not isinstance(value, dict):
        raise PreflightError(f"{label} must be a JSON object")
    return value


def sha256_of(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


# --- Manifest -----------------------------------------------------------------


def validate_manifest(document: dict[str, Any]) -> dict[str, Any]:
    manifest = exact_object(document, MANIFEST_KEYS, "manifest")
    exact_integer(manifest["schemaVersion"], SCHEMA_VERSION, "manifest schema version")
    exact_integer(manifest["layoutVersion"], LAYOUT_VERSION, "manifest layout version")
    channel = manifest["channel"]
    if channel not in CHANNELS:
        raise PreflightError("manifest channel is not a known release channel")
    version = exact_string(manifest["version"], VERSION_RE, "manifest version")
    tag = exact_string(manifest["tag"], TAG_RE, "manifest tag")
    source_sha = exact_string(manifest["sourceSha"], SOURCE_SHA_RE, "manifest source SHA")
    if manifest["platform"] != PLATFORM:
        raise PreflightError("manifest platform is not the supported platform")
    exact_string(manifest["minimumNode"], SEMVER_RE, "manifest minimum Node")
    base_url = f"{RELEASE_ORIGIN}/{SOURCE_REPOSITORY}/releases/download/{tag}"
    if manifest["baseUrl"] != base_url:
        raise PreflightError("manifest base URL is not the canonical release origin")

    layout = exact_object(manifest["layout"], LAYOUT_KEYS, "manifest layout")
    if layout["install"] != INSTALL_MODE:
        raise PreflightError("manifest layout install mode is not prefix-rooted")
    controller_layout = exact_object(
        layout["controller"], CONTROLLER_LAYOUT_KEYS, "manifest controller layout"
    )
    runtime_layout = exact_object(
        layout["runtime"], RUNTIME_LAYOUT_KEYS, "manifest runtime layout"
    )
    controller = {
        "entry": layout_path(controller_layout["entry"], "controller.entry", 3),
        "manifest": layout_path(controller_layout["manifest"], "controller.manifest", 1),
    }
    runtime = {
        "marker": layout_path(runtime_layout["marker"], "runtime.marker", 1),
        "manifest": layout_path(runtime_layout["manifest"], "runtime.manifest", 1),
        "controllerEntry": layout_path(runtime_layout["controllerEntry"], "runtime.controllerEntry"),
        "supervisor": layout_path(runtime_layout["supervisor"], "runtime.supervisor"),
        "daemon": layout_path(runtime_layout["daemon"], "runtime.daemon"),
    }

    assets_value = manifest["assets"]
    if not isinstance(assets_value, list) or len(assets_value) != len(EXPECTED_ASSETS):
        raise PreflightError("manifest must describe exactly three assets")
    assets: list[dict[str, Any]] = []
    for index, (value, (package, profile)) in enumerate(zip(assets_value, EXPECTED_ASSETS)):
        asset = exact_object(value, ASSET_KEYS, f"manifest asset {index}")
        if asset["package"] != package:
            raise PreflightError(f"manifest asset {index} must be {package}")
        if asset["profile"] != profile:
            raise PreflightError(f"manifest asset {package} must install profile {profile}")
        filename = f"{package}-{version}-{PLATFORM}.tar.gz"
        if asset["filename"] != filename:
            raise PreflightError(f"manifest asset {package} filename must be {filename}")
        if asset["url"] != f"{base_url}/{filename}":
            raise PreflightError(f"manifest asset {package} URL is not the immutable release URL")
        exact_string(asset["sha256"], SHA256_RE, f"manifest asset {package} SHA-256")
        positive_integer(asset["bytes"], f"manifest asset {package} byte count")
        assets.append(asset)

    return {
        "tag": tag,
        "version": version,
        "sourceSha": source_sha,
        "channel": channel,
        "platform": PLATFORM,
        "layoutVersion": LAYOUT_VERSION,
        "minimumNode": manifest["minimumNode"],
        "controller": controller,
        "runtime": runtime,
        "assets": assets,
    }


# --- Archive inspection -------------------------------------------------------


def safe_extract(archive: Path, destination: Path, label: str) -> list[str]:
    """Extract one archive, refusing anything that could leave `destination`.

    Returns the sorted set of top-level member names. `tarfile` is a reader; no
    member is ever executed, and the mode bits that are honoured are narrowed to
    the owner-execute bit the controller entry needs.
    """
    top_level: set[str] = set()
    total_bytes = 0
    try:
        with tarfile.open(archive, "r:gz") as handle:
            # Belt and braces: our own member vetting below is the contract, but
            # Python's own `tar` filter is free and refuses the same class of
            # names on the versions that ship it.
            if hasattr(tarfile, "tar_filter"):
                handle.extraction_filter = tarfile.tar_filter
            for count, member in enumerate(handle):
                if count >= MAX_MEMBERS:
                    raise PreflightError(f"{label} contains too many members")
                name = member.name
                if name in (".", "./"):
                    continue
                if name.startswith("./"):
                    name = name[2:]
                if (
                    name == ""
                    or name.startswith("/")
                    or ".." in name.split("/")
                    or "\\" in name
                    or any(ord(character) < 32 for character in name)
                    or posixpath.normpath(name) != name
                ):
                    raise PreflightError(f"{label} member name is unsafe: {member.name!r}")
                if member.ischr() or member.isblk() or member.isfifo() or member.isdev():
                    raise PreflightError(f"{label} carries a device or FIFO member")
                if member.islnk():
                    raise PreflightError(f"{label} carries a hard link")
                if member.mode & (stat.S_ISUID | stat.S_ISGID):
                    raise PreflightError(f"{label} carries a setuid or setgid member")
                if member.issym():
                    target = posixpath.normpath(
                        posixpath.join(posixpath.dirname(name), member.linkname)
                    )
                    if member.linkname.startswith("/") or target.startswith(".."):
                        raise PreflightError(f"{label} carries a symlink that escapes the tree")
                if member.isreg():
                    total_bytes += member.size
                    if total_bytes > MAX_EXTRACTED_BYTES:
                        raise PreflightError(f"{label} expands beyond the inspection budget")
                top_level.add(name.split("/")[0])
                member.name = name
                member.uid = 0
                member.gid = 0
                member.uname = ""
                member.gname = ""
                if member.isreg():
                    member.mode = 0o755 if member.mode & stat.S_IXUSR else 0o644
                elif member.isdir():
                    member.mode = 0o755
                handle.extract(member, destination, set_attrs=True)
    except tarfile.TarError as error:
        raise PreflightError(f"{label} is not a readable gzip tar archive") from error
    return sorted(top_level)


def reserved_top_level(names: list[str]) -> list[str]:
    return sorted(name for name in names if name in RESERVED_TOP_LEVEL)


def top_level_installable(names: list[str]) -> bool:
    """True when `Dir["*"] + Dir[".[^.]*"]` reaches every top-level entry."""
    return all(name != ".." and not name.startswith("..") for name in names)


def re_roots_on_install(names: list[str]) -> bool:
    """True when Homebrew would `chdir` into a lone top-level directory.

    Homebrew stages an archive and then, if the staged directory holds exactly
    one non-dot entry and that entry is a directory, treats *that* as the build
    root. A payload shaped like `somawork-1.0.0/...` would therefore be installed
    one level higher than the manifest describes, and the formula's own layout
    assertions would be checking paths that are not where the files went.
    """
    visible = [name for name in names if not name.startswith(".")]
    return len(visible) < 2


def require_regular(root: Path, relative: str, label: str) -> os.stat_result:
    path = root / relative
    try:
        metadata = path.lstat()
    except OSError as error:
        raise PreflightError(f"{label} is missing {relative}") from error
    if stat.S_ISLNK(metadata.st_mode) or not stat.S_ISREG(metadata.st_mode):
        raise PreflightError(f"{label} entry {relative} is not a regular file")
    return metadata


def inspect_controller(root: Path, top_level: list[str], release: dict[str, Any]) -> dict[str, Any]:
    layout = release["controller"]
    entry = layout["entry"]
    metadata = require_regular(root, entry, "controller archive")
    if metadata.st_mode & stat.S_IXUSR == 0:
        raise PreflightError("controller entry is not executable")
    require_regular(root, layout["manifest"], "controller archive")
    package = load_json_file(root / layout["manifest"], "controller package.json")
    if package.get("name") != "somawork-cli":
        raise PreflightError("controller package.json does not name the controller package")
    if package.get("version") != release["version"]:
        raise PreflightError("controller package.json version disagrees with the manifest")
    binaries = package.get("bin")
    if not isinstance(binaries, dict) or binaries.get("somawork") != entry:
        raise PreflightError("controller package.json does not point somawork at the entry")
    engines = package.get("engines")
    if not isinstance(engines, dict) or engines.get("node") != f">={release['minimumNode']}":
        raise PreflightError("controller package.json Node floor disagrees with the manifest")
    inspect_marker(root, release, "somawork-cli", None)
    return {
        "entry": entry,
        "entryMode": "0755",
        "manifest": layout["manifest"],
        "manifestName": "somawork-cli",
        "manifestVersion": release["version"],
        "reservedTopLevelDirectories": reserved_top_level(top_level),
        "topLevelInstallable": top_level_installable(top_level),
        "reRootsOnInstall": re_roots_on_install(top_level),
    }


def inspect_marker(root: Path, release: dict[str, Any], package: str, profile: str | None) -> None:
    relative = release["runtime"]["marker"]
    require_regular(root, relative, f"{package} archive")
    marker = exact_object(
        load_json_file(root / relative, f"{package} release marker"),
        MARKER_KEYS,
        f"{package} release marker",
    )
    expected = {
        "schemaVersion": SCHEMA_VERSION,
        "package": package,
        "profile": profile,
        "channel": release["channel"],
        "version": release["version"],
        "sourceSha": release["sourceSha"],
        "platform": PLATFORM,
        "layoutVersion": LAYOUT_VERSION,
    }
    if marker != expected:
        raise PreflightError(f"{package} release marker disagrees with the manifest")


def inspect_runtime(
    root: Path, top_level: list[str], release: dict[str, Any], package: str, profile: str
) -> dict[str, Any]:
    layout = release["runtime"]
    entries = sorted({layout["controllerEntry"], layout["supervisor"], layout["daemon"]})
    for relative in entries:
        require_regular(root, relative, f"{package} archive")
    require_regular(root, layout["manifest"], f"{package} archive")
    package_json = load_json_file(root / layout["manifest"], f"{package} package.json")
    if package_json.get("version") != release["version"]:
        raise PreflightError(f"{package} package.json version disagrees with the manifest")
    inspect_marker(root, release, package, profile)
    return {
        "marker": layout["marker"],
        "markerPackage": package,
        "markerProfile": profile,
        "manifest": layout["manifest"],
        "manifestVersion": release["version"],
        "entries": entries,
        "reservedTopLevelDirectories": reserved_top_level(top_level),
        "topLevelInstallable": top_level_installable(top_level),
        "reRootsOnInstall": re_roots_on_install(top_level),
    }


def measure(release: dict[str, Any], assets_dir: Path, workspace: Path) -> list[dict[str, Any]]:
    receipts: list[dict[str, Any]] = []
    for asset in release["assets"]:
        package = asset["package"]
        profile = asset["profile"]
        path = assets_dir / asset["filename"]
        try:
            metadata = path.lstat()
        except OSError as error:
            raise PreflightError(f"{package} archive is missing") from error
        if stat.S_ISLNK(metadata.st_mode) or not stat.S_ISREG(metadata.st_mode):
            raise PreflightError(f"{package} archive is not a regular file")
        if metadata.st_size != asset["bytes"]:
            raise PreflightError(f"{package} archive byte count disagrees with the manifest")
        digest = sha256_of(path)
        if digest != asset["sha256"]:
            raise PreflightError(f"{package} archive digest disagrees with the manifest")

        root = workspace / package
        root.mkdir(parents=True)
        top_level = safe_extract(path, root, f"{package} archive")
        # Fail here, not in the receipt. The privileged job re-checks both of
        # these, but an archive that would collide with Homebrew's link tree, or
        # that carries an entry the formula's own `install` glob cannot see, is
        # not something to record and pass along — it is a refusal.
        collisions = reserved_top_level(top_level)
        if collisions:
            raise PreflightError(
                f"{package} archive carries Homebrew-linkable directories: {', '.join(collisions)}"
            )
        if not top_level_installable(top_level):
            raise PreflightError(
                f"{package} archive carries a top-level entry the formula would not install"
            )
        if re_roots_on_install(top_level):
            raise PreflightError(
                f"{package} archive would be re-rooted by Homebrew into a single top-level directory"
            )
        if profile is None:
            installable = inspect_controller(root, top_level, release)
        else:
            installable = inspect_runtime(root, top_level, release, package, profile)
        receipts.append(
            {
                "package": package,
                "profile": profile,
                "filename": asset["filename"],
                "url": asset["url"],
                "bytes": metadata.st_size,
                "sha256": digest,
                "installable": installable,
            }
        )
    return receipts


def write_no_replace(output: Path, document: dict[str, Any]) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    try:
        parent = output.parent.lstat()
    except OSError as error:
        raise PreflightError("output parent is unavailable") from error
    if stat.S_ISLNK(parent.st_mode) or not stat.S_ISDIR(parent.st_mode):
        raise PreflightError("output parent must be a real directory")
    if output.exists() or output.is_symlink():
        raise PreflightError("output already exists")
    descriptor, temporary_name = tempfile.mkstemp(
        dir=output.parent, prefix=f".{output.name}.", suffix=".tmp"
    )
    temporary = Path(temporary_name)
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8", newline="\n") as handle:
            json.dump(document, handle, indent=2, sort_keys=True)
            handle.write("\n")
            handle.flush()
            os.fsync(handle.fileno())
        os.chmod(temporary, 0o644)
        try:
            os.link(temporary, output)
        except FileExistsError as error:
            raise PreflightError("output already exists") from error
        handle_directory = os.open(output.parent, os.O_RDONLY)
        try:
            os.fsync(handle_directory)
        finally:
            os.close(handle_directory)
    finally:
        temporary.unlink(missing_ok=True)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--assets-dir", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    workspace: tempfile.TemporaryDirectory[str] | None = None
    try:
        assets_metadata = args.assets_dir.lstat()
        if stat.S_ISLNK(assets_metadata.st_mode) or not stat.S_ISDIR(assets_metadata.st_mode):
            raise PreflightError("assets directory must be a real directory")
        release = validate_manifest(load_json_file(args.manifest, "manifest"))
        workspace = tempfile.TemporaryDirectory(prefix="somawork-preflight-")
        receipts = measure(release, args.assets_dir, Path(workspace.name))
        write_no_replace(
            args.output,
            {
                "schema": PROOF_SCHEMA,
                "release": {
                    "tag": release["tag"],
                    "version": release["version"],
                    "sourceSha": release["sourceSha"],
                    "channel": release["channel"],
                    "platform": release["platform"],
                    "layoutVersion": release["layoutVersion"],
                    "minimumNode": release["minimumNode"],
                },
                "assets": receipts,
            },
        )
    except (OSError, PreflightError) as error:
        print(f"somawork preflight: {error}", file=sys.stderr)
        return 1
    finally:
        if workspace is not None:
            workspace.cleanup()
    print(f"somawork preflight: ok: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
