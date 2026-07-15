#!/usr/bin/env python3
"""Render the dbotter preview formula from one exact, verified release manifest."""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import os
import re
import stat
import tempfile
from pathlib import Path
from typing import Any


TAG_RE = re.compile(
    r"^preview-(\d{4})-(\d{2})-(\d{2})-(\d{6})-([1-9]\d*)-([1-9]\d*)-([0-9a-f]{12})$"
)
SHA_RE = re.compile(r"^[0-9a-f]{64}$")
SOURCE_RE = re.compile(r"^[0-9a-f]{40}$")
PACKAGE_RE = re.compile(r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$")
PREVIEW_VERSION_RE = re.compile(
    r"^(\d{4})\.(\d{2})\.(\d{2})\.(\d{6})\.([1-9]\d*)\.([1-9]\d*)$"
)
LEGACY_PREVIEW_VERSION_RE = re.compile(r"^(\d{4})\.(\d{2})\.(\d{2})\.(\d{4})$")
TOP_LEVEL_KEYS = {
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
COMMON_ARTIFACT_KEYS = {
    "target",
    "arch",
    "kind",
    "url",
    "bytes",
    "sha256",
}
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
        "dbotter-preview-aarch64.tar.gz",
        "macos-app-tar-gz",
        MACOS_ARTIFACT_KEYS,
    ),
    "x86_64-apple-darwin": (
        "x86_64",
        "dbotter-preview-x86_64.tar.gz",
        "macos-app-tar-gz",
        MACOS_ARTIFACT_KEYS,
    ),
    "aarch64-unknown-linux-gnu": (
        "aarch64",
        "dbotter-preview-linux-aarch64",
        "linux-native-executable",
        LINUX_ARTIFACT_KEYS,
    ),
    "x86_64-unknown-linux-gnu": (
        "x86_64",
        "dbotter-preview-linux-x86_64",
        "linux-native-executable",
        LINUX_ARTIFACT_KEYS,
    ),
}


class ContractError(ValueError):
    """Raised when release input cannot safely render a formula."""


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


def string(value: Any, pattern: re.Pattern[str], label: str) -> str:
    if not isinstance(value, str) or pattern.fullmatch(value) is None:
        raise ContractError(f"{label} is invalid")
    return value


def positive_integer(value: Any, label: str) -> int:
    if isinstance(value, bool) or not isinstance(value, int) or value < 1:
        raise ContractError(f"{label} is not a positive integer")
    return value


def normalized_preview_version(value: str, *, allow_legacy: bool) -> tuple[int, ...]:
    match = PREVIEW_VERSION_RE.fullmatch(value)
    if match is not None:
        year, month, day, clock, run_id, run_attempt = match.groups()
        hour, minute, second = clock[:2], clock[2:4], clock[4:]
        suffix = (int(run_id), int(run_attempt))
    else:
        legacy = LEGACY_PREVIEW_VERSION_RE.fullmatch(value) if allow_legacy else None
        if legacy is None:
            raise ContractError("preview version is invalid")
        year, month, day, clock = legacy.groups()
        hour, minute, second = clock[:2], clock[2:], "00"
        suffix = (0, 0)
    try:
        timestamp = dt.datetime(
            int(year), int(month), int(day), int(hour), int(minute), int(second)
        )
    except ValueError as error:
        raise ContractError("preview version has an invalid UTC timestamp") from error
    return (
        timestamp.year,
        timestamp.month,
        timestamp.day,
        timestamp.hour,
        timestamp.minute,
        timestamp.second,
        *suffix,
    )


