#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
template="$root/Formula/xfx-preview.rb.tmpl"
rendered="$root/Formula/xfx-preview.rb"
workflow="$root/.github/workflows/bump.yml"
readme="$root/README.md"

fail() {
  echo "xfx preview tap contract: $*" >&2
  exit 1
}

# Exact immutable identity of a synthetic preview release. Nothing here touches
# the network: the four assets are fabricated locally and the source revision is
# a fixed 40-hex string whose first twelve characters are the tag's sha12.
tag="preview-2026-08-22-054213-32601234567-1-0123456789ab"
version="2026.08.22.054213.32601234567.1"
source_sha="0123456789abcdef0123456789abcdef01234567"
source_sha12="0123456789ab"

# ---------------------------------------------------------------- presence ---

[[ -f "$template" ]] \
  || fail "formula template is missing: Formula/xfx-preview.rb.tmpl"
grep -Eq "^  bump-xfx-preview:$" "$workflow" \
  || fail "bump.yml has no bump-xfx-preview job"
grep -Fq 'brew install 2lab-ai/tap/xfx-preview' "$readme" \
  || fail "README does not document the qualified install command"
grep -Fq '`xfx-preview`' "$readme" \
  || fail "README table has no xfx-preview row"
grep -Fq '`xfx`' "$readme" \
  || fail "README does not explain that the installed executable is xfx"

# ------------------------------------------------------- workflow contract ---

ruby - "$workflow" "$template" <<'RUBY'
require "yaml"

workflow, template = ARGV
def check(condition, message)
  raise "xfx preview tap contract: #{message}" unless condition
end

document = YAML.safe_load(File.read(workflow), aliases: true)
jobs = document.fetch("jobs")
check(jobs.key?("bump-xfx-preview"), "bump.yml has no bump-xfx-preview job")
job = jobs.fetch("bump-xfx-preview")

check(job["if"] == "github.event_name == 'schedule'",
      "xfx bump job is not schedule-only")
check(!job.key?("needs"),
      "xfx bump job is chained to another formula job and inherits its failures")

dispatch_inputs = document.fetch("on", document[true]).fetch("workflow_dispatch").fetch("inputs")
check(dispatch_inputs.keys == %w[tag source_sha version manifest_url manifest_sha256],
      "the dbotter-specific workflow_dispatch contract was altered")

runs = job.fetch("steps").map { |step| step.fetch("run", "") }.join("\n")

check(runs.include?("--repo 2lab-ai/xfx"),
      "job does not read the canonical 2lab-ai/xfx repository")
check(runs.include?("gh release list") && runs.include?('startswith("preview-")'),
      "job does not discover the latest preview-* prerelease")
check(runs.include?('^preview-([0-9]{4})-([0-9]{2})-([0-9]{2})-([0-9]{6})-([1-9][0-9]*)-([1-9][0-9]*)-([0-9a-f]{12})$'),
      "job does not validate the exact preview tag grammar")
check(runs.include?("isPrerelease"),
      "job does not confirm the release is a prerelease")
check(runs.include?("git/ref/tags/") && runs.include?(".object.type") && runs.include?(".object.sha"),
      "job does not confirm the tag points at a commit and derive the source sha")
%w[
  xfx-macos-aarch64
  xfx-macos-x86_64
  xfx-linux-aarch64
  xfx-linux-x86_64
  SHA256SUMS
].each do |asset|
  check(runs.include?(asset), "job does not download #{asset}")
end
check(runs.include?("sha256sum --check --strict SHA256SUMS"),
      "job does not verify the published checksums against the downloaded assets")
# These two overlap with checks that a stubbed run can defeat first, so no single
# input isolates them behaviourally; pin the comparisons themselves rather than
# only the variable names around them.
check(runs.include?('[[ "$actual_names" == "$expected_names" ]]'),
      "job does not compare the SHA256SUMS entry set against the four contract assets")
check(runs.include?("(.[0].tagName == $tag)") && runs.include?("(.[0].isPrerelease == true)"),
      "job does not reconfirm the re-read release tag and prerelease flag together")
check(!runs.include?(%q{jq -r '.tagName' <<<"$release"}),
      "job still reads the re-read release through an unguarded jq, whose output survives its own parse error")
check(runs.include?("published_version"),
      "job does not test for an existing formula separately from reading its version")
check(!runs.include?('*"Not Found"*'),
      "job still classifies a failed ref query by prose; only the response body may retire a candidate")
