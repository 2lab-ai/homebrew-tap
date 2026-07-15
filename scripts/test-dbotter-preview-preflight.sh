#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
verifier="$root/scripts/verify-dbotter-preview-assets.py"

fail() {
  echo "dbotter preview preflight contract: $*" >&2
  exit 1
}

[[ -x "$verifier" ]] || fail "tracked executable verifier is missing"

temporary="$(mktemp -d "${TMPDIR:-/tmp}/dbotter-preview-preflight.XXXXXX")"
trap 'rm -rf "$temporary"' EXIT HUP INT TERM
assets="$temporary/assets"
mkdir -p "$assets"

printf 'macOS arm package\n' >"$assets/dbotter-preview-aarch64.tar.gz"
printf 'macOS intel package\n' >"$assets/dbotter-preview-x86_64.tar.gz"
printf 'Linux arm package\n' >"$assets/dbotter-preview-linux-aarch64"
apply_fake_candidate() {
  local config_write_version="${1:?write version required}"
  sed \
    -e "s/@WRITE_VERSION@/$config_write_version/" \
    "$root/tests/fixtures/dbotter-preview-linux-x86_64.fake" \
    >"$assets/dbotter-preview-linux-x86_64"
  chmod 0755 "$assets/dbotter-preview-linux-x86_64"
}
apply_fake_candidate 2

manifest="$temporary/preview-manifest.json"
artifact_json="$temporary/artifacts.json"
artifact() {
  local target="${1:?target required}"
  local arch="${2:?arch required}"
  local kind="${3:?kind required}"
  local name="${4:?name required}"
  local path="$assets/$name"
  local bytes sha
  bytes="$(wc -c <"$path" | tr -d ' ')"
  sha="$(shasum -a 256 "$path" | awk '{print $1}')"
  if [[ "$kind" == macos-app-tar-gz ]]; then
    jq -n \
      --arg target "$target" --arg arch "$arch" --arg kind "$kind" \
      --arg url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-15-123456-123456789-2-0123456789ab/$name" \
      --argjson bytes "$bytes" --arg sha256 "$sha" '
        {
          target: $target, arch: $arch, kind: $kind, url: $url,
          bytes: $bytes, sha256: $sha256,
          embedded_executable_sha256: "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
          bundle_id: "ai.2lab.dbotter.preview",
          bundle_short_version: "0.1.0",
          bundle_build_version: "123456789.2"
        }
      '
  else
    jq -n \
      --arg target "$target" --arg arch "$arch" --arg kind "$kind" \
      --arg url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-15-123456-123456789-2-0123456789ab/$name" \
      --argjson bytes "$bytes" --arg sha256 "$sha" '
        {
          target: $target, arch: $arch, kind: $kind, url: $url,
          bytes: $bytes, sha256: $sha256, executable_mode: "0755"
        }
      '
  fi
}

jq -s '.' \
  <(artifact aarch64-apple-darwin aarch64 macos-app-tar-gz dbotter-preview-aarch64.tar.gz) \
  <(artifact x86_64-apple-darwin x86_64 macos-app-tar-gz dbotter-preview-x86_64.tar.gz) \
  <(artifact aarch64-unknown-linux-gnu aarch64 linux-native-executable dbotter-preview-linux-aarch64) \
  <(artifact x86_64-unknown-linux-gnu x86_64 linux-native-executable dbotter-preview-linux-x86_64) \
  >"$artifact_json"

jq -n --slurpfile artifacts "$artifact_json" '
  {
    tag: "preview-2026-07-15-123456-123456789-2-0123456789ab",
    source_sha: "0123456789abcdef0123456789abcdef01234567",
    version: "2026.07.15.123456.123456789.2",
    package_version: "0.1.0",
    config_contract: {
      read_versions: [1, 2],
      write_version: 2,
      migration_backup_suffix: ".v1.bak"
    },
    run_id: 123456789,
    run_attempt: 2,
    created_at: "2026-07-15T12:34:56Z",
    artifacts: $artifacts[0]
  }
