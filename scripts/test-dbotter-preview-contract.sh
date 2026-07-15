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
raise "preview job depends on an unrelated scheduled job" if job.key?("needs")
document.fetch("jobs").each do |name, candidate|
  next if name == "bump-dbotter-preview"
  raise "unrelated job is not schedule-only: #{name}" unless candidate["if"] == "github.event_name == 'schedule'"
end
runs = job.fetch("steps").map { |step| step["run"] }.compact.join("\n")
raise "renderer is not invoked" unless runs.include?("scripts/render-dbotter-preview-formula.py")
raise "tap does not independently enforce monotonic version" unless runs.include?("--greater-than")
raise "latest release discovery remains" if runs.include?("gh release list")
raise "legacy raw asset remains" if runs.include?("dbotter-macos-aarch64")
raise "tap evidence does not bind formula commit" unless runs.include?("dbotter.tap-dispatch.v1") && runs.include?("formula_commit")
uploads = job.fetch("steps").select { |step| step["uses"] == "actions/upload-artifact@v4" }
raise "tap evidence artifact is not uploaded exactly once" unless uploads.length == 1
RUBY
grep -Fq 'Dbotter Preview.app' "$template" \
  || fail "formula template does not install the app bundle"
grep -Fq 'Contents/MacOS/dbotter' "$template" \
  || fail "formula template does not expose the embedded CLI"
if grep -Fq 'Dir["dbotter-*"].first' "$template"; then
  fail "formula template still accepts an arbitrary raw binary"
fi

manifest_sha256="$(shasum -a 256 "$fixture" | awk '{print $1}')"
output="$(mktemp "${TMPDIR:-/tmp}/dbotter-preview-formula.XXXXXX.rb")"
invalid_manifest="${output%.rb}.invalid.json"
trap 'rm -f "$output" "$output.invalid" "$invalid_manifest"' EXIT HUP INT TERM

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