check(!runs.match?(/grep -Eo 'HTTP/),
      "job still scrapes HTTP status codes out of text")
check(runs.include?('>"$out" 2>"$err"'),
      "job does not capture the ref query's stdout and stderr separately")
check(runs.include?("(.status | tostring)"),
      "job does not retire a candidate on the response body's structural status")
check(runs.include?("preview_version_gt"),
      "job has no numeric freshness comparator")
check(runs.include?("select_preview_release"),
      "job has no enumerating preview-release selector")
check(!runs.include?("createdAt"),
      "job still orders preview releases by createdAt instead of the derived version")
check(runs.include?("Formula/xfx-preview.rb.tmpl"),
      "job does not render from the tracked template")
check(runs.include?("ruby -c Formula/xfx-preview.rb"),
      "job does not syntax-check the rendered formula")
check(runs.match?(/grep .*@\[A-Z0-9_\]/),
      "job does not reject unrendered placeholders")
# The source repository writes this same formula from a separate concurrency
# group, so publishing must survive a lost race. Re-deriving from the winning
# remote state beats rebasing: the only file that can conflict is the formula and
# the correct resolution is always "re-read freshness, then re-render".
check(runs.include?("git fetch origin master"),
      "job does not re-read master before publishing")
check(runs.include?("git reset --hard FETCH_HEAD"),
      "job does not re-derive from the winning remote state")
check(runs.include?("git push origin HEAD:master"),
      "job does not push the bump")
check(!runs.include?("git pull --rebase"),
      "job still resolves a lost push race by rebasing")
check(runs.match?(/for attempt in 1 2 3/),
      "job does not bound its publish retries")

template_placeholders = File.read(template).scan(/@[A-Z0-9_]+@/).uniq.sort
workflow_placeholders = runs.scan(/@[A-Z0-9_]+@/).uniq.sort
check(!template_placeholders.empty?, "template has no placeholders")
check(workflow_placeholders == template_placeholders,
      "render substitutes #{workflow_placeholders.inspect} but the template needs #{template_placeholders.inspect}")
RUBY

work="$(mktemp -d "${TMPDIR:-/tmp}/xfx-preview-contract.XXXXXX")"
trap 'rm -rf "$work"' EXIT HUP INT TERM

# ---------------------------------------------------------- release assets ---

assets="$work/assets"
mkdir -p "$assets"
for asset in xfx-macos-aarch64 xfx-macos-x86_64 xfx-linux-aarch64 xfx-linux-x86_64; do
  printf 'fake xfx preview payload for %s\n' "$asset" >"$assets/$asset"
done
(
  cd "$assets"
  shasum -a 256 \
    xfx-macos-aarch64 xfx-macos-x86_64 xfx-linux-aarch64 xfx-linux-x86_64 \
    >SHA256SUMS
  shasum -a 256 --check --status SHA256SUMS
) || fail "fabricated SHA256SUMS does not verify"
export XFX_STUB_ASSETS="$assets"

sha_of() {
  awk -v name="$1" '{ file = $2; sub(/^\*/, "", file); if (file == name) print $1 }' \
    "$assets/SHA256SUMS"
}

# ------------------------------------------------- freshness guard behaviour --

# Extract the comparator the workflow actually ships and exercise it here, so the
# no-downgrade guard is tested rather than grepped.
ruby -ryaml - "$workflow" >"$work/xfx-job.sh" <<'RUBY'
document = YAML.safe_load(File.read(ARGV.fetch(0)), aliases: true)
job = document.fetch("jobs").fetch("bump-xfx-preview")
print job.fetch("steps").map { |step| step.fetch("run", "") }.join("\n")
RUBY
awk '/^preview_version_gt\(\) \{$/, /^\}$/' "$work/xfx-job.sh" >"$work/version-gt.sh"
[[ -s "$work/version-gt.sh" ]] \
  || fail "the shipped preview_version_gt() function could not be extracted"
# shellcheck source=/dev/null
source "$work/version-gt.sh"

newer() {
  preview_version_gt "$1" "$2" \
    || fail "freshness guard refuses a strictly newer version: $1 > $2"
}
not_newer() {
  if preview_version_gt "$1" "$2"; then
    fail "freshness guard would downgrade: $1 accepted over $2"
  fi
}
newer "$version" "2026.08.22.054212.32601234567.1"
newer "$version" "2026.08.21.235959.99999999999.9"
newer "2026.08.22.054213.32601234568.1" "$version"
newer "2026.08.22.054213.32601234567.2" "$version"
not_newer "$version" "$version"
not_newer "2026.08.22.054212.32601234567.1" "$version"
not_newer "2026.08.21.235959.99999999999.9" "$version"
not_newer "2026.08.22.054213.32601234567.1" "2026.08.22.054213.32601234567.2"
# Leading-zero clock fields must compare as decimal, not octal.
newer "2026.08.22.094213.32601234567.1" "2026.08.22.084213.32601234567.1"

# The comparator only matters if the job actually applies it to the tracked
# formula, so exercise the decision the caller delegates to.
awk '/^preview_bump_needed\(\) \{$/, /^\}$/' "$work/xfx-job.sh" >"$work/bump-needed.sh"
[[ -s "$work/bump-needed.sh" ]] \
  || fail "the shipped preview_bump_needed() function could not be extracted"
# shellcheck source=/dev/null
source "$work/bump-needed.sh"

bump_decision() {
  local status=0
  preview_bump_needed "$1" "$2" 2>/dev/null || status=$?
  echo "$status"
}
[[ "$(bump_decision "$version" "")" == "0" ]] \
  || fail "no-downgrade guard refuses the first render when no formula exists yet"
[[ "$(bump_decision "$version" "2026.08.22.054212.32601234567.1")" == "0" ]] \
  || fail "no-downgrade guard refuses a strictly newer build"
[[ "$(bump_decision "$version" "$version")" == "1" ]] \
  || fail "no-downgrade guard re-renders the version already in the formula"
[[ "$(bump_decision "$version" "2026.08.22.054214.32601234567.1")" == "1" ]] \
  || fail "no-downgrade guard would replace a newer formula with an older build"
[[ "$(bump_decision "$version" "2026.08.22.054213.32601234567.2")" == "1" ]] \
  || fail "no-downgrade guard ignores the run attempt already in the formula"
[[ "$(bump_decision "$version" "preview-2026-08-22")" == "2" ]] \
  || fail "no-downgrade guard clobbers a formula whose version it cannot read"

# -------------------------------------------------- release selection --------

# The backstop must pick the highest *valid* preview build, not the most recently
# created release. A release recreated later with an older stamp, or a malformed
# tag published after a good one, would otherwise pin the tap stale forever.
for helper in tag_ref_query select_preview_release; do
  awk -v fn="^$helper\\\\(\\\\) \\\\{$" '$0 ~ fn, /^\}$/' "$work/xfx-job.sh" >"$work/$helper.sh"
  [[ -s "$work/$helper.sh" ]] \
    || fail "the shipped $helper() function could not be extracted"
  # shellcheck source=/dev/null
  source "$work/$helper.sh"
done

stub_bin="$work/gh-stub"
mkdir -p "$stub_bin" "$work/refs"
export XFX_STUB_REFS="$work/refs"
cat >"$stub_bin/gh" <<'STUB'
#!/bin/bash
# Offline stand-in for the GitHub CLI. It answers only the calls the shipped job
# makes, and refuses anything else so a silently changed call site is visible.
subcommand="${1:-}"
action="${2:-}"
pattern=""
output=""
target=""
[ "$#" -ge 2 ] && shift 2 || shift $#
while [ "$#" -gt 0 ]; do
  case "$1" in
    --pattern) pattern="${2:-}"; shift 2 ;;
    --output) output="${2:-}"; shift 2 ;;
    --clobber) shift ;;
    --limit|--json|--jq|--repo) shift 2 ;;
    -*) shift ;;
    *)
      if [ -z "$target" ]; then target="$1"; fi
      shift
      ;;
  esac
done
case "$subcommand" in
  release)
    case "$action" in
      list)
        # A failed or unreadable listing must never look like "no releases yet".
        if [ -n "${XFX_STUB_LIST_STATUS:-}" ]; then
          echo "gh: could not reach api.github.com" >&2
          exit "$XFX_STUB_LIST_STATUS"
        fi
        if [ -n "${XFX_STUB_LIST_EMPTY:-}" ]; then
          # Succeeds and prints nothing at all. jq reads zero documents from that
          # and exits 0, which must not be mistaken for an empty release list.
          exit 0
        fi
        if [ -n "${XFX_STUB_LIST_GARBAGE:-}" ]; then
          printf '%s\n' "$XFX_STUB_LIST_GARBAGE"
          exit 0
        fi
        cat "$XFX_STUB_RELEASES"
        ;;
      view)
        # A separate view fixture lets a test model a release that was edited
        # between the listing and the direct re-read.
        jq -c --arg tag "$target" \
          '[.[] | select(.tagName == $tag)] | first | {tagName, isPrerelease}' \
          "${XFX_STUB_VIEW:-$XFX_STUB_RELEASES}"
        # Expected output followed by junk: anything that reads only the first
        # document sees exactly what it wanted and misses the failure entirely.
        if [ -n "${XFX_STUB_VIEW_TRAILER:-}" ]; then
          printf '%s\n' "$XFX_STUB_VIEW_TRAILER"
        fi
        ;;
      download)
        if [ -f "$XFX_STUB_ASSETS/$pattern" ]; then
          cp "$XFX_STUB_ASSETS/$pattern" "$output"
        else
          echo "gh: no asset $pattern in $target" >&2
          exit 1
        fi
        ;;
      *)
        echo "unexpected gh release $action" >&2
        exit 9
        ;;
    esac
    ;;
  api)
    # `<tag>.fail` models a failed query: line 1 is the exit status and the rest
    # is what gh writes to stderr. `<tag>.failbody` is the response body, on
    # stdout. They are separate files because the whole point is that the
    # classifier must not be able to reach the prose.
    ref_tag="${action##*/}"
    if [ -f "$XFX_STUB_REFS/$ref_tag.fail" ]; then
      fail_status=$(head -1 "$XFX_STUB_REFS/$ref_tag.fail")
      if [ -f "$XFX_STUB_REFS/$ref_tag.failbody" ]; then
        cat "$XFX_STUB_REFS/$ref_tag.failbody"
      fi
      tail -n +2 "$XFX_STUB_REFS/$ref_tag.fail" >&2
      exit "$fail_status"
    fi
    ref="$XFX_STUB_REFS/$ref_tag.json"
    if [ -f "$ref" ]; then
      cat "$ref"
    else
      # Exactly what gh 2.96.0 emits for a missing resource: the JSON error body
      # on stdout, its own one-line summary on stderr, exit 1.
      printf '{"message":"Not Found","documentation_url":"https://docs.github.com/rest/git/refs#get-a-reference","status":"404"}\n'
      echo "gh: Not Found (HTTP 404)" >&2
      exit 1
    fi
    ;;
  *)
    echo "unexpected gh $subcommand" >&2
    exit 9
    ;;
