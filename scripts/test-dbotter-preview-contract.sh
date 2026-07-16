#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
fixture="$root/tests/fixtures/dbotter-preview-manifest.json"
renderer="$root/scripts/render-dbotter-preview-formula.py"
preflight="$root/scripts/verify-dbotter-preview-assets.py"
workflow="$root/.github/workflows/bump.yml"
template="$root/Formula/dbotter-preview.rb.tmpl"

fail() {
  echo "dbotter preview tap contract: $*" >&2
  exit 1
}

[[ -x "$renderer" ]] || fail "tracked executable renderer is missing"
[[ -x "$preflight" ]] || fail "tracked executable asset preflight is missing"
for input in tag source_sha version manifest_url manifest_sha256; do
  grep -Eq "^[[:space:]]{6}${input}:$" "$workflow" \
    || fail "workflow_dispatch input is missing: $input"
done
ruby -ryaml - "$workflow" <<'RUBY'
document = YAML.safe_load(File.read(ARGV.fetch(0)), aliases: true)
raise "dispatch run name is not correlation-safe" unless document.fetch("run-name").include?("inputs.tag") && document.fetch("run-name").include?("inputs.source_sha")
triggers = document.fetch("on", document[true])
inputs = triggers.fetch("workflow_dispatch").fetch("inputs")
expected = %w[tag source_sha version manifest_url manifest_sha256]
raise "dispatch inputs are not exact" unless inputs.keys == expected
raise "dispatch inputs are not required strings" unless inputs.values.all? { |value| value["required"] == true && value["type"] == "string" }
job = document.fetch("jobs").fetch("bump-dbotter-preview")
raise "preview job is not dispatch-only" unless job["if"] == "github.event_name == 'workflow_dispatch'"
document.fetch("jobs").each do |name, candidate|
  next if ["preflight-dbotter-preview", "bump-dbotter-preview"].include?(name)
  raise "unrelated job is not schedule-only: #{name}" unless candidate["if"] == "github.event_name == 'schedule'"
end
runs = job.fetch("steps").map { |step| step["run"] }.compact.join("\n")
raise "renderer is not invoked" unless runs.include?("scripts/render-dbotter-preview-formula.py")
raise "tap does not independently enforce monotonic version" unless runs.include?("--greater-than")
raise "latest release discovery remains" if runs.include?("gh release list")
raise "legacy raw asset remains" if runs.include?("dbotter-macos-aarch64")
raise "tap evidence does not bind formula commit" unless runs.include?("dbotter.tap-dispatch.v1") && runs.include?("formula_commit")
raise "tap evidence omits measured preflight" unless runs.include?("--slurpfile preflight") && runs.include?("preflight: $preflight[0]")
uploads = job.fetch("steps").select { |step| step["uses"] == "actions/upload-artifact@v4" }
raise "tap evidence artifact is not uploaded exactly once" unless uploads.length == 1
RUBY
grep -Fq 'Dbotter Preview.app' "$template" \
  || fail "formula template does not install the app bundle"
grep -Fq 'Contents/MacOS/dbotter' "$template" \
  || fail "formula template does not expose the embedded CLI"
grep -Fq 'elsif (buildpath/"Contents").directory?' "$template" \
  || fail "formula template does not handle Homebrew stripping the app wrapper"
grep -Fq 'app.install "Contents"' "$template" \
  || fail "formula template does not reconstruct a stripped app wrapper"
if grep -Fq 'Dir["dbotter-*"].first' "$template"; then
  fail "formula template still accepts an arbitrary raw binary"
fi

manifest_sha256="$(shasum -a 256 "$fixture" | awk '{print $1}')"
output="$(mktemp "${TMPDIR:-/tmp}/dbotter-preview-formula.XXXXXX.rb")"
invalid_manifest="${output%.rb}.invalid.json"
cleanup() {
  rm -f "$output" "$output.invalid" "$invalid_manifest" "${output%.rb}".manifest-*.json
}
trap cleanup EXIT HUP INT TERM

"$renderer" \
  --tag preview-2026-07-15-123456-123456789-2-0123456789ab \
  --source-sha 0123456789abcdef0123456789abcdef01234567 \
  --version 2026.07.15.123456.123456789.2 \
  --greater-than 2026.07.14.1149 \
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

python3 - "$fixture" "${output%.rb}" <<'PY'
import copy
import json
import pathlib
import sys

source = pathlib.Path(sys.argv[1])
prefix = pathlib.Path(sys.argv[2])
document = json.loads(source.read_text(encoding="utf-8"))
cases = {
    "manifest-read-bool": ("read_versions", [True, 2, 3]),
    "manifest-read-float": ("read_versions", [1.0, 2.0, 3.0]),
    "manifest-write-float": ("write_version", 3.0),
}
for name, (field, value) in cases.items():
    candidate = copy.deepcopy(document)
    candidate["config_contract"][field] = value
    pathlib.Path(f"{prefix}.{name}.json").write_text(
        json.dumps(candidate, indent=2) + "\n", encoding="utf-8"
    )
