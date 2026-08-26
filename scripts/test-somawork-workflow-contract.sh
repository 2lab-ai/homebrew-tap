#!/usr/bin/env bash
#
# somawork bump workflow contract.
#
# The somawork bump lives in its own workflow file. `bump.yml` carries dbotter's
# required `workflow_dispatch` schema and a set of schedule-only jobs, and its
# own contract test asserts that every job there is one of those two shapes; a
# `repository_dispatch` job added to it would break that invariant. So the
# isolation is checked from both sides: this file also asserts that `bump.yml`
# knows nothing about somawork.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
workflow="$root/.github/workflows/bump-somawork.yml"
legacy="$root/.github/workflows/bump.yml"
verifier="$root/scripts/verify-somawork-assets.py"
validator="$root/scripts/validate-somawork-preflight.py"
renderer="$root/scripts/render-somawork-formulae.py"

fail() {
  echo "somawork workflow contract: $*" >&2
  exit 1
}

[[ -f "$workflow" ]] || fail "the dedicated somawork bump workflow is missing"
[[ -x "$verifier" ]] || fail "tracked executable payload verifier is missing"
[[ -x "$validator" ]] || fail "tracked executable proof validator is missing"
[[ -x "$renderer" ]] || fail "tracked executable renderer is missing"

grep -Fqi somawork "$legacy" && fail "bump.yml was modified to know about somawork"

ruby -ryaml - "$workflow" <<'RUBY'
document = YAML.safe_load(File.read(ARGV.fetch(0)), aliases: true)
triggers = document.fetch("on", document[true])
raise "workflow is not repository_dispatch-only" unless triggers.keys == ["repository_dispatch"]
raise "workflow listens to the wrong event type" unless triggers.fetch("repository_dispatch").fetch("types") == ["somawork-release"]
raise "workflow default permissions are not read-only" unless document.fetch("permissions") == {"contents" => "read"}
raise "tap writes are not serialized" unless document.fetch("concurrency").fetch("group") == "homebrew-tap-bump"
raise "tap writes may be cancelled mid-push" unless document.fetch("concurrency").fetch("cancel-in-progress") == false

jobs = document.fetch("jobs")
raise "workflow does not split preflight from write" unless jobs.keys.sort == ["bump-somawork", "preflight-somawork"]
preflight = jobs.fetch("preflight-somawork")
bump = jobs.fetch("bump-somawork")

raise "preflight is not contents:read" unless preflight["permissions"] == {"contents" => "read"}
checkout = preflight.fetch("steps").find { |step| step["uses"].to_s.start_with?("actions/checkout") }
raise "preflight checkout is missing" unless checkout
raise "preflight checkout persists credentials" unless checkout.fetch("with")["persist-credentials"] == false
raise "preflight does not pin the tap branch" unless checkout.fetch("with")["ref"] == "master"
raise "preflight does not publish the resolved source commit" unless preflight.fetch("outputs", {}).fetch("source_sha", "").include?("steps.identity.outputs.source_sha")

# Event payload never reaches a shell body. `${{ }}` is substituted textually
# before bash parses the line, so a payload field containing a quote would
# execute — this is the one rule the whole privilege split rests on.
jobs.each do |name, job|
  job.fetch("steps").each_with_index do |step, index|
    body = step["run"]
    next if body.nil?
    if body.include?("${{")
      raise "#{name} step #{index} interpolates an expression into a shell body"
    end
    raise "#{name} step #{index} does not fail fast" unless body.start_with?("set -euo pipefail\n")
  end
  job.fetch("steps").each_with_index do |step, index|
    with = step["with"]
    next if with.nil?
    with.each do |key, value|
      next unless value.is_a?(String) && value.include?("${{")
      raise "#{name} step #{index} builds `#{key}` out of an event expression" if value.include?("client_payload")
    end
  end
end

# Every payload field arrives through env, and only through env.
payload_fields = %w[package tag manifest_url manifest_sha256 source_repository]
env_values = jobs.values.flat_map do |job|
  job.fetch("steps").flat_map { |step| step.fetch("env", {}).values }
end
payload_fields.each do |field|
  expression = "github.event.client_payload.#{field}"
  raise "no step receives #{field} through env" unless env_values.any? { |value| value.to_s.include?(expression) }
end

# The verifying step is the one that touches release bytes, and it must hold no
# credential of any kind.
verify_steps = preflight.fetch("steps").select do |step|
  step.fetch("run", "").include?("scripts/verify-somawork-assets.py")
end
raise "the payload verifier does not run exactly once" unless verify_steps.length == 1
verify_step = verify_steps.fetch(0)
verify_env = verify_step.fetch("env", {})
raise "the verifying step receives a token" if verify_env.keys.any? { |key| key.to_s.include?("TOKEN") }
verify_run = verify_step.fetch("run")
raise "the verifying step references a token" if verify_run.include?("GH_TOKEN") || verify_run.include?("github.token")
raise "the verifier keeps the runner environment" unless verify_run.include?("env -i")
raise "the verifier keeps the runner HOME" unless verify_run.include?('HOME="$verifier_home"')
raise "the verifier PATH is not minimal" unless verify_run.include?("PATH=/usr/bin:/bin")