esac
STUB
chmod 0755 "$stub_bin/gh"

ref_json() {
  printf '{"ref":"refs/tags/%s","object":{"type":"%s","sha":"%s"}}\n' "$1" "$2" "$3" \
    >"$work/refs/$1.json"
}

# One valid but older build whose release was created *after* the winner.
decoy_tag="preview-2026-08-20-101010-32500000000-1-aaaaaaaaaaaa"
decoy_version="2026.08.20.101010.32500000000.1"
decoy_sha="aaaaaaaaaaaabcdef0123456789abcdef0123456"
# Every remaining candidate is invalid, and each carries a later stamp than the
# winner so a naive "newest wins" selector would take it.
malformed_tag="preview-2026-08-24-0900-32700000000-1-cccccccccccc"
unreleased_tag="preview-2026-08-25-000000-32800000000-1-dddddddddddd"
missing_ref_tag="preview-2026-08-26-000000-32900000000-1-eeeeeeeeeeee"
sha_mismatch_tag="preview-2026-08-27-000000-33000000000-1-ffffffffffff"
annotated_tag="preview-2026-08-28-000000-33100000000-1-111111111111"

ref_json "$tag" commit "$source_sha"
ref_json "$decoy_tag" commit "$decoy_sha"
ref_json "$malformed_tag" commit "ccccccccccccbcdef0123456789abcdef0123456"
ref_json "$unreleased_tag" commit "ddddddddddddbcdef0123456789abcdef0123456"
ref_json "$sha_mismatch_tag" commit "0000000000000000000000000000000000000000"
ref_json "$annotated_tag" tag "1111111111111111111111111111111111111111"
# missing_ref_tag deliberately has no git ref at all.

# Winner last, so "first valid candidate wins" is excluded too.
cat >"$work/releases-mixed.json" <<JSON
[
  {"tagName": "v0.1.0", "isPrerelease": false, "createdAt": "2026-09-01T00:00:00Z"},
  {"tagName": "$malformed_tag", "isPrerelease": true, "createdAt": "2026-08-31T00:00:00Z"},
  {"tagName": "$decoy_tag", "isPrerelease": true, "createdAt": "2026-08-30T00:00:00Z"},
  {"tagName": "$annotated_tag", "isPrerelease": true, "createdAt": "2026-08-29T00:00:00Z"},
  {"tagName": "$sha_mismatch_tag", "isPrerelease": true, "createdAt": "2026-08-28T00:00:00Z"},
  {"tagName": "$missing_ref_tag", "isPrerelease": true, "createdAt": "2026-08-27T00:00:00Z"},
  {"tagName": "$unreleased_tag", "isPrerelease": false, "createdAt": "2026-08-26T00:00:00Z"},
  {"tagName": "$tag", "isPrerelease": true, "createdAt": "2026-08-21T00:00:00Z"}
]
JSON

# Winner first, so "last valid candidate wins" is excluded as well; createdAt
# order is the exact inverse of numeric version order.
cat >"$work/releases-createdat.json" <<JSON
[
  {"tagName": "$tag", "isPrerelease": true, "createdAt": "2026-08-21T00:00:00Z"},
  {"tagName": "$decoy_tag", "isPrerelease": true, "createdAt": "2026-08-30T00:00:00Z"}
]
JSON

cat >"$work/releases-none-valid.json" <<JSON
[
  {"tagName": "$malformed_tag", "isPrerelease": true, "createdAt": "2026-08-31T00:00:00Z"},
  {"tagName": "$annotated_tag", "isPrerelease": true, "createdAt": "2026-08-29T00:00:00Z"},
  {"tagName": "$sha_mismatch_tag", "isPrerelease": true, "createdAt": "2026-08-28T00:00:00Z"},
  {"tagName": "$missing_ref_tag", "isPrerelease": true, "createdAt": "2026-08-27T00:00:00Z"},
  {"tagName": "$unreleased_tag", "isPrerelease": false, "createdAt": "2026-08-26T00:00:00Z"}
]
JSON

cat >"$work/releases-none.json" <<JSON
[
  {"tagName": "v0.1.0", "isPrerelease": false, "createdAt": "2026-09-01T00:00:00Z"}
]
JSON

# Isolates the tag-ref check: this candidate is a well-formed preview prerelease
# and would win outright if the job did not insist the tag actually exists.
cat >"$work/releases-only-missing-ref.json" <<JSON
[
  {"tagName": "$missing_ref_tag", "isPrerelease": true, "createdAt": "2026-08-27T00:00:00Z"}
]
JSON

select_with() {
  local fixture="$work/releases-$1.json"
  hash -r
  XFX_STUB_RELEASES="$fixture" PATH="$stub_bin:$PATH" \
    select_preview_release 2>"$work/select.err"
}

# A failing query must be an error, never the "nothing published yet" no-op: the
# selector runs inside a guarded command substitution, so `set -e` does not abort
# it and an unchecked failure would silently degrade to "no candidates".
select_with_broken_list() {
  hash -r
  XFX_STUB_RELEASES="$work/releases-mixed.json" \
  XFX_STUB_LIST_STATUS="${1:-}" \
  XFX_STUB_LIST_GARBAGE="${2:-}" \
  PATH="$stub_bin:$PATH" \
    select_preview_release 2>"$work/select.err"
}

expected_selection="$(printf '%s\t%s\t%s' "$tag" "$version" "$source_sha")"

selection="$(select_with mixed)" \
  || fail "selector rejected a list that contains one fully valid candidate"
[[ "$selection" == "$expected_selection" ]] \
  || fail "selector chose $(printf '%q' "$selection"), expected $(printf '%q' "$expected_selection")"
for skipped in \
  "$malformed_tag" "$unreleased_tag" "$missing_ref_tag" "$sha_mismatch_tag" "$annotated_tag"; do
  grep -Fq "$skipped" "$work/select.err" \
    || fail "selector silently dropped an invalid candidate: $skipped"
done
if grep -Fq "$decoy_tag" "$work/select.err"; then
  fail "selector rejected the valid older candidate instead of ranking it"
