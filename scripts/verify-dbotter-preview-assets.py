#!/usr/bin/env python3
"""Remeasure every preview asset and execute the exact Linux tap candidate."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import stat
import subprocess
import sys
import tempfile
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
IDENTITY_KEYS = {
    "package_version",
    "channel",
    "build_id",
    "source_sha",
    "target",
    "arch",
}
CONFIG_KEYS = {"read_versions", "write_version", "migration_backup_suffixes"}
MIGRATION_BACKUP_SUFFIX_KEYS = {"1", "2"}
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
    r"^preview-\d{4}-\d{2}-\d{2}-\d{6}-[1-9]\d*-[1-9]\d*-[0-9a-f]{12}$"
)
SOURCE_RE = re.compile(r"^[0-9a-f]{40}$")
SHA_RE = re.compile(r"^[0-9a-f]{64}$")
PACKAGE_RE = re.compile(r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$")
SANITIZED_CANDIDATE_ENV = {
    "PATH": os.defpath,
    "LANG": "C",
    "LC_ALL": "C",
    "TZ": "UTC",
}
MAX_COMMAND_OUTPUT_BYTES = 1024 * 1024


class PreflightError(ValueError):
    """Raised when an immutable preview input fails independent preflight."""


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


def load_json(path: Path, label: str) -> dict[str, Any]:
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
        raise PreflightError(f"{label} read_versions are not exact integers")
    if type(config["write_version"]) is not int or config["write_version"] != 3:
        raise PreflightError(f"{label} write_version is not the exact integer")
    if (
        type(backup_suffixes["1"]) is not str
        or backup_suffixes["1"] != ".v1.bak"
        or type(backup_suffixes["2"]) is not str
        or backup_suffixes["2"] != ".v2.bak"
    ):
        raise PreflightError(f"{label} migration backup suffixes are not exact")
    return config


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def validate_manifest(document: dict[str, Any]) -> tuple[str, str, str, dict[str, Any], list[dict[str, Any]]]:
    manifest = exact_object(document, MANIFEST_KEYS, "manifest")
    tag = manifest["tag"]
    source_sha = manifest["source_sha"]
    package_version = manifest["package_version"]
    if not isinstance(tag, str) or TAG_RE.fullmatch(tag) is None:
        raise PreflightError("manifest tag is invalid")
    if not isinstance(source_sha, str) or SOURCE_RE.fullmatch(source_sha) is None:
        raise PreflightError("manifest source SHA is invalid")
    if not tag.endswith(source_sha[:12]):
        raise PreflightError("manifest tag and source SHA disagree")
    if not isinstance(package_version, str) or PACKAGE_RE.fullmatch(package_version) is None:
        raise PreflightError("manifest package version is invalid")
    config = exact_config_contract(manifest["config_contract"], "manifest config contract")
    artifacts = manifest["artifacts"]
    if not isinstance(artifacts, list) or len(artifacts) != len(TARGETS):
        raise PreflightError("manifest must contain exactly four artifacts")
    return tag, source_sha, package_version, config, artifacts


def measure_artifacts(
    artifacts: list[dict[str, Any]], assets_dir: Path, tag: str
) -> tuple[list[dict[str, Any]], Path]:
    seen: set[str] = set()
    measurements: list[dict[str, Any]] = []
    candidate: Path | None = None
    for index, value in enumerate(artifacts):
        if not isinstance(value, dict):
            raise PreflightError(f"artifact {index} is not an object")
        target = value.get("target")
        if not isinstance(target, str) or target not in TARGETS or target in seen:
            raise PreflightError("artifact target is missing, duplicate, or unsupported")
        seen.add(target)
        arch, kind, filename, keys = TARGETS[target]
        artifact = exact_object(value, keys, f"artifact {target}")
        expected_url = (
            f"https://github.com/2lab-ai/dbotter/releases/download/{tag}/{filename}"
        )
        if artifact["arch"] != arch or artifact["kind"] != kind:
            raise PreflightError(f"artifact type disagrees for {target}")
        if artifact["url"] != expected_url:
            raise PreflightError(f"artifact URL disagrees for {target}")
        if kind == "linux-native-executable" and artifact["executable_mode"] != "0755":
            raise PreflightError(f"Linux executable mode disagrees for {target}")
        expected_bytes = artifact["bytes"]
        expected_sha256 = artifact["sha256"]
        if isinstance(expected_bytes, bool) or not isinstance(expected_bytes, int) or expected_bytes < 1:
            raise PreflightError(f"artifact byte count is invalid for {target}")
        if not isinstance(expected_sha256, str) or SHA_RE.fullmatch(expected_sha256) is None:
            raise PreflightError(f"artifact SHA-256 is invalid for {target}")
        path = assets_dir / filename
        try:
            metadata = path.lstat()
        except OSError as error:
            raise PreflightError(f"artifact is missing for {target}") from error
        if stat.S_ISLNK(metadata.st_mode) or not stat.S_ISREG(metadata.st_mode):
            raise PreflightError(f"artifact must be a regular file for {target}")
        actual_sha256 = sha256(path)
        if metadata.st_size != expected_bytes or actual_sha256 != expected_sha256:
            raise PreflightError(f"artifact measurement disagrees for {target}")
        measurements.append(
            {
                "target": target,
                "url": expected_url,
                "bytes": metadata.st_size,
                "sha256": actual_sha256,
            }
        )
        if target == "x86_64-unknown-linux-gnu":
            if metadata.st_mode & 0o111 == 0:
                raise PreflightError("x86_64 Linux candidate is not executable")
            candidate = path
    if seen != set(TARGETS) or candidate is None:
        raise PreflightError("artifact target set is incomplete")
    return sorted(measurements, key=lambda item: item["target"]), candidate


def run_json(candidate: Path, arguments: list[str], label: str) -> dict[str, Any]:
    try:
        executable = candidate.resolve(strict=True)
    except OSError as error:
        raise PreflightError(f"candidate {label} executable is unavailable") from error
    try:
        completed = subprocess.run(
            [str(executable), *arguments],
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False,
            timeout=15,
            cwd=executable.parent,
            env=SANITIZED_CANDIDATE_ENV,
        )
    except (OSError, subprocess.TimeoutExpired) as error:
        raise PreflightError(f"candidate {label} command could not complete") from error
    if completed.returncode != 0 or completed.stderr:
        raise PreflightError(f"candidate {label} command failed")
    if len(completed.stdout) > MAX_COMMAND_OUTPUT_BYTES:
        raise PreflightError(f"candidate {label} output is too large")
    try:
        value = json.loads(completed.stdout, object_pairs_hook=unique_object)
    except (UnicodeDecodeError, json.JSONDecodeError) as error:
        raise PreflightError(f"candidate {label} output is not valid JSON") from error
    if not isinstance(value, dict):
        raise PreflightError(f"candidate {label} output is not an object")
    return value


def execute_candidate(
    candidate: Path,
    *,
    tag: str,
    source_sha: str,
    package_version: str,
    config: dict[str, Any],
) -> dict[str, Any]:
    identity = exact_object(
        run_json(candidate, ["version", "--format", "json"], "identity"),
        IDENTITY_KEYS,
        "candidate identity",
    )
    expected_identity = {
        "package_version": package_version,
        "channel": "preview",
        "build_id": tag.removeprefix("preview-"),
        "source_sha": source_sha,
        "target": "x86_64-unknown-linux-gnu",
        "arch": "x86_64",
    }
    if identity != expected_identity:
        raise PreflightError("candidate identity disagrees with manifest")
    candidate_config = exact_config_contract(
        run_json(candidate, ["config-contract", "--format", "json"], "config contract"),
        "candidate config contract",
    )
    if candidate_config != config:
        raise PreflightError("candidate config contract disagrees with manifest")
    return {
        "target": "x86_64-unknown-linux-gnu",
        "identity": identity,
        "config_contract": candidate_config,
    }


def write_no_replace(output: Path, document: dict[str, Any]) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    try:
        parent_metadata = output.parent.lstat()
    except OSError as error:
        raise PreflightError("output parent is unavailable") from error
    if stat.S_ISLNK(parent_metadata.st_mode) or not stat.S_ISDIR(parent_metadata.st_mode):
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
        try:
            os.link(temporary, output)
        except FileExistsError as error:
            raise PreflightError("output already exists") from error
        directory = os.open(output.parent, os.O_RDONLY)
        try:
            os.fsync(directory)
        finally:
            os.close(directory)
    finally:
        temporary.unlink(missing_ok=True)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--assets-dir", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    try:
        assets_metadata = args.assets_dir.lstat()
        if stat.S_ISLNK(assets_metadata.st_mode) or not stat.S_ISDIR(assets_metadata.st_mode):
            raise PreflightError("assets directory must be a real directory")
        manifest = load_json(args.manifest, "manifest")
        tag, source_sha, package_version, config, artifacts = validate_manifest(manifest)
        measurements, candidate = measure_artifacts(artifacts, args.assets_dir, tag)
        candidate_receipt = execute_candidate(
            candidate,
            tag=tag,
            source_sha=source_sha,
            package_version=package_version,
            config=config,
        )
        write_no_replace(
            args.output,
            {
                "schema": "dbotter.tap-preflight.v1",
                "artifacts": measurements,
                "candidate": candidate_receipt,
            },
        )
    except (OSError, PreflightError) as error:
        print(f"dbotter preview preflight: {error}", file=sys.stderr)
        return 1
    print(f"dbotter preview preflight: ok: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