PY

for type_case in manifest-read-bool manifest-read-float manifest-write-float; do
  typed_manifest="${output%.rb}.$type_case.json"
  typed_sha256="$(shasum -a 256 "$typed_manifest" | awk '{print $1}')"
  if "$renderer" \
    --tag preview-2026-07-15-123456-123456789-2-0123456789ab \
    --source-sha 0123456789abcdef0123456789abcdef01234567 \
    --version 2026.07.15.123456.123456789.2 \
    --greater-than 2026.07.14.1149 \
    --manifest-url https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-15-123456-123456789-2-0123456789ab/preview-manifest.json \
    --manifest-sha256 "$typed_sha256" \
    --manifest "$typed_manifest" \
    --template "$template" \
    --output "$output.invalid" >/dev/null 2>&1; then
    fail "renderer accepted a type-confused manifest config: $type_case"
  fi
done

if "$renderer" \
  --tag preview-2026-07-15-123456-123456789-2-0123456789ab \
  --source-sha 0123456789abcdef0123456789abcdef01234567 \
  --version 2026.07.15.123456.123456789.2 \
  --greater-than 2026.07.15.123456.123456789.2 \
  --manifest-url https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-15-123456-123456789-2-0123456789ab/preview-manifest.json \
  --manifest-sha256 "$manifest_sha256" \
  --manifest "$fixture" \
  --template "$template" \
  --output "$output.invalid" >/dev/null 2>&1; then
  fail "renderer accepted a non-increasing preview version"
fi

if "$renderer" \
  --tag preview-2026-07-15-123456-123456789-2-ffffffffffff \
  --source-sha 0123456789abcdef0123456789abcdef01234567 \
  --version 2026.07.15.123456.123456789.2 \
  --greater-than 2026.07.14.1149 \
  --manifest-url https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-15-123456-123456789-2-ffffffffffff/preview-manifest.json \
  --manifest-sha256 "$manifest_sha256" \
  --manifest "$fixture" \
  --template "$template" \
  --output "$output.invalid" >/dev/null 2>&1; then
  fail "renderer accepted tag/source/manifest identity mismatch"
fi

jq '.artifacts[0].kind = "raw-binary"' "$fixture" >"$invalid_manifest"
invalid_sha256="$(shasum -a 256 "$invalid_manifest" | awk '{print $1}')"
if "$renderer" \
  --tag preview-2026-07-15-123456-123456789-2-0123456789ab \
  --source-sha 0123456789abcdef0123456789abcdef01234567 \
  --version 2026.07.15.123456.123456789.2 \
  --greater-than 2026.07.14.1149 \
  --manifest-url https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-15-123456-123456789-2-0123456789ab/preview-manifest.json \
  --manifest-sha256 "$invalid_sha256" \
  --manifest "$invalid_manifest" \
  --template "$template" \
  --output "$output.invalid" >/dev/null 2>&1; then
  fail "renderer accepted a raw-binary macOS artifact"
fi

if "$renderer" \
  --tag preview-2026-07-15-123456-123456789-2-0123456789ab \
  --source-sha 0123456789abcdef0123456789abcdef01234567 \
  --version 2026.07.15.123456.123456789.2 \
  --greater-than 2026.07.14.1149 \
  --manifest-url https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-15-123456-123456789-2-0123456789ab/preview-manifest.json \
  --manifest-sha256 ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff \
  --manifest "$fixture" \
  --template "$template" \
  --output "$output.invalid" >/dev/null 2>&1; then
  fail "renderer accepted a mismatched manifest digest"
fi

awk 'NR == 2 { print "  \"tag\": \"preview-2026-07-15-123456-123456789-2-0123456789ab\"," } { print }' \
  "$fixture" >"$invalid_manifest"
invalid_sha256="$(shasum -a 256 "$invalid_manifest" | awk '{print $1}')"
if "$renderer" \
  --tag preview-2026-07-15-123456-123456789-2-0123456789ab \
  --source-sha 0123456789abcdef0123456789abcdef01234567 \
  --version 2026.07.15.123456.123456789.2 \
  --greater-than 2026.07.14.1149 \
  --manifest-url https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-15-123456-123456789-2-0123456789ab/preview-manifest.json \
  --manifest-sha256 "$invalid_sha256" \
  --manifest "$invalid_manifest" \
  --template "$template" \
  --output "$output.invalid" >/dev/null 2>&1; then
  fail "renderer accepted duplicate JSON object keys"
fi

echo "dbotter preview tap contract: ok"