preflight_runs = preflight.fetch("steps").map { |step| step.fetch("run", "") }.join("\n")
raise "preflight does not verify the release tag object" unless preflight_runs.include?("git/ref/tags/")

# Assert the comparison, not the field name. `--json tagName,isDraft` already
# contains the string "isDraft", so a check for the name alone stays green when
# both real comparisons are deleted — which is the whole failure mode this file
# exists to prevent elsewhere.
DRAFT_COMPARISON = %q{[[ "$(jq -r '.isDraft' <<<"$release")" == "false" ]]}
MANIFEST_DIGEST_COMPARISON = %q{[[ "$actual_manifest_sha256" == "$SOMAWORK_MANIFEST_SHA256" ]]}
raise "preflight does not compare the release's draft state" unless preflight_runs.include?(DRAFT_COMPARISON)
raise "preflight does not compare the downloaded manifest against the dispatched digest" unless preflight_runs.include?(MANIFEST_DIGEST_COMPARISON)
raise "preflight discovers a release instead of consuming the dispatched one" if preflight_runs.include?("gh release list")
raise "preflight discovers the latest release" if preflight_runs.include?("--json tagName -q .tagName")
raise "preflight does not pin the manifest digest" unless preflight_runs.include?("somawork-manifest.json")
raise "preflight downloads over an unpinned transport" unless preflight_runs.include?("--proto '=https' --tlsv1.2")

uploads = preflight.fetch("steps").select { |step| step["uses"].to_s.start_with?("actions/upload-artifact") }
raise "preflight uploads its proof more than once" unless uploads.length == 1
raise "the proof artifact name is built from the event" if uploads.fetch(0).fetch("with").fetch("name").include?("${{")
raise "a missing proof would pass silently" unless uploads.fetch(0).fetch("with")["if-no-files-found"] == "error"

raise "the write job does not hard-need preflight" unless Array(bump["needs"]) == ["preflight-somawork"]
raise "the write job lacks explicit contents:write" unless bump["permissions"] == {"contents" => "write"}
bump_runs = bump.fetch("steps").map { |step| step.fetch("run", "") }.join("\n")
raise "the write job runs the payload verifier" if bump_runs.include?("scripts/verify-somawork-assets.py")
raise "the write job downloads release archives" if bump_runs.include?(".tar.gz")
raise "the write job omits proof validation" unless bump_runs.include?("scripts/validate-somawork-preflight.py")
raise "the write job omits rendering" unless bump_runs.include?("scripts/render-somawork-formulae.py")
raise "proof validation does not precede rendering" unless bump_runs.index("scripts/validate-somawork-preflight.py") < bump_runs.index("scripts/render-somawork-formulae.py")
raise "the write job does not re-derive the source commit" unless bump_runs.include?("git/ref/tags/")
# The write job holds the token, so it repeats both comparisons rather than
# inheriting the read job's conclusions.
raise "the write job does not re-compare the release's draft state" unless bump_runs.include?(DRAFT_COMPARISON)
raise "the write job does not re-compare the manifest against the dispatched digest" unless bump_runs.include?(MANIFEST_DIGEST_COMPARISON)
raise "the write job takes the source commit from the event" if bump.fetch("steps").any? { |step| step.fetch("env", {})["SOMAWORK_SOURCE_SHA"].to_s.include?("client_payload") }
raise "the write job does not consume the preflight's resolved commit" unless bump.fetch("steps").any? { |step| step.fetch("env", {})["SOMAWORK_SOURCE_SHA"].to_s.include?("needs.preflight-somawork.outputs.source_sha") }
raise "the write job does not syntax-check what it commits" unless bump_runs.include?("ruby -c")

# The license the tap publishes is fixed metadata, and the write job checks it on
# the rendered bytes it is about to commit — not on the template they came from,
# which is not what anybody installs. Both halves are pinned as exact text:
# a substring match would pass `license "ISC-ish"`, a second license line, or a
# commented-out one, so deleting, weakening, or duplicating either check lands
# here rather than in a published formula.
LICENSE_LINE_CHECK = %q{grep -Fqx '  license "ISC"' "$formula"}
LICENSE_COUNT_CHECK = %q{[[ "$(grep -c '^[[:space:]]*license ' "$formula")" == 1 ]]}
POST_RENDER_LOOP = %q{for formula in Formula/somawork-cli.rb "$runtime_formula"; do}

{
  LICENSE_LINE_CHECK => "whole-line ISC check",
  LICENSE_COUNT_CHECK => "single-license-line check",
}.each do |needle, label|
  occurrences = bump_runs.scan(needle).length
  raise "the write job's #{label} is missing or has been altered" if occurrences.zero?
  raise "the write job repeats its #{label} #{occurrences} times" unless occurrences == 1