fi

selection="$(select_with createdat)" \
  || fail "selector rejected a list of two valid candidates"
[[ "$selection" == "$expected_selection" ]] \
  || fail "selector followed createdAt instead of the derived version: got $(printf '%q' "$selection")"

selection_status=0
select_with none-valid >/dev/null || selection_status=$?
[[ "$selection_status" -eq 2 ]] \
  || fail "selector did not fail explicitly when every candidate is invalid (exit $selection_status)"

selection_status=0
select_with none >/dev/null || selection_status=$?
[[ "$selection_status" -eq 1 ]] \
  || fail "selector did not report 'no preview candidate' as a no-op (exit $selection_status)"

selection_status=0
select_with only-missing-ref >/dev/null || selection_status=$?
[[ "$selection_status" -eq 2 ]] \
  || fail "selector accepted a preview tag that resolves to no commit (exit $selection_status)"

selection_status=0
select_with_broken_list 17 "" >/dev/null || selection_status=$?
[[ "$selection_status" -eq 2 ]] \
  || fail "a failed release query reports $selection_status, not an error (2); exit 1 means the job silently no-ops on an API outage"

selection_status=0
select_with_broken_list "" 'not json at all' >/dev/null || selection_status=$?
[[ "$selection_status" -eq 2 ]] \
  || fail "an unparseable release listing reports $selection_status, not an error (2)"

selection_status=0
select_with_broken_list "" '{"message":"Not Found"}' >/dev/null || selection_status=$?
[[ "$selection_status" -eq 2 ]] \
  || fail "a non-array release listing reports $selection_status, not an error (2)"

# A query that succeeds and prints nothing is not an empty release list: jq reads
# zero documents from it and exits 0, so an unguarded pipeline degrades to no-op.
selection_status=0
export XFX_STUB_LIST_EMPTY=1
select_with mixed >/dev/null || selection_status=$?
unset XFX_STUB_LIST_EMPTY
[[ "$selection_status" -eq 2 ]] \
  || fail "an empty-but-successful release query reports $selection_status, not an error (2)"

selection_status=0
select_with_broken_list "" '[{"tagName":"v0.1.0","isPrerelease":false}] trailing junk' >/dev/null \
  || selection_status=$?
[[ "$selection_status" -eq 2 ]] \
  || fail "a release listing with trailing bytes reports $selection_status, not an error (2)"

# Two well-formed documents in one response: every byte parses, so only a document
# count catches it. Left unchecked, both arrays feed the candidate extraction.
selection_status=0
select_with_broken_list "" \
  "[{\"tagName\":\"$tag\",\"isPrerelease\":true}] [{\"tagName\":\"$decoy_tag\",\"isPrerelease\":true}]" \
  >/dev/null || selection_status=$?
[[ "$selection_status" -eq 2 ]] \
  || fail "a doubled release listing reports $selection_status, not an error (2)"

# ...but a genuinely empty array is the one case that means "nothing published".
printf '[]\n' >"$work/releases-empty-array.json"
selection_status=0
select_with empty-array >/dev/null || selection_status=$?
[[ "$selection_status" -eq 1 ]] \
  || fail "an empty release array reports $selection_status, not the no-op code (1)"

# A per-candidate ref query that failed for any reason other than a confirmed 404
# must stop the job. Silently treating it as "tag missing" lets a transient 5xx on
# the newest build promote an older one, which is a downgrade with extra steps.
ref_fail() {
  printf '%s\n%s\n' "$2" "$3" >"$work/refs/$1.fail"
}
ref_fail_body() {
  printf '%s\n' "$2" >"$work/refs/$1.failbody"
}
clear_ref_fail() {
  rm -f "$work/refs/$1.fail" "$work/refs/$1.failbody"
}
cat >"$work/releases-transient.json" <<JSON
[
  {"tagName": "$tag", "isPrerelease": true, "createdAt": "2026-08-21T00:00:00Z"},
  {"tagName": "$decoy_tag", "isPrerelease": true, "createdAt": "2026-08-30T00:00:00Z"}
]
JSON
# `gh api` exits 1 for every HTTP error, so the reported status is the only thing
# that may classify a failure. Prose cannot: a proxy or upstream 5xx routinely
# says "Not Found" in its body, and a missing status at all is not evidence of a
# deleted tag. Only an unambiguous, confirmed 404 may skip a candidate.
for failure in \
  "1|Service Unavailable (HTTP 503)" \
  "1|Bad credentials (HTTP 401)" \
  "1|API rate limit exceeded (HTTP 403)" \
  "1|upstream Not Found while handling request (HTTP 503)" \
  "1|Not Found (HTTP 401)" \
  "1|Not Found" \
  "1|gateway said Not Found (HTTP 404) then (HTTP 503)" \
  "1|no status at all, just words" \
  "1|proxy failed after upstream returned HTTP 404" \
  "1|{\"message\":\"Not Found\",\"status\":\"503\"} and the summary says (HTTP 404)"; do
  status="${failure%%|*}"
  message="${failure#*|}"
  ref_fail "$tag" "$status" "$message"
  selection_status=0
  selection="$(select_with transient)" || selection_status=$?
  clear_ref_fail "$tag"
  [[ "$selection_status" -eq 2 ]] \
    || fail "a '$message' ref query reports $selection_status; selector returned '${selection:-}' instead of failing"
done

# Same again, but now with a response body present. Only a body that carries its
# own structural status of exactly 404 may retire a candidate; prose in the body,
# an HTML error page, several documents and a truncated body must all stop.
for body in \
  '{"message":"Not Found (HTTP 404)"}' \
  '{"message":"Not Found","documentation_url":"https://docs.github.com/rest"}' \
  '<html><body>404 Not Found</body></html>' \
  '{"message":"Not Found","status":"404"} {"message":"Not Found","status":"404"}' \
  '{"message":"Not Found","status":"503"}' \
  '["Not Found",404]' \
  '' ; do
  ref_fail "$tag" 1 "gh: Not Found (HTTP 404)"
  ref_fail_body "$tag" "$body"
  selection_status=0
  selection="$(select_with transient)" || selection_status=$?
  clear_ref_fail "$tag"
  [[ "$selection_status" -eq 2 ]] \
    || fail "a ref query answering '${body:-<empty>}' reports $selection_status; selector returned '${selection:-}' instead of failing"
done

# A body that does structurally report 404 retires the candidate, whatever gh's
# prose says. Documented policy: the response body is the only authority, because
# re-admitting prose as a veto re-admits the substring matching being removed.
for pair in \
  '{"message":"Not Found","status":"404"}|gh: Not Found (HTTP 404)' \
  '{"message":"Not Found","status":404}|gh: Not Found (HTTP 404)' \
  '{"message":"Not Found","status":"404"}|gh: Service Unavailable (HTTP 503)'; do
  body="${pair%%|*}"
  message="${pair#*|}"
  ref_fail "$tag" 1 "$message"
  ref_fail_body "$tag" "$body"
  selection_status=0
  selection="$(select_with transient)" || selection_status=$?
  clear_ref_fail "$tag"
  [[ "$selection_status" -eq 0 ]] \
    || fail "a structural 404 body with stderr '$message' did not retire the candidate (exit $selection_status)"
  [[ "$selection" == "$(printf '%s\t%s\t%s' "$decoy_tag" "$decoy_version" "$decoy_sha")" ]] \
    || fail "after a structural 404 the selector chose $(printf '%q' "$selection")"
