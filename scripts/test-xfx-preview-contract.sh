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
check(runs.include?(%q{[[ "$(jq -r '.tagName' <<<"$release")" == "$TAG" ]]}),
      "job does not reconfirm that the re-read release is the tag it selected")
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
check(runs.include?("git pull --rebase") && runs.include?("git push"),
      "job does not rebase and push the bump")

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
awk '/^select_preview_release\(\) \{$/, /^\}$/' "$work/xfx-job.sh" >"$work/select.sh"
[[ -s "$work/select.sh" ]] \
  || fail "the shipped select_preview_release() function could not be extracted"
# shellcheck source=/dev/null
source "$work/select.sh"

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
        cat "$XFX_STUB_RELEASES"
        ;;
      view)
        # A separate view fixture lets a test model a release that was edited
        # between the listing and the direct re-read.
        jq -c --arg tag "$target" \
          '[.[] | select(.tagName == $tag)] | first | {tagName, isPrerelease}' \
          "${XFX_STUB_VIEW:-$XFX_STUB_RELEASES}"
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
    ref="$XFX_STUB_REFS/${action##*/}.json"
    if [ -f "$ref" ]; then cat "$ref"; else echo "gh: 404 $action" >&2; exit 1; fi
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
# Every remaining candidate is invalid, and each carries a later stamp than the
# winner so a naive "newest wins" selector would take it.
malformed_tag="preview-2026-08-24-0900-32700000000-1-cccccccccccc"
unreleased_tag="preview-2026-08-25-000000-32800000000-1-dddddddddddd"
missing_ref_tag="preview-2026-08-26-000000-32900000000-1-eeeeeeeeeeee"
sha_mismatch_tag="preview-2026-08-27-000000-33000000000-1-ffffffffffff"
annotated_tag="preview-2026-08-28-000000-33100000000-1-111111111111"

ref_json "$tag" commit "$source_sha"
ref_json "$decoy_tag" commit "aaaaaaaaaaaabcdef0123456789abcdef0123456"
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

repo="$work/repo"
mkdir -p "$repo/Formula"
cp "$template" "$repo/Formula/xfx-preview.rb.tmpl"

render_step() {
  local assets_dir="${1:-$assets}"
  local view_fixture="${2:-$work/releases-mixed.json}"
  rm -f "$work/render.out"
  (
    cd "$repo"
    hash -r
    XFX_STUB_RELEASES="$work/releases-mixed.json" \
    XFX_STUB_VIEW="$view_fixture" \
    XFX_STUB_ASSETS="$assets_dir" \
    PATH="$stub_bin:$PATH" \
      bash "$work/render-step.sh"
  ) >"$work/render.out" 2>&1
}

render_status=0
render_step || render_status=$?
[[ "$render_status" -eq 0 ]] \
  || fail "render step failed on a valid release: $(cat "$work/render.out")"

formula="$repo/Formula/xfx-preview.rb"
[[ -f "$formula" ]] || fail "render step produced no Formula/xfx-preview.rb"

# The step must render the *selected* build, not whichever release came last.
grep -Fq "version \"$version\"" "$formula" \
  || fail "render step pinned the wrong version: $(sed -n 's/^  version "\(.*\)"$/\1/p' "$formula")"
for asset in xfx-macos-aarch64 xfx-macos-x86_64 xfx-linux-aarch64 xfx-linux-x86_64; do
  grep -Fq "releases/download/$tag/$asset" "$formula" \
    || fail "render step did not pin the exact-tag URL for $asset"
  grep -Fq "sha256 \"$(sha_of "$asset")\"" "$formula" \
    || fail "render step did not pin the published checksum for $asset"
done
# Keep this good render for the formula-level assertions further down; the
# freshness cases below deliberately leave the repository copy in other states.
cp "$formula" "$work/xfx-preview.rb"

# Freshness, through the caller rather than the helper: a newer formula must
# survive untouched, an older one must be replaced, an unreadable one must stop
# the job instead of being clobbered.
fresher="$work/fresher.rb"
sed 's/^  version ".*"$/  version "2999.01.01.000000.1.1"/' "$formula" >"$fresher"
cp "$fresher" "$repo/Formula/xfx-preview.rb"
render_status=0
render_step || render_status=$?
[[ "$render_status" -eq 0 ]] \
  || fail "render step failed instead of no-opping on an already-newer formula"
cmp -s "$fresher" "$repo/Formula/xfx-preview.rb" \
  || fail "render step downgraded a newer formula to $version"
grep -Fq "refusing to replace" "$work/render.out" \
  || fail "render step replaced a newer formula without saying so"

sed 's/^  version ".*"$/  version "2000.01.01.000000.1.1"/' "$formula" >"$repo/Formula/xfx-preview.rb"
render_status=0
render_step || render_status=$?
[[ "$render_status" -eq 0 ]] \
  || fail "render step failed on a legitimately stale formula"
grep -Fq "version \"$version\"" "$repo/Formula/xfx-preview.rb" \
  || fail "render step left a stale formula in place"

sed 's/^  version ".*"$/  version "preview-2026-08-22"/' "$formula" >"$work/unreadable.rb"
cp "$work/unreadable.rb" "$repo/Formula/xfx-preview.rb"
render_status=0
render_step || render_status=$?
[[ "$render_status" -ne 0 ]] \
  || fail "render step accepted a formula whose version it cannot read"
cmp -s "$work/unreadable.rb" "$repo/Formula/xfx-preview.rb" \
  || fail "render step clobbered a formula whose version it cannot read"

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
  sed 's/^  version ".*"$/  version "2000.01.01.000000.1.1"/' "$work/xfx-preview.rb" \
    >"$repo/Formula/xfx-preview.rb"
  cp "$repo/Formula/xfx-preview.rb" "$work/stale-seed.rb"
  render_step "$work/$variant" || status=$?
  [[ "$status" -ne 0 ]] || fail "render step accepted $why"
  cmp -s "$work/stale-seed.rb" "$repo/Formula/xfx-preview.rb" \
    || fail "render step rewrote the formula from $why"
}
sums_case assets-extra "a SHA256SUMS carrying an asset outside the contract"
sums_case assets-missing "a SHA256SUMS that omits a contract asset"
sums_case assets-tampered "assets whose bytes disagree with the published SHA256SUMS"

# The direct re-read of the chosen release is the last chance to notice that it
# stopped being a prerelease after it was listed.
jq '[.[] | if .tagName == $tag then .isPrerelease = false else . end]' \
  --arg tag "$tag" "$work/releases-mixed.json" >"$work/releases-demoted.json"
sed 's/^  version ".*"$/  version "2000.01.01.000000.1.1"/' "$work/xfx-preview.rb" \
  >"$repo/Formula/xfx-preview.rb"
cp "$repo/Formula/xfx-preview.rb" "$work/stale-seed.rb"
render_status=0
render_step "$assets" "$work/releases-demoted.json" || render_status=$?
[[ "$render_status" -ne 0 ]] \
  || fail "render step pinned a release that is no longer a prerelease"
cmp -s "$work/stale-seed.rb" "$repo/Formula/xfx-preview.rb" \
  || fail "render step rewrote the formula from a release that is no longer a prerelease"

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
