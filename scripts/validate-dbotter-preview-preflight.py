#!/usr/bin/env python3
"""Revalidate an unprivileged dbotter preview preflight before a tap write."""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import re
import stat
import sys
from pathlib import Path
from typing import Any


MANIFEST_KEYS = {
    "tag",
    "source_sha",
    "version",
    "package_version",
    "config_contract",
    "run_id",
    "run_attempt",
    "created_at",
    "artifacts",
}
CONFIG_KEYS = {"read_versions", "write_version", "migration_backup_suffixes"}
MIGRATION_BACKUP_SUFFIX_KEYS = {"1", "2"}
PROOF_KEYS = {"schema", "artifacts", "candidate"}
MEASUREMENT_KEYS = {"target", "url", "bytes", "sha256"}
CANDIDATE_KEYS = {"target", "identity", "config_contract"}
IDENTITY_KEYS = {
    "package_version",
    "channel",
    "build_id",
    "source_sha",
    "target",
    "arch",
}
COMMON_ARTIFACT_KEYS = {"target", "arch", "kind", "url", "bytes", "sha256"}
MACOS_ARTIFACT_KEYS = COMMON_ARTIFACT_KEYS | {
    "embedded_executable_sha256",
    "bundle_id",
    "bundle_short_version",
    "bundle_build_version",
}
LINUX_ARTIFACT_KEYS = COMMON_ARTIFACT_KEYS | {"executable_mode"}
TARGETS = {
    "aarch64-apple-darwin": (
        "aarch64",
        "macos-app-tar-gz",
        "dbotter-preview-aarch64.tar.gz",
        MACOS_ARTIFACT_KEYS,
    ),
    "x86_64-apple-darwin": (
        "x86_64",
        "macos-app-tar-gz",
        "dbotter-preview-x86_64.tar.gz",
        MACOS_ARTIFACT_KEYS,
    ),
    "aarch64-unknown-linux-gnu": (
        "aarch64",
        "linux-native-executable",
        "dbotter-preview-linux-aarch64",
        LINUX_ARTIFACT_KEYS,
    ),
    "x86_64-unknown-linux-gnu": (
        "x86_64",
        "linux-native-executable",
        "dbotter-preview-linux-x86_64",
        LINUX_ARTIFACT_KEYS,
    ),
}
TAG_RE = re.compile(
    r"^preview-(\d{4})-(\d{2})-(\d{2})-(\d{6})-([1-9]\d*)-([1-9]\d*)-([0-9a-f]{12})$"
)
SOURCE_RE = re.compile(r"^[0-9a-f]{40}$")
SHA256_RE = re.compile(r"^[0-9a-f]{64}$")
PACKAGE_RE = re.compile(r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$")


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


def positive_integer(value: Any, label: str) -> int:
    if type(value) is not int or value < 1:
        raise ContractError(f"{label} is not a positive integer")
    return value


def exact_config_contract(value: Any, label: str) -> dict[str, Any]:
    config = exact_object(value, CONFIG_KEYS, label)
    read_versions = config["read_versions"]
    backup_suffixes = exact_object(
        config["migration_backup_suffixes"],
        MIGRATION_BACKUP_SUFFIX_KEYS,
        f"{label} migration_backup_suffixes",
    )
    if (
        not isinstance(read_versions, list)
        or len(read_versions) != 3
        or any(type(version) is not int for version in read_versions)
        or read_versions != [1, 2, 3]
    ):
        raise ContractError(f"{label} read_versions are not exact integers")
    if type(config["write_version"]) is not int or config["write_version"] != 3:
        raise ContractError(f"{label} write_version is not the exact integer")
    if (
        type(backup_suffixes["1"]) is not str
        or backup_suffixes["1"] != ".v1.bak"
        or type(backup_suffixes["2"]) is not str
        or backup_suffixes["2"] != ".v2.bak"
    ):
        raise ContractError(f"{label} migration backup suffixes are not exact")
    return config


def load_json(path: Path, label: str) -> dict[str, Any]:
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


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def validate_expected_inputs(args: argparse.Namespace) -> re.Match[str]:
    match = TAG_RE.fullmatch(args.expected_tag)
    if match is None:
        raise ContractError("expected tag is invalid")
    exact_string(args.expected_source_sha, SOURCE_RE, "expected source SHA")
    if match.group(7) != args.expected_source_sha[:12]:
        raise ContractError("expected tag and source SHA disagree")
    expected_version = ".".join(
        (*match.groups()[:3], match.group(4), match.group(5), match.group(6))
    )
    if args.expected_version != expected_version:
        raise ContractError("expected version does not derive from the tag")
    expected_manifest_url = (
        "https://github.com/2lab-ai/dbotter/releases/download/"
        f"{args.expected_tag}/preview-manifest.json"
    )
    if args.expected_manifest_url != expected_manifest_url:
        raise ContractError("expected manifest URL is not immutable")
    exact_string(args.expected_manifest_sha256, SHA256_RE, "expected manifest SHA-256")
    return match


def validate_manifest(
    document: dict[str, Any], args: argparse.Namespace, tag_match: re.Match[str]
) -> tuple[dict[str, Any], list[dict[str, Any]]]:
    manifest = exact_object(document, MANIFEST_KEYS, "manifest")
    if manifest["tag"] != args.expected_tag:
        raise ContractError("manifest tag disagrees with the dispatch")
    if manifest["source_sha"] != args.expected_source_sha:
        raise ContractError("manifest source SHA disagrees with the dispatch")
    if manifest["version"] != args.expected_version:
        raise ContractError("manifest version disagrees with the dispatch")
    package_version = exact_string(manifest["package_version"], PACKAGE_RE, "package version")
    config = exact_config_contract(manifest["config_contract"], "manifest config contract")
    run_id = positive_integer(manifest["run_id"], "manifest run id")
    run_attempt = positive_integer(manifest["run_attempt"], "manifest run attempt")
    if run_id != int(tag_match.group(5)) or run_attempt != int(tag_match.group(6)):
        raise ContractError("manifest run tuple disagrees with the tag")
    created_at = (
        f"{tag_match.group(1)}-{tag_match.group(2)}-{tag_match.group(3)}T"
        f"{tag_match.group(4)[0:2]}:{tag_match.group(4)[2:4]}:"
        f"{tag_match.group(4)[4:6]}Z"
    )
    try:
        dt.datetime.strptime(created_at, "%Y-%m-%dT%H:%M:%SZ")
    except ValueError as error:
        raise ContractError("tag does not contain a real UTC timestamp") from error
    if manifest["created_at"] != created_at:
        raise ContractError("manifest creation time disagrees with the tag")

    artifacts = manifest["artifacts"]
    if not isinstance(artifacts, list) or len(artifacts) != len(TARGETS):
        raise ContractError("manifest must contain exactly four artifacts")
    seen: set[str] = set()
    measurements: list[dict[str, Any]] = []
    for index, value in enumerate(artifacts):
        if not isinstance(value, dict):
            raise ContractError(f"manifest artifact {index} is not an object")
        target = value.get("target")
        if not isinstance(target, str) or target not in TARGETS or target in seen:
            raise ContractError("manifest artifact target is missing, duplicate, or unsupported")
        seen.add(target)
        arch, kind, filename, keys = TARGETS[target]
        artifact = exact_object(value, keys, f"manifest artifact {target}")
        expected_url = (
            "https://github.com/2lab-ai/dbotter/releases/download/"
            f"{args.expected_tag}/{filename}"
        )
        if artifact["arch"] != arch or artifact["kind"] != kind:
            raise ContractError(f"manifest artifact type disagrees for {target}")
        if artifact["url"] != expected_url:
            raise ContractError(f"manifest artifact URL disagrees for {target}")
        byte_count = positive_integer(artifact["bytes"], f"manifest artifact bytes for {target}")
        artifact_sha = exact_string(
            artifact["sha256"], SHA256_RE, f"manifest artifact SHA-256 for {target}"
        )
        if kind == "macos-app-tar-gz":
            exact_string(
                artifact["embedded_executable_sha256"],
                SHA256_RE,
                f"embedded executable SHA-256 for {target}",
            )
            if artifact["bundle_id"] != "ai.2lab.dbotter.preview":
                raise ContractError(f"bundle id disagrees for {target}")
            if artifact["bundle_short_version"] != package_version:
                raise ContractError(f"bundle short version disagrees for {target}")
            if artifact["bundle_build_version"] != f"{run_id}.{run_attempt}":
                raise ContractError(f"bundle build version disagrees for {target}")
        elif artifact["executable_mode"] != "0755":
            raise ContractError(f"Linux executable mode disagrees for {target}")
        measurements.append(
            {
                "target": target,
                "url": expected_url,
                "bytes": byte_count,
                "sha256": artifact_sha,
            }
        )
    if seen != set(TARGETS):
        raise ContractError("manifest artifact target set is incomplete")
    return config, sorted(measurements, key=lambda item: item["target"])


def validate_proof(
    document: dict[str, Any],
    args: argparse.Namespace,
    manifest: dict[str, Any],
    manifest_config: dict[str, Any],
    expected_measurements: list[dict[str, Any]],
) -> None:
    proof = exact_object(document, PROOF_KEYS, "preflight proof")
    if proof["schema"] != "dbotter.tap-preflight.v1":
        raise ContractError("preflight proof schema is invalid")
    measurements = proof["artifacts"]
    if not isinstance(measurements, list) or len(measurements) != len(TARGETS):
        raise ContractError("preflight proof must contain exactly four measurements")
    checked_measurements: list[dict[str, Any]] = []
    seen: set[str] = set()
    for index, value in enumerate(measurements):
        measurement = exact_object(value, MEASUREMENT_KEYS, f"preflight measurement {index}")
        target = measurement["target"]
        if not isinstance(target, str) or target not in TARGETS or target in seen:
            raise ContractError("preflight measurement target is invalid or duplicate")
        seen.add(target)
        if not isinstance(measurement["url"], str):
            raise ContractError(f"preflight measurement URL is not a string for {target}")
        positive_integer(measurement["bytes"], f"preflight measurement bytes for {target}")
        exact_string(
            measurement["sha256"], SHA256_RE, f"preflight measurement SHA-256 for {target}"
        )
        checked_measurements.append(measurement)
    if checked_measurements != expected_measurements:
        raise ContractError("preflight measurements disagree with the manifest")

    candidate = exact_object(proof["candidate"], CANDIDATE_KEYS, "preflight candidate")
    expected_target = "x86_64-unknown-linux-gnu"
    if candidate["target"] != expected_target:
        raise ContractError("preflight executed the wrong candidate target")
    identity = exact_object(candidate["identity"], IDENTITY_KEYS, "preflight candidate identity")
    expected_identity = {
        "package_version": manifest["package_version"],
        "channel": "preview",
        "build_id": args.expected_tag.removeprefix("preview-"),
        "source_sha": args.expected_source_sha,
        "target": expected_target,
        "arch": "x86_64",
    }
    if identity != expected_identity:
        raise ContractError("preflight candidate identity disagrees with the manifest")
    candidate_config = exact_config_contract(
        candidate["config_contract"], "preflight candidate config contract"
    )
    if candidate_config != manifest_config:
        raise ContractError("preflight candidate config contract disagrees with the manifest")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--proof", type=Path, required=True)
    parser.add_argument("--expected-tag", required=True)
    parser.add_argument("--expected-source-sha", required=True)
    parser.add_argument("--expected-version", required=True)
    parser.add_argument("--expected-manifest-url", required=True)
    parser.add_argument("--expected-manifest-sha256", required=True)
    args = parser.parse_args()
    try:
        tag_match = validate_expected_inputs(args)
        if sha256(args.manifest) != args.expected_manifest_sha256:
            raise ContractError("manifest bytes disagree with the dispatched SHA-256")
        manifest = load_json(args.manifest, "manifest")
        manifest_config, measurements = validate_manifest(manifest, args, tag_match)
        proof = load_json(args.proof, "preflight proof")
        validate_proof(proof, args, manifest, manifest_config, measurements)
    except (ContractError, OSError) as error:
        print(f"dbotter preview proof: {error}", file=sys.stderr)
        return 1
    print("dbotter preview proof: ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