done

# A confirmed 404 stays an invalid-candidate skip, so one deleted tag does not
# stop the tap from tracking the newest build that does exist.
mv "$work/refs/$tag.json" "$work/refs/$tag.json.hidden"
selection_status=0
selection="$(select_with transient)" || selection_status=$?
mv "$work/refs/$tag.json.hidden" "$work/refs/$tag.json"
[[ "$selection_status" -eq 0 ]] \
  || fail "a confirmed 404 on one candidate stopped the whole selection (exit $selection_status)"
[[ "$selection" == "$(printf '%s\t%s\t%s' "$decoy_tag" "$decoy_version" "$decoy_sha")" ]] \
  || fail "after skipping a deleted tag the selector chose $(printf '%q' "$selection")"

# A ref that comes back but is not a git ref object is a parse failure, not a
# missing tag: the two unguarded jq reads it replaced could yield "null".
printf '{"message":"Moved Permanently"}\n' >"$work/refs/$tag.json"
selection_status=0
selection="$(select_with transient)" || selection_status=$?
ref_json "$tag" commit "$source_sha"
[[ "$selection_status" -eq 2 ]] \
  || fail "an unreadable tag ref reports $selection_status; selector returned '${selection:-}'"

# Two well-formed ref documents in one response: every byte parses, so only a
# document count catches it, and reading just the first would answer confidently.
{
  printf '{"ref":"refs/tags/%s","object":{"type":"commit","sha":"%s"}}\n' "$tag" "$source_sha"
  printf '{"ref":"refs/tags/%s","object":{"type":"commit","sha":"%s"}}\n' "$decoy_tag" "$decoy_sha"
} >"$work/refs/$tag.json"
selection_status=0
selection="$(select_with transient)" || selection_status=$?
ref_json "$tag" commit "$source_sha"
[[ "$selection_status" -eq 2 ]] \
  || fail "a doubled tag ref reports $selection_status; selector returned '${selection:-}'"

# ------------------------------------------------- render step, end to end --

# Run the shipped render step itself against the stubbed release, so the formula
# under test is produced by the workflow's own code rather than by a copy of it,
# and so the caller's wiring (not just its helper functions) is exercised.
ruby -ryaml - "$workflow" >"$work/render-step.sh" <<'RUBY'
document = YAML.safe_load(File.read(ARGV.fetch(0)), aliases: true)
job = document.fetch("jobs").fetch("bump-xfx-preview")
step = job.fetch("steps").find { |candidate| candidate.fetch("run", "").include?("select_preview_release") }
raise "xfx preview tap contract: no render step invokes select_preview_release" if step.nil?

print step.fetch("run")
RUBY

XFX_REAL_GIT="$(command -v git)"
export XFX_REAL_GIT

remote="$work/remote.git"
repo="$work/repo"
other="$work/other"
"$XFX_REAL_GIT" init -q --bare "$remote"
"$XFX_REAL_GIT" -C "$remote" symbolic-ref HEAD refs/heads/master
"$XFX_REAL_GIT" clone -q "$remote" "$repo" 2>/dev/null
mkdir -p "$repo/Formula"
cp "$template" "$repo/Formula/xfx-preview.rb.tmpl"
printf 'scratch tap\n' >"$repo/README.md"
"$XFX_REAL_GIT" -C "$repo" add -A
"$XFX_REAL_GIT" -C "$repo" -c user.email=seed@example.invalid -c user.name=seed \
  commit -qm "seed"
"$XFX_REAL_GIT" -C "$repo" push -q origin HEAD:master
"$XFX_REAL_GIT" clone -q "$remote" "$other"

# The source repository pushes this same formula from a different concurrency
# group, so a rejected push is an ordinary event. This wrapper makes that race
# deterministic: before the step's Nth push it lets a second clone land a real
# commit, so the step's push is genuinely rejected by git as non-fast-forward
# rather than by a faked error string.
cat >"$stub_bin/git" <<'STUB'
#!/bin/bash
if [ "${1:-}" = "push" ] && [ -n "${XFX_PUSH_LOG:-}" ]; then
  echo "push" >>"$XFX_PUSH_LOG"
  attempted=$(wc -l <"$XFX_PUSH_LOG" | tr -d ' ')
  if [ "$attempted" -le "${XFX_RACE_PUSHES:-0}" ]; then
    "$XFX_RACE_INJECT" "$attempted" >>"$XFX_RACE_LOG" 2>&1
  fi
fi
exec "$XFX_REAL_GIT" "$@"
STUB
chmod 0755 "$stub_bin/git"

cat >"$work/inject.sh" <<'INJECT'
#!/bin/bash
set -euo pipefail
n="${1:?attempt required}"
"$XFX_REAL_GIT" -C "$XFX_OTHER" fetch -q origin master
"$XFX_REAL_GIT" -C "$XFX_OTHER" reset -q --hard FETCH_HEAD
case "${XFX_RACE_KIND:-unrelated}" in
  unrelated)
    printf 'concurrent unrelated write %s\n' "$n" >>"$XFX_OTHER/README.md"
    ;;
  newer)
    sed 's/^  version ".*"$/  version "2999.01.01.000000.1.1"/' "$XFX_RACE_FORMULA" \
      >"$XFX_OTHER/Formula/xfx-preview.rb"
    ;;
  unreadable)
    sed 's/^  version ".*"$/  version "preview-2026-08-22"/' "$XFX_RACE_FORMULA" \
      >"$XFX_OTHER/Formula/xfx-preview.rb"
    ;;
  *)
    echo "unknown race kind ${XFX_RACE_KIND:-}" >&2
    exit 1
    ;;
esac
"$XFX_REAL_GIT" -C "$XFX_OTHER" add -A
"$XFX_REAL_GIT" -C "$XFX_OTHER" -c user.email=other@example.invalid -c user.name=other \
  commit -qm "concurrent write $n"
"$XFX_REAL_GIT" -C "$XFX_OTHER" push -q origin HEAD:master
INJECT
chmod 0755 "$work/inject.sh"

export XFX_OTHER="$other"
export XFX_RACE_INJECT="$work/inject.sh"
export XFX_RACE_LOG="$work/inject.log"
export XFX_RACE_FORMULA="$work/xfx-preview.rb"
export XFX_RACE_PUSHES=0
export XFX_RACE_KIND=unrelated

publish_step() {
  local assets_dir="${1:-$assets}"
  local view_fixture="${2:-$work/releases-mixed.json}"
  rm -f "$work/render.out"
  : >"$work/push.log"
  : >"$work/inject.log"
  (
    cd "$repo"
    hash -r
    XFX_STUB_RELEASES="$work/releases-mixed.json" \
    XFX_STUB_VIEW="$view_fixture" \
    XFX_STUB_ASSETS="$assets_dir" \
    XFX_PUSH_LOG="$work/push.log" \
    PATH="$stub_bin:$PATH" \
      bash "$work/render-step.sh"
  ) >"$work/render.out" 2>&1
}

