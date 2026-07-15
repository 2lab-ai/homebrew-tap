#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
workflow="$root/.github/workflows/bump.yml"
verifier="$root/scripts/verify-dbotter-preview-assets.py"
trusted_validator="$root/scripts/validate-dbotter-preview-preflight.py"

fail() {
  echo "dbotter preview workflow contract: $*" >&2
  exit 1
}

ruby -ryaml - "$workflow" <<'RUBY'
document = YAML.safe_load(File.read(ARGV.fetch(0)), aliases: true)
jobs = document.fetch("jobs")
preflight = jobs.fetch("preflight-dbotter-preview")
bump = jobs.fetch("bump-dbotter-preview")

raise "preflight is not dispatch-only" unless preflight["if"] == "github.event_name == 'workflow_dispatch'"
raise "preflight is not contents:read" unless preflight["permissions"] == {"contents" => "read"}
checkout = preflight.fetch("steps").find { |step| step["uses"] == "actions/checkout@v4" }
raise "preflight checkout is missing" unless checkout
raise "preflight checkout persists credentials" unless checkout.fetch("with")["persist-credentials"] == false

candidate_steps = preflight.fetch("steps").select do |step|
  step.fetch("run", "").include?("scripts/verify-dbotter-preview-assets.py")
end
raise "candidate is not executed exactly once in preflight" unless candidate_steps.length == 1
candidate_step = candidate_steps.fetch(0)
candidate_env = candidate_step.fetch("env", {})
raise "candidate step receives GH_TOKEN" if candidate_env.key?("GH_TOKEN")
raise "candidate step receives a token-like variable" if candidate_env.keys.any? { |key| key.include?("TOKEN") }

preflight_runs = preflight.fetch("steps").map { |step| step.fetch("run", "") }.join("\n")
%w[
  dbotter-preview-aarch64.tar.gz
  dbotter-preview-x86_64.tar.gz
  dbotter-preview-linux-aarch64
  dbotter-preview-linux-x86_64
].each do |asset|
  raise "preflight does not download #{asset}" unless preflight_runs.include?(asset)
end
preflight_uploads = preflight.fetch("steps").select { |step| step["uses"] == "actions/upload-artifact@v4" }
raise "preflight proof is not uploaded exactly once" unless preflight_uploads.length == 1

needs = Array(bump["needs"])
raise "write bump does not hard-need preflight" unless needs == ["preflight-dbotter-preview"]
raise "write bump lacks explicit contents:write" unless bump["permissions"] == {"contents" => "write"}
bump_runs = bump.fetch("steps").map { |step| step.fetch("run", "") }.join("\n")
raise "write bump executes the candidate" if bump_runs.include?("scripts/verify-dbotter-preview-assets.py")
raise "write bump downloads executable assets" if bump_runs.include?("dbotter-preview-linux-x86_64")
raise "write bump omits trusted proof validation" unless bump_runs.include?("scripts/validate-dbotter-preview-preflight.py")
raise "write bump omits formula rendering" unless bump_runs.include?("scripts/render-dbotter-preview-formula.py")
raise "proof validation does not precede rendering" unless bump_runs.index("scripts/validate-dbotter-preview-preflight.py") < bump_runs.index("scripts/render-dbotter-preview-formula.py")
downloads = bump.fetch("steps").select { |step| step["uses"] == "actions/download-artifact@v4" }
raise "write bump does not download the preflight proof exactly once" unless downloads.length == 1
RUBY

grep -Fq 'env=SANITIZED_CANDIDATE_ENV' "$verifier" \
  || fail "candidate subprocess does not use the sanitized environment"
[[ -x "$trusted_validator" ]] \
  || fail "trusted preflight proof validator is missing"

echo "dbotter preview workflow contract: ok"