' >"$manifest"

receipt="$temporary/preflight.json"
"$verifier" --manifest "$manifest" --assets-dir "$assets" --output "$receipt"

jq -e '
  (keys | sort) == ["artifacts", "candidate", "schema"]
  and .schema == "dbotter.tap-preflight.v1"
  and (.artifacts | length) == 4
  and ([.artifacts[].target] | sort) == [
    "aarch64-apple-darwin",
    "aarch64-unknown-linux-gnu",
    "x86_64-apple-darwin",
    "x86_64-unknown-linux-gnu"
  ]
  and (.artifacts | all(
    (keys | sort) == ["bytes", "sha256", "target", "url"]
    and (.bytes > 0)
    and (.sha256 | test("^[0-9a-f]{64}$"))
  ))
  and (.candidate | keys | sort) == ["config_contract", "identity", "target"]
  and .candidate.target == "x86_64-unknown-linux-gnu"
  and (.candidate.identity | keys | sort) == ["arch", "build_id", "channel", "package_version", "source_sha", "target"]
  and .candidate.identity.channel == "preview"
  and .candidate.identity.source_sha == "0123456789abcdef0123456789abcdef01234567"
  and .candidate.config_contract == {
    read_versions: [1, 2],
    write_version: 2,
    migration_backup_suffix: ".v1.bak"
  }
' "$receipt" >/dev/null || fail "verified receipt is incomplete"

cp "$manifest" "$temporary/tampered-manifest.json"
printf 'tamper\n' >>"$assets/dbotter-preview-linux-aarch64"
if "$verifier" \
  --manifest "$temporary/tampered-manifest.json" \
  --assets-dir "$assets" \
  --output "$temporary/tampered-receipt.json" >/dev/null 2>&1; then
  fail "verifier accepted an artifact whose measured bytes and digest disagree"
fi
printf 'Linux arm package\n' >"$assets/dbotter-preview-linux-aarch64"

apply_fake_candidate 1
bad_candidate_manifest="$temporary/bad-candidate-manifest.json"
bad_candidate_sha="$(shasum -a 256 "$assets/dbotter-preview-linux-x86_64" | awk '{print $1}')"
bad_candidate_bytes="$(wc -c <"$assets/dbotter-preview-linux-x86_64" | tr -d ' ')"
jq \
  --arg sha256 "$bad_candidate_sha" \
  --argjson bytes "$bad_candidate_bytes" '
    (.artifacts[] | select(.target == "x86_64-unknown-linux-gnu")).sha256 = $sha256
    | (.artifacts[] | select(.target == "x86_64-unknown-linux-gnu")).bytes = $bytes
  ' "$manifest" >"$bad_candidate_manifest"
if "$verifier" \
  --manifest "$bad_candidate_manifest" \
  --assets-dir "$assets" \
  --output "$temporary/bad-contract-receipt.json" \
  >"$temporary/bad-contract.stdout" 2>"$temporary/bad-contract.stderr"; then
  fail "verifier accepted a candidate with a mismatched config contract"
fi
grep -Fq 'candidate config contract disagrees with manifest' \
  "$temporary/bad-contract.stderr" \
  || fail "mismatched config contract was not rejected at candidate execution"
apply_fake_candidate 2

printf 'preserve-existing-receipt\n' >"$temporary/existing-receipt.json"
if "$verifier" \
  --manifest "$manifest" \
  --assets-dir "$assets" \
  --output "$temporary/existing-receipt.json" >/dev/null 2>&1; then
  fail "verifier replaced an existing receipt"
fi
grep -Fxq 'preserve-existing-receipt' "$temporary/existing-receipt.json" \
  || fail "existing receipt changed after no-replace rejection"

echo "dbotter preview preflight contract: ok"