end
raise "the write job checks a license before it has rendered one" unless bump_runs.index("scripts/render-somawork-formulae.py") < bump_runs.index(LICENSE_LINE_CHECK)

# Placement is the property, not presence: the checks have to run inside the
# loop over the two formulae this dispatch actually wrote.
loop_start = bump_runs.index(POST_RENDER_LOOP)
raise "the write job no longer loops over the formulae it rendered" if loop_start.nil?
loop_end = bump_runs.index("\ndone", loop_start)
raise "the write job's post-render loop is unterminated" if loop_end.nil?
post_render = bump_runs[loop_start..loop_end]
[LICENSE_LINE_CHECK, LICENSE_COUNT_CHECK].each do |needle|
  raise "a license check sits outside the loop over the rendered formulae" unless post_render.include?(needle)
end
raise "the write job checks a template's license instead of the rendered formula's" if post_render.include?(".rb.tmpl")
raise "the post-render loop does not cover the controller" unless post_render.include?("Formula/somawork-cli.rb")
raise "the post-render loop does not cover the dispatched channel's runtime" unless post_render.include?(%q{"$runtime_formula"})
raise "the write job does not commit before rebasing" unless bump_runs.index("git commit -m") < bump_runs.index("git pull --rebase")
# A bound asserted by name is not a bound: `push_attempts=999` would satisfy it.
push_bound = bump_runs[/^\s*push_attempts=(\d+)$/, 1]
raise "the write job's push retry bound is not a literal number" if push_bound.nil?
raise "the write job's push retry bound is not 3: #{push_bound}" unless push_bound == "3"
raise "the write job does not use its retry bound" unless bump_runs.include?('for attempt in $(seq 1 "$push_attempts"); do')
raise "the write job does not confirm the push landed" unless bump_runs.include?("git ls-remote origin refs/heads/master")
raise "the write job is not idempotent on a repeated dispatch" unless bump_runs.include?("git diff --cached --quiet")

downloads = bump.fetch("steps").select { |step| step["uses"].to_s.start_with?("actions/download-artifact") }
raise "the write job does not consume the proof exactly once" unless downloads.length == 1
raise "the proof is consumed under a name the event controls" if downloads.fetch(0).fetch("with").fetch("name").include?("${{")
raise "the write job does not publish tap evidence" unless bump_runs.include?("somawork.tap-dispatch.v1")
raise "tap evidence omits the measured proof" unless bump_runs.include?("--slurpfile preflight")
raise "tap evidence does not bind the formula commit" unless bump_runs.include?("formula_commit")

# Channel selectivity, read off the workflow rather than trusted.
#
# The controller is the one formula every channel writes, so it is named
# literally. The runtime is not: the dispatch's `package` field IS the runtime
# formula's name, so the write job builds that path from the payload and can
# therefore never construct the other channel's. A literal `Formula/somawork.rb`
# or `Formula/somawork-preview.rb` anywhere in the write job would mean some
# channel is hard-coded, which is exactly the failure this checks for.
raise "the write job does not render the controller" unless bump_runs.include?("Formula/somawork-cli.rb")
raise "the write job does not render the dispatched channel's runtime" unless bump_runs.include?('Formula/$SOMAWORK_PACKAGE.rb')
["Formula/somawork.rb", "Formula/somawork-preview.rb"].each do |formula|
  raise "the write job hard-codes a channel: #{formula}" if bump_runs.include?(formula)
end
raise "the write job does not select the runtime template by channel" unless bump_runs.include?('Formula/$SOMAWORK_PACKAGE.rb.tmpl')
raise "the write job still passes both runtime templates" if bump_runs.include?("--preview-template") || bump_runs.include?("--production-template")
raise "the write job does not prove the other channel was left alone" unless bump_runs.include?('git status --porcelain -- "Formula/$other_package.rb"')
raise "the write job stages more than the controller and the selected runtime" unless bump_runs.include?('git add Formula/somawork-cli.rb "$runtime_formula"')
# Monotonicity is measured against every formula this run would replace. The
# controller is the one both channels write, so leaving it out of the baseline is
# how a stable bump would silently downgrade a preview controller.
raise "the write job does not baseline every formula it replaces" unless bump_runs.include?('for existing in Formula/somawork-cli.rb "$runtime_formula"; do')
raise "the write job does not pass the baselines to the renderer" unless bump_runs.include?('baseline+=(--not-below "$current_version")')
raise "the write job would render without its baselines" unless bump_runs.include?('"${baseline[@]}"')
RUBY

# The unprivileged verifier reads archives; it never runs them. That is a
# property of the file, not of the step that calls it.
if grep -Eq '\b(subprocess|os\.system|os\.popen|os\.exec[a-z]*|pty\.spawn)\b' "$verifier"; then
  fail "the payload verifier can execute release code"
fi
if grep -Eq '\b(urllib|requests|http\.client|socket)\b' "$verifier"; then
  fail "the payload verifier can reach the network"
fi

echo "somawork workflow contract: ok"
