#!/usr/bin/env python3
"""Revalidate an unprivileged somawork preflight before the tap writes anything.

The write job holds `contents: write`. It must therefore not download a release
archive, must not run one, and must not take the preflight job's word for
anything. What it does instead is cheap and total: re-derive, from the manifest
bytes whose digest the dispatch pinned, the *entire* receipt an honest preflight
would have produced — every measurement and every layout finding — and require
the uploaded proof to equal it exactly.

That equality is what makes the artifact hop safe. A tampered proof cannot smuggle
in a different digest, a different profile, or a "yes the entry is executable"
for an archive that has no entry: any of those makes the reconstructed document
differ, and this exits 1 before the renderer is ever called.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import posixpath
import re
import stat
import sys
from pathlib import Path
from typing import Any


SCHEMA_VERSION = 1
LAYOUT_VERSION = 1
RELEASE_ORIGIN = "https://github.com"
SOURCE_REPOSITORY = "2lab-ai/soma-work"
MANIFEST_FILENAME = "somawork-manifest.json"
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
PROOF_KEYS = {"schema", "release", "assets"}
RELEASE_KEYS = {
    "tag",
    "version",
    "sourceSha",
    "channel",
    "platform",
    "layoutVersion",
    "minimumNode",
}
RECEIPT_KEYS = {"package", "profile", "filename", "url", "bytes", "sha256", "installable"}
CONTROLLER_RECEIPT_KEYS = {
    "entry",
    "entryMode",
    "manifest",
    "manifestName",
    "manifestVersion",
    "reservedTopLevelDirectories",
    "topLevelInstallable",
    "reRootsOnInstall",
}
RUNTIME_RECEIPT_KEYS = {
    "marker",
    "markerPackage",
    "markerProfile",
    "manifest",
    "manifestVersion",
    "entries",
    "reservedTopLevelDirectories",
    "topLevelInstallable",
    "reRootsOnInstall",
}
EXPECTED_ASSETS = (
    ("somawork-cli", None),
    ("somawork", "production"),
    ("somawork-preview", "preview"),
)
CHANNEL_PACKAGE = {"preview": "somawork-preview", "stable": "somawork"}

VERSION_RE = re.compile(r"^[0-9A-Za-z][0-9A-Za-z.+_-]{0,63}$")
TAG_RE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$")
SOURCE_SHA_RE = re.compile(r"^[0-9a-f]{40}$")
SHA256_RE = re.compile(r"^[0-9a-f]{64}$")
SEMVER_RE = re.compile(r"^\d+\.\d+\.\d+$")
LAYOUT_PATH_RE = re.compile(
    r"^[A-Za-z0-9._][A-Za-z0-9._-]*(?:/[A-Za-z0-9._][A-Za-z0-9._-]*)*$"
)


class ContractError(ValueError):
    """Raised when a preflight cannot authorize the formula write."""


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


def load_json_file(path: Path, label: str) -> dict[str, Any]:
    try:
        metadata = path.lstat()
        if stat.S_ISLNK(metadata.st_mode) or not stat.S_ISREG(metadata.st_mode):
            raise ContractError(f"{label} must be a regular file, not a link")
        with path.open("r", encoding="utf-8") as handle:
            value = json.load(handle, object_pairs_hook=unique_object)
    except FileNotFoundError as error:
        raise ContractError(f"{label} does not exist") from error
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise ContractError(f"{label} is not valid readable UTF-8 JSON") from error
    if not isinstance(value, dict):
        raise ContractError(f"{label} must be a JSON object")
    return value


def sha256_of(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def expected_proof(manifest: dict[str, Any], args: argparse.Namespace) -> dict[str, Any]:
    """Rebuild, from the manifest alone, the exact receipt preflight must return."""

    document = exact_object(manifest, MANIFEST_KEYS, "manifest")
    exact_integer(document["schemaVersion"], SCHEMA_VERSION, "manifest schema version")
    exact_integer(document["layoutVersion"], LAYOUT_VERSION, "manifest layout version")
    channel = document["channel"]
    if channel not in CHANNEL_PACKAGE:
        raise ContractError("manifest channel is not a known release channel")
    if args.expected_package != CHANNEL_PACKAGE[channel]:
        raise ContractError("dispatch package does not match the manifest channel")
    if document["tag"] != args.expected_tag:
        raise ContractError("manifest tag disagrees with the dispatch")
    if document["sourceSha"] != args.expected_source_sha:
        raise ContractError("manifest source SHA disagrees with the resolved release commit")
    if document["platform"] != PLATFORM:
        raise ContractError("manifest platform is not the supported platform")
    version = exact_string(document["version"], VERSION_RE, "manifest version")
    minimum_node = exact_string(document["minimumNode"], SEMVER_RE, "manifest minimum Node")
    base_url = f"{RELEASE_ORIGIN}/{SOURCE_REPOSITORY}/releases/download/{args.expected_tag}"
    if document["baseUrl"] != base_url:
        raise ContractError("manifest base URL is not the canonical release origin")

    layout = exact_object(document["layout"], LAYOUT_KEYS, "manifest layout")
    if layout["install"] != INSTALL_MODE:
        raise ContractError("manifest layout install mode is not prefix-rooted")
    controller_layout = exact_object(
        layout["controller"], CONTROLLER_LAYOUT_KEYS, "manifest controller layout"
    )
    runtime_layout = exact_object(
        layout["runtime"], RUNTIME_LAYOUT_KEYS, "manifest runtime layout"
    )
    controller_entry = layout_path(controller_layout["entry"], "controller.entry", 3)
    controller_manifest = layout_path(controller_layout["manifest"], "controller.manifest", 1)
    runtime_marker = layout_path(runtime_layout["marker"], "runtime.marker", 1)
    runtime_manifest = layout_path(runtime_layout["manifest"], "runtime.manifest", 1)
    runtime_entries = sorted(
        {
            layout_path(runtime_layout["controllerEntry"], "runtime.controllerEntry"),
            layout_path(runtime_layout["supervisor"], "runtime.supervisor"),
            layout_path(runtime_layout["daemon"], "runtime.daemon"),
        }
    )

    assets_value = document["assets"]
    if not isinstance(assets_value, list) or len(assets_value) != len(EXPECTED_ASSETS):
        raise ContractError("manifest must describe exactly three assets")
    receipts: list[dict[str, Any]] = []
    for index, (value, (package, profile)) in enumerate(zip(assets_value, EXPECTED_ASSETS)):
        asset = exact_object(value, ASSET_KEYS, f"manifest asset {index}")
        if asset["package"] != package:
            raise ContractError(f"manifest asset {index} must be {package}")
        if asset["profile"] != profile:
            raise ContractError(f"manifest asset {package} must install profile {profile}")
        filename = f"{package}-{version}-{PLATFORM}.tar.gz"
        if asset["filename"] != filename:
            raise ContractError(f"manifest asset {package} filename must be {filename}")
        url = f"{base_url}/{filename}"
        if asset["url"] != url:
            raise ContractError(f"manifest asset {package} URL is not the immutable release URL")
        digest = exact_string(asset["sha256"], SHA256_RE, f"manifest asset {package} SHA-256")
        byte_count = positive_integer(asset["bytes"], f"manifest asset {package} byte count")
        if profile is None:
            installable = {
                "entry": controller_entry,
                "entryMode": "0755",
                "manifest": controller_manifest,
                "manifestName": "somawork-cli",
                "manifestVersion": version,
                "reservedTopLevelDirectories": [],
                "topLevelInstallable": True,
                "reRootsOnInstall": False,
            }
        else:
            installable = {
                "marker": runtime_marker,
                "markerPackage": package,
                "markerProfile": profile,
                "manifest": runtime_manifest,
                "manifestVersion": version,
                "entries": runtime_entries,
                "reservedTopLevelDirectories": [],
                "topLevelInstallable": True,
                "reRootsOnInstall": False,
            }
        receipts.append(
            {
                "package": package,
                "profile": profile,
                "filename": filename,
                "url": url,
                "bytes": byte_count,
                "sha256": digest,
                "installable": installable,
            }
        )

    return {
        "schema": PROOF_SCHEMA,
        "release": {
            "tag": args.expected_tag,
            "version": version,
            "sourceSha": args.expected_source_sha,
            "channel": channel,
            "platform": PLATFORM,
            "layoutVersion": LAYOUT_VERSION,
            "minimumNode": minimum_node,
        },
        "assets": receipts,
    }


def check_shape(proof: dict[str, Any]) -> None:
    """Reject a malformed proof with a field-level message, before comparing."""
    document = exact_object(proof, PROOF_KEYS, "preflight proof")
    if document["schema"] != PROOF_SCHEMA:
        raise ContractError("preflight proof schema is invalid")
    exact_object(document["release"], RELEASE_KEYS, "preflight release")
    assets = document["assets"]
    if not isinstance(assets, list) or len(assets) != len(EXPECTED_ASSETS):
        raise ContractError("preflight proof must measure exactly three assets")
    for index, value in enumerate(assets):
        receipt = exact_object(value, RECEIPT_KEYS, f"preflight receipt {index}")
        keys = CONTROLLER_RECEIPT_KEYS if receipt["profile"] is None else RUNTIME_RECEIPT_KEYS
        installable = exact_object(
            receipt["installable"], keys, f"preflight receipt {index} findings"
        )
        if installable["topLevelInstallable"] is not True:
            raise ContractError(
                f"preflight found a top-level entry the formula would not install: {receipt['package']}"
            )
        if installable["reservedTopLevelDirectories"] != []:
            raise ContractError(
                f"preflight found a Homebrew-linkable directory in {receipt['package']}"
            )
        # Homebrew re-roots a staged archive that holds one non-dot directory, so
        # a payload shaped that way installs a level above where the manifest
        # says it is. The preflight refuses it; this insists on the finding.
        if installable["reRootsOnInstall"] is not False:
            raise ContractError(
                f"preflight found an archive Homebrew would re-root: {receipt['package']}"
            )


def validate_dispatch(args: argparse.Namespace) -> None:
    exact_string(args.expected_tag, TAG_RE, "dispatch tag")
    exact_string(args.expected_source_sha, SOURCE_SHA_RE, "dispatch source SHA")
    exact_string(args.expected_manifest_sha256, SHA256_RE, "dispatch manifest SHA-256")
    if args.expected_source_repository != SOURCE_REPOSITORY:
        raise ContractError("dispatch source repository is not the somawork project")
    if args.expected_package not in set(CHANNEL_PACKAGE.values()):
        raise ContractError("dispatch package is not a somawork release channel")
    expected_url = (
        f"{RELEASE_ORIGIN}/{SOURCE_REPOSITORY}/releases/download/"
        f"{args.expected_tag}/{MANIFEST_FILENAME}"
    )
    if args.expected_manifest_url != expected_url:
        raise ContractError("dispatch manifest URL is not the exact immutable release URL")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--proof", type=Path, required=True)
    parser.add_argument("--expected-tag", required=True)
    parser.add_argument("--expected-package", required=True)
    parser.add_argument("--expected-source-repository", required=True)
    parser.add_argument("--expected-source-sha", required=True)
    parser.add_argument("--expected-manifest-url", required=True)
    parser.add_argument("--expected-manifest-sha256", required=True)
    args = parser.parse_args()
    try:
        validate_dispatch(args)
        manifest_path = args.manifest
        metadata = manifest_path.lstat()
        if stat.S_ISLNK(metadata.st_mode) or not stat.S_ISREG(metadata.st_mode):
            raise ContractError("manifest must be a regular file, not a link")
        if sha256_of(manifest_path) != args.expected_manifest_sha256:
            raise ContractError("manifest bytes disagree with the dispatched SHA-256")
        manifest = load_json_file(manifest_path, "manifest")
        proof = load_json_file(args.proof, "preflight proof")
        check_shape(proof)
        if proof != expected_proof(manifest, args):
            raise ContractError("the preflight proof disagrees with the manifest")
    except (ContractError, OSError) as error:
        print(f"somawork proof: {error}", file=sys.stderr)
        return 1
    print("somawork proof: ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
