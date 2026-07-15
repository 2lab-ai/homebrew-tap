#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
fixture="$root/tests/fixtures/dbotter-preview-manifest.json"
renderer="$root/scripts/render-dbotter-preview-formula.py"
workflow="$root/.github/workflows/bump.yml"
template="$root/Formula/dbotter-preview.rb.tmpl"

fail() {
  echo "dbotter preview tap contract: $*" >&2
  exit 1
}

[[ -x "$renderer" ]] || fail "tracked executable renderer is missing"
for input in tag source_sha version manifest_url manifest_sha256; do
  grep -Eq "^[[:space:]]{6}${input}:$" "$workflow" \
    || fail "workflow_dispatch input is missing: $input"
done
grep -Fq 'Dbotter Preview.app' "$template" \
  || fail "formula template does not install the app bundle"
grep -Fq 'Contents/MacOS/dbotter' "$template" \
  || fail "formula template does not expose the embedded CLI"
if grep -Fq 'Dir["dbotter-*"].first' "$template"; then
  fail "formula template still accepts an arbitrary raw binary"
fi

manifest_sha256="$(shasum -a 256 "$fixture" | awk '{print $1}')"
output="$(mktemp "${TMPDIR:-/tmp}/dbotter-preview-formula.XXXXXX.rb")"
trap 'rm -f "$output" "$output.invalid"' EXIT HUP INT TERM

"$renderer" \
  --tag preview-2026-07-15-123456-123456789-2-0123456789ab \
  --source-sha 0123456789abcdef0123456789abcdef01234567 \
  --version 2026.07.15.123456.123456789.2 \
  --manifest-url https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-15-123456-123456789-2-0123456789ab/preview-manifest.json \
  --manifest-sha256 "$manifest_sha256" \
  --manifest "$fixture" \
  --template "$template" \
  --output "$output"

ruby -c "$output" >/dev/null
grep -Fq 'version "2026.07.15.123456.123456789.2"' "$output" \
  || fail "rendered version mismatch"
grep -Fq 'dbotter-preview-aarch64.tar.gz' "$output" \
  || fail "arm app archive missing"
grep -Fq 'sha256 "cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc"' "$output" \
  || fail "intel app archive hash missing"

if "$renderer" \
  --tag preview-2026-07-15-123456-123456789-2-ffffffffffff \
  --source-sha 0123456789abcdef0123456789abcdef01234567 \
  --version 2026.07.15.123456.123456789.2 \
  --manifest-url https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-15-123456-123456789-2-ffffffffffff/preview-manifest.json \
  --manifest-sha256 "$manifest_sha256" \
  --manifest "$fixture" \
  --template "$template" \
  --output "$output.invalid" >/dev/null 2>&1; then
  fail "renderer accepted tag/source/manifest identity mismatch"
fi

echo "dbotter preview tap contract: ok"