push_attempts() {
  wc -l <"$work/push.log" | tr -d ' '
}
remote_formula() {
  "$XFX_REAL_GIT" -C "$remote" show master:Formula/xfx-preview.rb 2>/dev/null || true
}
remote_version() {
  remote_formula | sed -n 's/^  version "\(.*\)"$/\1/p' | head -1
}
# Put the published formula into a known state without going through the step.
seed_remote() {
  local want="${1:?state required}"
  "$XFX_REAL_GIT" -C "$other" fetch -q origin master
  "$XFX_REAL_GIT" -C "$other" reset -q --hard FETCH_HEAD
  if [ "$want" = "none" ]; then
    rm -f "$other/Formula/xfx-preview.rb"
  else
    sed "s/^  version \".*\"\$/  version \"$want\"/" "$work/xfx-preview.rb" \
      >"$other/Formula/xfx-preview.rb"
  fi
  "$XFX_REAL_GIT" -C "$other" add -A
  "$XFX_REAL_GIT" -C "$other" -c user.email=seed@example.invalid -c user.name=seed \
    commit -qm "seed published state: $want" --allow-empty
  "$XFX_REAL_GIT" -C "$other" push -q origin HEAD:master
}

publish_status=0
publish_step || publish_status=$?
[[ "$publish_status" -eq 0 ]] \
  || fail "publish step failed on a valid release: $(cat "$work/render.out")"
[[ "$(push_attempts)" -eq 1 ]] \
  || fail "publish step needed $(push_attempts) pushes on an uncontended tap"

formula="$repo/Formula/xfx-preview.rb"
[[ -f "$formula" ]] || fail "publish step produced no Formula/xfx-preview.rb"
[[ "$(remote_version)" == "$version" ]] \
  || fail "publish step did not push the formula: remote is at '$(remote_version)'"

# The step must render the *selected* build, not whichever release came last.
grep -Fq "version \"$version\"" "$formula" \
  || fail "publish step pinned the wrong version: $(sed -n 's/^  version "\(.*\)"$/\1/p' "$formula")"
for asset in xfx-macos-aarch64 xfx-macos-x86_64 xfx-linux-aarch64 xfx-linux-x86_64; do
  grep -Fq "releases/download/$tag/$asset" "$formula" \
    || fail "publish step did not pin the exact-tag URL for $asset"
  grep -Fq "sha256 \"$(sha_of "$asset")\"" "$formula" \
    || fail "publish step did not pin the published checksum for $asset"
done
# Keep this good render for the formula-level assertions further down; the cases
# below deliberately leave the published formula in other states.
cp "$formula" "$work/xfx-preview.rb"

# Re-running against an already-current tap must not push, and must not add an
# empty commit on top of the formula it already published.
before_head="$("$XFX_REAL_GIT" -C "$remote" rev-parse master)"
publish_status=0
publish_step || publish_status=$?
[[ "$publish_status" -eq 0 ]] || fail "publish step failed on an already-current tap"
[[ "$(push_attempts)" -eq 0 ]] \
  || fail "publish step pushed again with nothing to change"
[[ "$("$XFX_REAL_GIT" -C "$remote" rev-parse master)" == "$before_head" ]] \
  || fail "publish step moved master with nothing to change"

# Freshness through the caller: a newer published formula must survive untouched,
# an older one must be replaced, an unreadable one must stop the job.
seed_remote 2999.01.01.000000.1.1
publish_status=0
publish_step || publish_status=$?
[[ "$publish_status" -eq 0 ]] \
  || fail "publish step failed instead of no-opping on an already-newer formula"
[[ "$(remote_version)" == "2999.01.01.000000.1.1" ]] \
  || fail "publish step downgraded a newer formula to $version"
[[ "$(push_attempts)" -eq 0 ]] || fail "publish step pushed a downgrade"
grep -Fq "refusing to replace" "$work/render.out" \
  || fail "publish step skipped a newer formula without saying so"

seed_remote 2000.01.01.000000.1.1
publish_status=0
publish_step || publish_status=$?
[[ "$publish_status" -eq 0 ]] || fail "publish step failed on a legitimately stale formula"
[[ "$(remote_version)" == "$version" ]] \
  || fail "publish step left a stale formula published"

seed_remote preview-2026-08-22
publish_status=0
publish_step || publish_status=$?
[[ "$publish_status" -ne 0 ]] \
  || fail "publish step accepted a formula whose version it cannot read"
[[ "$(remote_version)" == "preview-2026-08-22" ]] \
  || fail "publish step clobbered a formula whose version it cannot read"

# A published formula that exists but carries no readable version is not an absent
# formula. Treating it as absent overwrites whatever a human or another writer put
# there, which is the one thing this job must never do.
seed_remote_file() {
  local src="${1:?formula required}"
  "$XFX_REAL_GIT" -C "$other" fetch -q origin master
  "$XFX_REAL_GIT" -C "$other" reset -q --hard FETCH_HEAD
  cp "$src" "$other/Formula/xfx-preview.rb"
  "$XFX_REAL_GIT" -C "$other" add -A
  "$XFX_REAL_GIT" -C "$other" -c user.email=seed@example.invalid -c user.name=seed \
    commit -qm "seed published formula" --allow-empty
  "$XFX_REAL_GIT" -C "$other" push -q origin HEAD:master
}
published_digest() {
  remote_formula | shasum -a 256 | awk '{print $1}'
}

sed '/^  version "/d' "$work/xfx-preview.rb" >"$work/no-version.rb"
awk '{ print; if ($0 ~ /^  version "/) print }' "$work/xfx-preview.rb" >"$work/two-versions.rb"

for broken in no-version two-versions; do
  seed_remote_file "$work/$broken.rb"
  before_digest="$(published_digest)"
  publish_status=0
  publish_step || publish_status=$?
  [[ "$publish_status" -ne 0 ]] \
    || fail "publish step accepted a published formula with a $broken problem"
  [[ "$(published_digest)" == "$before_digest" ]] \
    || fail "publish step rewrote a published formula with a $broken problem"
done

# The final release re-read must not be fooled by well-formed output followed by
# junk: reading only the first document sees exactly the expected object.
for trailer in \
  '{"tagName":"decoy","isPrerelease":true} and then junk' \
  '{"tagName":"decoy","isPrerelease":true}'; do
  seed_remote 2000.01.01.000000.1.1
  export XFX_STUB_VIEW_TRAILER="$trailer"
  publish_status=0
  publish_step || publish_status=$?
  unset XFX_STUB_VIEW_TRAILER
  [[ "$publish_status" -ne 0 ]] \
    || fail "publish step accepted a release re-read carrying extra bytes: $trailer"
  [[ "$(remote_version)" == "2000.01.01.000000.1.1" ]] \
    || fail "publish step published from a release re-read it could not fully validate"
done

# A workspace left dirty by an earlier attempt, or by a reused self-hosted runner,
# must not be read back as published state. The leftover has to be genuinely
# untracked to test this: a tracked modification is undone by the hard reset, so
# only an untracked file reaches the freshness check.
seed_remote none
"$XFX_REAL_GIT" -C "$repo" fetch -q origin master
"$XFX_REAL_GIT" -C "$repo" reset -q --hard FETCH_HEAD
sed 's/^  version ".*"$/  version "2999.01.01.000000.1.1"/' "$work/xfx-preview.rb" \
  >"$repo/Formula/xfx-preview.rb"