def validate(
    document: Any,
    *,
    tag: str,
    source_sha: str,
    version: str,
    greater_than: str,
    manifest_url: str,
    manifest_sha256: str,
) -> dict[str, dict[str, Any]]:
    match = TAG_RE.fullmatch(tag)
    if match is None:
        raise ContractError("tag is invalid")
    string(source_sha, SOURCE_RE, "source SHA")
    string(manifest_sha256, SHA_RE, "manifest SHA-256")
    year, month, day, clock, run_id_text, run_attempt_text, sha12 = match.groups()
    expected_version = f"{year}.{month}.{day}.{clock}.{run_id_text}.{run_attempt_text}"
    if version != expected_version:
        raise ContractError("version does not derive exactly from tag")
    if normalized_preview_version(version, allow_legacy=False) <= normalized_preview_version(
        greater_than, allow_legacy=True
    ):
        raise ContractError("preview version is not strictly greater than the installed baseline")
    if not source_sha.startswith(sha12):
        raise ContractError("tag sha12 does not match source SHA")
    expected_manifest_url = (
        f"https://github.com/2lab-ai/dbotter/releases/download/{tag}/preview-manifest.json"
    )
    if manifest_url != expected_manifest_url:
        raise ContractError("manifest URL is not the exact immutable release URL")

    manifest = exact_object(document, TOP_LEVEL_KEYS, "manifest")
    if manifest["tag"] != tag or manifest["source_sha"] != source_sha:
        raise ContractError("manifest release identity does not match dispatch")
    if manifest["version"] != version:
        raise ContractError("manifest version does not match dispatch")
    package_version = string(manifest["package_version"], PACKAGE_RE, "package version")
    run_id = positive_integer(manifest["run_id"], "run id")
    run_attempt = positive_integer(manifest["run_attempt"], "run attempt")
    if run_id != int(run_id_text) or run_attempt != int(run_attempt_text):
        raise ContractError("manifest run identity does not match tag")
    expected_created_at = (
        f"{year}-{month}-{day}T{clock[0:2]}:{clock[2:4]}:{clock[4:6]}Z"
    )
    try:
        dt.datetime.strptime(expected_created_at, "%Y-%m-%dT%H:%M:%SZ")
    except ValueError as error:
        raise ContractError("tag does not contain a real UTC timestamp") from error
    if manifest["created_at"] != expected_created_at:
        raise ContractError("manifest creation time does not match tag")
    if manifest["config_contract"] != {
        "read_versions": [1, 2],
        "write_version": 2,
        "migration_backup_suffix": ".v1.bak",
    }:
        raise ContractError("manifest config contract is not approved")

    artifacts_value = manifest["artifacts"]
    if not isinstance(artifacts_value, list) or len(artifacts_value) != len(TARGETS):
        raise ContractError("manifest must contain exactly two macOS artifacts")
    artifacts: dict[str, dict[str, Any]] = {}
    for index, value in enumerate(artifacts_value):
        if not isinstance(value, dict):
            raise ContractError(f"artifact {index} is not an object")
        target = value.get("target")
        if target not in TARGETS or target in artifacts:
            raise ContractError("artifact target is missing, duplicate, or unsupported")
        arch, archive, kind, keys = TARGETS[target]
        artifact = exact_object(value, keys, f"artifact {index}")
        expected_url = (
            f"https://github.com/2lab-ai/dbotter/releases/download/{tag}/{archive}"
        )
        if artifact["arch"] != arch or artifact["kind"] != kind:
            raise ContractError("artifact architecture or kind is invalid")
        if artifact["url"] != expected_url:
            raise ContractError("artifact URL is not the exact immutable release URL")
        positive_integer(artifact["bytes"], "artifact byte count")
        string(artifact["sha256"], SHA_RE, "artifact SHA-256")
        if kind == "macos-app-tar-gz":
            string(
                artifact["embedded_executable_sha256"],
                SHA_RE,
                "embedded executable SHA-256",
            )
            if artifact["bundle_id"] != "ai.2lab.dbotter.preview":
                raise ContractError("bundle id is invalid")
            if artifact["bundle_short_version"] != package_version:
                raise ContractError("bundle short version is invalid")
            if artifact["bundle_build_version"] != f"{run_id}.{run_attempt}":
                raise ContractError("bundle build version is invalid")
        elif artifact["executable_mode"] != "0755":
            raise ContractError("linux executable mode is invalid")
        artifacts[target] = artifact
    return artifacts


def render(template: str, replacements: dict[str, str]) -> str:
    rendered = template
    for placeholder, value in replacements.items():
        count = rendered.count(placeholder)
        if count != 1:
            raise ContractError(f"template placeholder count is not one: {placeholder}")
        rendered = rendered.replace(placeholder, value)
    if re.search(r"@[A-Z0-9_]+@", rendered):
        raise ContractError("template contains an unknown placeholder")
    return rendered


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


def write_atomic(output: Path, content: str) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    if output.is_symlink() or (output.exists() and not output.is_file()):
        raise ContractError("output must be a regular file, not a symlink")
    descriptor, temporary_name = tempfile.mkstemp(
        dir=output.parent, prefix=f".{output.name}.", suffix=".tmp"
    )
    temporary = Path(temporary_name)
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8", newline="\n") as handle:
            handle.write(content)
            handle.flush()
            os.fsync(handle.fileno())
        os.chmod(temporary, 0o644)
        os.replace(temporary, output)
        directory = os.open(output.parent, os.O_RDONLY)
        try:
            os.fsync(directory)
        finally:
            os.close(directory)
    finally:
        temporary.unlink(missing_ok=True)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--tag", required=True)
    parser.add_argument("--source-sha", required=True)
    parser.add_argument("--version", required=True)
    parser.add_argument("--greater-than", required=True)
    parser.add_argument("--manifest-url", required=True)
    parser.add_argument("--manifest-sha256", required=True)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--template", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        manifest_bytes = regular_file(args.manifest, "manifest")
        if hashlib.sha256(manifest_bytes).hexdigest() != args.manifest_sha256:
            raise ContractError("manifest SHA-256 does not match dispatch")
        try:
            document = json.loads(manifest_bytes, object_pairs_hook=unique_object)
        except (UnicodeDecodeError, json.JSONDecodeError) as error:
            raise ContractError("manifest is not valid UTF-8 JSON") from error
        artifacts = validate(
            document,
            tag=args.tag,
            source_sha=args.source_sha,
            version=args.version,
            greater_than=args.greater_than,
            manifest_url=args.manifest_url,
            manifest_sha256=args.manifest_sha256,
        )
        template = regular_file(args.template, "template").decode("utf-8")
        arm = artifacts["aarch64-apple-darwin"]
        intel = artifacts["x86_64-apple-darwin"]
        formula = render(
            template,
            {
                "@VERSION@": args.version,
                "@TAG@": args.tag,
                "@SOURCE_SHA@": args.source_sha,
                "@MANIFEST_URL@": args.manifest_url,
                "@MANIFEST_SHA256@": args.manifest_sha256,
                "@URL_MACOS_AARCH64@": arm["url"],
                "@SHA_MACOS_AARCH64@": arm["sha256"],
                "@URL_MACOS_X86_64@": intel["url"],
                "@SHA_MACOS_X86_64@": intel["sha256"],
            },
        )
        write_atomic(args.output, formula)
    except (ContractError, OSError, UnicodeDecodeError) as error:
        print(f"dbotter preview formula: {error}", file=os.sys.stderr)
        return 1
    print(f"dbotter preview formula: ok: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