"$XFX_REAL_GIT" -C "$repo" status --porcelain Formula/xfx-preview.rb \
  | grep -q '^??' \
  || fail "the dirty-workspace case did not leave an untracked render behind"
publish_status=0
publish_step || publish_status=$?
[[ "$publish_status" -eq 0 ]] \
  || fail "publish step failed on a workspace holding an untracked render"
[[ "$(remote_version)" == "$version" ]] \
  || fail "publish step read an untracked leftover render as the published formula"

# ------------------------------------------------------ concurrent writers ---

# An unrelated concurrent commit must cost a retry, not the bump: the step has to
# re-read master, re-render on top of it, and keep the other writer's change.
seed_remote 2000.01.01.000000.1.1
XFX_RACE_KIND=unrelated
XFX_RACE_PUSHES=1
publish_status=0
publish_step || publish_status=$?
XFX_RACE_PUSHES=0
[[ "$publish_status" -eq 0 ]] \
  || fail "publish step gave up after one rejected push: $(cat "$work/render.out")"
[[ "$(push_attempts)" -eq 2 ]] \
  || fail "publish step made $(push_attempts) push attempts, expected 2 (one rejected, one accepted)"
[[ "$(remote_version)" == "$version" ]] \
  || fail "publish step did not republish after losing the race"
"$XFX_REAL_GIT" -C "$remote" show master:README.md | grep -Fq "concurrent unrelated write 1" \
  || fail "publish step discarded the concurrent writer's unrelated commit"

# If the writer that won the race published a NEWER formula, the retry must see it
# and stand down rather than overwrite it.
seed_remote 2000.01.01.000000.1.1
XFX_RACE_KIND=newer
XFX_RACE_PUSHES=1
publish_status=0
publish_step || publish_status=$?
XFX_RACE_PUSHES=0
XFX_RACE_KIND=unrelated
[[ "$publish_status" -eq 0 ]] \
  || fail "publish step failed instead of standing down for a newer concurrent formula"
[[ "$(remote_version)" == "2999.01.01.000000.1.1" ]] \
  || fail "publish step overwrote a newer formula published by the winning writer"

# A concurrent writer that published something unreadable must fail the job
# closed, not be clobbered.
seed_remote 2000.01.01.000000.1.1
XFX_RACE_KIND=unreadable
XFX_RACE_PUSHES=1
publish_status=0
publish_step || publish_status=$?
XFX_RACE_PUSHES=0
XFX_RACE_KIND=unrelated
[[ "$publish_status" -ne 0 ]] \
  || fail "publish step accepted an unreadable formula published by the winning writer"
[[ "$(remote_version)" == "preview-2026-08-22" ]] \
  || fail "publish step clobbered the winning writer's unreadable formula"

# A tap under permanent contention must fail loudly after a bounded number of
# attempts rather than spin or report success.
seed_remote 2000.01.01.000000.1.1
XFX_RACE_KIND=unrelated
XFX_RACE_PUSHES=9
publish_status=0
publish_step || publish_status=$?
XFX_RACE_PUSHES=0
[[ "$publish_status" -ne 0 ]] \
  || fail "publish step reported success while every push was rejected"
[[ "$(push_attempts)" -eq 3 ]] \
  || fail "publish step made $(push_attempts) push attempts under permanent contention, expected 3"
[[ "$(remote_version)" == "2000.01.01.000000.1.1" ]] \
  || fail "publish step published $version despite never winning a push"

# A published SHA256SUMS that does not describe exactly the four contract assets,
# or that disagrees with the bytes it names, must stop the job before the formula
# is rewritten.
mkdir -p "$work/assets-extra" "$work/assets-missing" "$work/assets-tampered"
cp "$assets"/xfx-* "$work/assets-extra/"
printf 'an asset the contract does not allow\n' >"$work/assets-extra/xfx-macos-arm64e"
(
  cd "$work/assets-extra"
  shasum -a 256 xfx-macos-aarch64 xfx-macos-x86_64 xfx-linux-aarch64 xfx-linux-x86_64 \
    xfx-macos-arm64e >SHA256SUMS
)
cp "$assets"/xfx-* "$work/assets-missing/"
# Three correct entries: `sha256sum --check` alone is happy, only the entry-set
# pin can catch this one.
(
  cd "$work/assets-missing"
  shasum -a 256 xfx-macos-aarch64 xfx-macos-x86_64 xfx-linux-aarch64 >SHA256SUMS
)
cp "$assets"/xfx-* "$work/assets-tampered/"
(
  cd "$work/assets-tampered"
  shasum -a 256 xfx-macos-aarch64 xfx-macos-x86_64 xfx-linux-aarch64 xfx-linux-x86_64 >SHA256SUMS
)
printf 'swapped payload the published sum does not cover\n' \
  >"$work/assets-tampered/xfx-linux-x86_64"

sums_case() {
  local variant="$1" why="$2" status=0
  seed_remote 2000.01.01.000000.1.1
  publish_step "$work/$variant" || status=$?
  [[ "$status" -ne 0 ]] || fail "publish step accepted $why"
  [[ "$(remote_version)" == "2000.01.01.000000.1.1" ]] \
    || fail "publish step published a formula from $why"
}
sums_case assets-extra "a SHA256SUMS carrying an asset outside the contract"
sums_case assets-missing "a SHA256SUMS that omits a contract asset"
sums_case assets-tampered "assets whose bytes disagree with the published SHA256SUMS"

# The direct re-read of the chosen release is the last chance to notice that it
# stopped being a prerelease after it was listed.
jq '[.[] | if .tagName == $tag then .isPrerelease = false else . end]' \
  --arg tag "$tag" "$work/releases-mixed.json" >"$work/releases-demoted.json"
seed_remote 2000.01.01.000000.1.1
publish_status=0
publish_step "$assets" "$work/releases-demoted.json" || publish_status=$?
[[ "$publish_status" -ne 0 ]] \
  || fail "publish step pinned a release that is no longer a prerelease"
[[ "$(remote_version)" == "2000.01.01.000000.1.1" ]] \
  || fail "publish step published a release that is no longer a prerelease"

formula="$work/xfx-preview.rb"

ruby -c "$formula" >/dev/null || fail "rendered formula is not valid Ruby"
if grep -q '@[A-Z0-9_]*@' "$formula"; then
  fail "rendered formula still carries placeholders"
fi
grep -Fq "# source: $source_sha" "$formula" \
  || fail "rendered formula does not record the exact source commit"
grep -Fq "# tag: $tag" "$formula" \
  || fail "rendered formula does not record the exact immutable tag"

# A tracked rendered formula, once the source repository has pushed one, must be
# just as complete as anything this test renders.
if [[ -f "$rendered" ]]; then
  ruby -c "$rendered" >/dev/null || fail "tracked Formula/xfx-preview.rb is not valid Ruby"
  if grep -q '@[A-Z0-9_]*@' "$rendered"; then
    fail "tracked Formula/xfx-preview.rb carries unrendered placeholders"
  fi
fi

# ------------------------------------------------------ stubbed formula test --

log="$work/invocations.log"
: >"$log"
make_stub() {
  local dir="$work/$1" channel="$2" revision="$3"
  mkdir -p "$dir"
  cat >"$dir/xfx" <<STUB
#!/bin/sh
printf '%s\n' "\$*" >>'$log'
case "\$*" in
  'status --json')
    printf '{"version":"0.1.0","build_channel":"$channel","build_revision":"$revision"}\n'
    ;;
  '--version')
    # The Cargo version is identical on every channel; it cannot prove preview.
    printf '0.1.0\n'
    ;;
  *)
    echo "unexpected xfx invocation: \$*" >&2
    exit 2
    ;;
esac
STUB
  chmod 0755 "$dir/xfx"
}
make_stub bin-preview preview "$source_sha12"
make_stub bin-release release "$source_sha12"
make_stub bin-other preview ffffffffffff

install_dir="$work/install"
mkdir -p "$install_dir"
cp "$assets/xfx-macos-aarch64" "$install_dir/xfx-macos-aarch64"

XFX_FORMULA="$formula" \
XFX_TAG="$tag" \
XFX_VERSION="$version" \
XFX_SUMS="$assets/SHA256SUMS" \
XFX_INSTALL_DIR="$install_dir" \
XFX_BIN_PREVIEW="$work/bin-preview" \
XFX_BIN_RELEASE="$work/bin-release" \
XFX_BIN_OTHER="$work/bin-other" \
XFX_LOG="$log" \
  ruby - <<'RUBY'
require "json"
require "pathname"

def check(condition, message)
  raise "xfx preview tap contract: #{message}" unless condition
end

# Minimal stand-in for Homebrew's Formula DSL: enough to record the declared
# identity and to run the formula's own `test do` block against a stub binary.
class FormulaHarness
  class << self
    attr_reader :declared, :urls, :checksums, :links, :test_block

    def inherited(subclass)
      super
      subclass.instance_variable_set(:@declared, {})
      subclass.instance_variable_set(:@urls, {})
      subclass.instance_variable_set(:@checksums, {})
      subclass.instance_variable_set(:@links, [])
    end

    def desc(value)
      @declared[:desc] = value
    end

    def homepage(value)
      @declared[:homepage] = value
    end

    def version(value)
      @declared[:version] = value
    end

    def license(value)
      @declared[:license] = value
    end

    def link_overwrite(*values)
      @links.concat(values)
    end

    def depends_on(*); end

    def conflicts_with(*); end

    def on_macos(&block)
      platform("macos", &block)
    end

    def on_linux(&block)
      platform("linux", &block)
    end

    def on_arm(&block)
      architecture("aarch64", &block)
    end

    def on_intel(&block)
      architecture("x86_64", &block)
    end

    def url(value)
      @urls[slot] = value
    end

    def sha256(value)
      @checksums[slot] = value
    end

    def test(&block)
      @test_block = block
    end

    private

    def platform(name)
      @platform = name
      yield
      @platform = nil
    end

    def architecture(name)
      @architecture = name
      yield
      @architecture = nil
    end

    def slot
      "#{@platform}-#{@architecture}"
    end
  end

  attr_accessor :bin
end

class BinRecorder
  attr_reader :installed

  def initialize
    @installed = []
  end

  def install(mapping)
    @installed << mapping
  end
end

class TestRunner
  class Failure < StandardError; end

  attr_reader :bin

  def initialize(bin_dir)
    @bin = Pathname.new(bin_dir)
  end

  def shell_output(command, expected_status = 0)
    output = `#{command}`
    status = $?.exitstatus
    raise Failure, "#{command} exited #{status}" unless status == expected_status

    output
  end

  def assert(value, _message = nil)
    raise Failure, "assert failed" unless value
  end

  def assert_equal(expected, actual, _message = nil)
    return if expected == actual

    raise Failure, "expected #{expected.inspect}, got #{actual.inspect}"
  end

  def assert_match(pattern, actual, _message = nil)
    matched = pattern.is_a?(Regexp) ? pattern.match?(actual.to_s) : actual.to_s.include?(pattern)
    raise Failure, "#{pattern.inspect} not found in #{actual.inspect}" unless matched
  end

  def assert_predicate(object, predicate, _message = nil)
    raise Failure, "#{object.inspect} is not #{predicate}" unless object.public_send(predicate)
  end
end

Formula = FormulaHarness
load ENV.fetch("XFX_FORMULA")

check(Object.const_defined?(:XfxPreview), "formula does not define class XfxPreview")
formula = Object.const_get(:XfxPreview)

tag = ENV.fetch("XFX_TAG")
check(formula.declared[:version] == ENV.fetch("XFX_VERSION"), "rendered version is wrong")
check(formula.declared[:homepage] == "https://github.com/2lab-ai/xfx", "homepage is not the canonical xfx repository")
check(formula.declared[:license] == "Apache-2.0", "license is not Apache-2.0")
check(!formula.declared[:desc].to_s.empty?, "formula has no desc")
check(formula.links == ["bin/xfx"], "formula does not link_overwrite bin/xfx")

expected_urls = {}
expected_checksums = {}
File.readlines(ENV.fetch("XFX_SUMS")).each do |line|
  digest, name = line.split
  name = name.sub(/\A\*/, "")
  slot = name.sub(/\Axfx-/, "")
  expected_urls[slot] = "https://github.com/2lab-ai/xfx/releases/download/#{tag}/#{name}"
  expected_checksums[slot] = digest
end
check(expected_urls.keys.sort == %w[linux-aarch64 linux-x86_64 macos-aarch64 macos-x86_64],
      "the fabricated asset set is wrong")
check(formula.urls == expected_urls,
      "formula URLs are #{formula.urls.inspect}, expected #{expected_urls.inspect}")
check(formula.checksums == expected_checksums,
      "formula checksums do not match the published SHA256SUMS")

instance = formula.allocate
instance.bin = BinRecorder.new
Dir.chdir(ENV.fetch("XFX_INSTALL_DIR")) { instance.install }
check(instance.bin.installed == [{ "xfx-macos-aarch64" => "xfx" }],
      "install does not expose the selected asset as a single `xfx` executable")

check(!formula.test_block.nil?, "formula has no test block")
begin
  TestRunner.new(ENV.fetch("XFX_BIN_PREVIEW")).instance_exec(&formula.test_block)
rescue StandardError => error
  raise "xfx preview tap contract: formula test rejects a conforming preview build: #{error.message}"
end

{
  "build_channel" => ENV.fetch("XFX_BIN_RELEASE"),
  "build_revision" => ENV.fetch("XFX_BIN_OTHER"),
}.each do |field, bin_dir|
  rejected = false
  begin
    TestRunner.new(bin_dir).instance_exec(&formula.test_block)
  rescue TestRunner::Failure, JSON::ParserError
    rejected = true
  end
  check(rejected, "formula test accepts a build with the wrong #{field}")
end

invocations = File.readlines(ENV.fetch("XFX_LOG")).map(&:strip)
check(invocations.include?("status --json"),
      "formula test never runs `xfx status --json`, so it cannot prove the preview channel")
RUBY

echo "xfx preview tap contract: ok"
