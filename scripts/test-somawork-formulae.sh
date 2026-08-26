#!/usr/bin/env bash
#
# somawork tap contract — the renderer, the three templates, and the formulae
# they produce.
#
# Two fixtures, both produced by soma-work's own
# `scripts/release/render-manifest.ts` rather than written by hand, so this suite
# fails if the producer's document shape moves away from what the tap parses:
# one preview-channel release and one stable-channel release.
#
# The load-bearing property here is that a release announces a channel and the
# channel selects exactly one runtime. A preview manifest describes a
# production-profile archive too, but those are preview-channel bits wearing the
# production marker; rendering them as `Formula/somawork.rb` would publish
# unreleased code behind the stable gate. So: preview writes `somawork-cli` and
# `somawork-preview`, stable writes `somawork-cli` and `somawork`, and neither
# can so much as create the other's file.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
preview_fixture="$root/tests/fixtures/somawork-preview-manifest.json"
stable_fixture="$root/tests/fixtures/somawork-stable-manifest.json"
renderer="$root/scripts/render-somawork-formulae.py"
controller_template="$root/Formula/somawork-cli.rb.tmpl"
production_template="$root/Formula/somawork.rb.tmpl"
preview_template="$root/Formula/somawork-preview.rb.tmpl"

PREVIEW_TAG=somawork-preview-v0.1.0-987654321
PREVIEW_SOURCE_SHA=0123456789abcdef0123456789abcdef01234567
PREVIEW_BASE=https://github.com/2lab-ai/soma-work/releases/download/$PREVIEW_TAG
PREVIEW_MANIFEST_URL="$PREVIEW_BASE/somawork-manifest.json"
PREVIEW_FORMULA_VERSION=0.1.0.987654321

STABLE_TAG=somawork-v0.1.0-987654322
STABLE_SOURCE_SHA=89abcdef0123456789abcdef0123456789abcdef
STABLE_BASE=https://github.com/2lab-ai/soma-work/releases/download/$STABLE_TAG
STABLE_MANIFEST_URL="$STABLE_BASE/somawork-manifest.json"
STABLE_FORMULA_VERSION=0.1.0.987654322

PACKAGE_VERSION=0.1.0

fail() {
  echo "somawork tap contract: $*" >&2
  exit 1
}

[[ -x "$renderer" ]] || fail "tracked executable renderer is missing"
[[ -f "$preview_fixture" ]] || fail "producer-rendered preview manifest fixture is missing"
[[ -f "$stable_fixture" ]] || fail "producer-rendered stable manifest fixture is missing"
for template in "$controller_template" "$production_template" "$preview_template"; do
  [[ -f "$template" ]] || fail "formula template is missing: $template"
done

preview_sha256="$(shasum -a 256 "$preview_fixture" | awk '{print $1}')"
stable_sha256="$(shasum -a 256 "$stable_fixture" | awk '{print $1}')"
work="$(mktemp -d "${TMPDIR:-/tmp}/somawork-tap-contract.XXXXXX")"
trap 'rm -rf "$work"' EXIT HUP INT TERM
out="$work/Formula"
mkdir -p "$out"

controller="$out/somawork-cli.rb"
production="$out/somawork.rb"
preview="$out/somawork-preview.rb"

render_preview() {
  "$renderer" \
    --tag "$PREVIEW_TAG" \
    --package somawork-preview \
    --source-repository 2lab-ai/soma-work \
    --source-sha "$PREVIEW_SOURCE_SHA" \
    --manifest-url "$PREVIEW_MANIFEST_URL" \
    --manifest-sha256 "$preview_sha256" \
    --manifest "$preview_fixture" \
    --controller-template "$controller_template" \
    --controller-output "$controller" \
    --runtime-template "$preview_template" \
    --runtime-output "$preview" \
    "$@"
}

render_stable() {
  "$renderer" \
    --tag "$STABLE_TAG" \
    --package somawork \
    --source-repository 2lab-ai/soma-work \
    --source-sha "$STABLE_SOURCE_SHA" \
    --manifest-url "$STABLE_MANIFEST_URL" \
    --manifest-sha256 "$stable_sha256" \
    --manifest "$stable_fixture" \
    --controller-template "$controller_template" \
    --controller-output "$controller" \
    --runtime-template "$production_template" \
    --runtime-output "$production" \
    "$@"
}

# A rejection helper: the renderer must fail, for the stated reason, and leave no
# output behind.
#
# The reason is not decoration. Most of these inputs are refused by more than one
# check, so a helper that asserted only the exit status would let a check be
# deleted and the refusal silently move somewhere else — which is exactly how the
# dispatch-package/channel bind ended up untested despite a case that looked like
# it covered it. Asserting the message pins each case to the check it is for.
reject() {
  local label="${1:?label required}"
  local because="${2:?expected reason required}"
  shift 2
  rm -f "$controller" "$production" "$preview"
  if "$@" >/dev/null 2>"$work/reject.err"; then
    fail "renderer accepted $label"
  fi
  grep -Fq "$because" "$work/reject.err" \
    || fail "renderer rejected $label for the wrong reason: $(cat "$work/reject.err")"
  for stray in "$controller" "$production" "$preview"; do
    [[ -e "$stray" ]] && fail "renderer left a partial output after rejecting $label: $stray"
  done
  return 0
}

# Every formula this renderer writes declares soma-work's license, exactly once
# and exactly as ISC. `license` is fixed project metadata in the templates, not
# a manifest field, so this is a whole-line single-occurrence match rather than
# a substring search: a second line, a different SPDX id, or a line commented
# out all have to be caught. It returns rather than fails because the mutation
# cases below require it to reject.
declares_isc_license() {
  local formula="${1:?formula required}"
  [[ "$(grep -c '^[[:space:]]*license ' "$formula")" == 1 ]] || return 1
  grep -Fqx '  license "ISC"' "$formula" || return 1
  return 0
}

# ---------------------------------------------------------------------------
# Channel selectivity — the ruling this suite exists to enforce
# ---------------------------------------------------------------------------

rm -f "$controller" "$production" "$preview"
render_preview
[[ -f "$controller" ]] || fail "a preview dispatch did not render the controller"
[[ -f "$preview" ]] || fail "a preview dispatch did not render the preview runtime"
[[ -e "$production" ]] && fail "a preview dispatch created the stable formula"

# And it does not touch one that is already there.
guard="stable formula written by an earlier stable release"
printf '%s\n' "$guard" >"$production"
production_before="$(shasum -a 256 "$production" | awk '{print $1}')"
render_preview
[[ "$(shasum -a 256 "$production" | awk '{print $1}')" == "$production_before" ]] \
  || fail "a preview dispatch rewrote the stable formula"
rm -f "$production"

rm -f "$controller" "$preview"
render_stable
[[ -f "$controller" ]] || fail "a stable dispatch did not render the controller"
[[ -f "$production" ]] || fail "a stable dispatch did not render the production runtime"
[[ -e "$preview" ]] && fail "a stable dispatch created the preview formula"

printf 'preview formula written by an earlier preview release\n' >"$preview"
preview_before="$(shasum -a 256 "$preview" | awk '{print $1}')"
render_stable
[[ "$(shasum -a 256 "$preview" | awk '{print $1}')" == "$preview_before" ]] \
  || fail "a stable dispatch rewrote the preview formula"
rm -f "$preview" "$production"

# The dangerous direction, tested head-on: a genuine preview release — real
# preview manifest, real preview tag, real preview assets — dispatched as the
# stable package, with the stable template and the stable output path, so every
# path binding is satisfied and only the package/channel bind stands between it
# and `Formula/somawork.rb`. Without that bind this renders preview-channel bits
# under `# channel: preview` behind the stable gate, which is the single outcome
# the whole channel ruling exists to prevent.
reject "a real preview release dispatched as the stable package" \
  "dispatch package does not match the manifest channel" \
  "$renderer" \
  --tag "$PREVIEW_TAG" --package somawork --source-repository 2lab-ai/soma-work \
  --source-sha "$PREVIEW_SOURCE_SHA" --manifest-url "$PREVIEW_MANIFEST_URL" \
  --manifest-sha256 "$preview_sha256" --manifest "$preview_fixture" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$production_template" --runtime-output "$production"

# And the mirror: a genuine stable release dispatched as the preview package.
# Less dangerous — stable bits are the ones already gated — but the bind is one
# check and both directions run through it.
reject "a real stable release dispatched as the preview package" \
  "dispatch package does not match the manifest channel" \
  "$renderer" \
  --tag "$STABLE_TAG" --package somawork-preview --source-repository 2lab-ai/soma-work \
  --source-sha "$STABLE_SOURCE_SHA" --manifest-url "$STABLE_MANIFEST_URL" \
  --manifest-sha256 "$stable_sha256" --manifest "$stable_fixture" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$preview_template" --runtime-output "$preview"

# The channel cannot be aimed at the other channel's file even by hand.
reject "a preview dispatch aimed at the stable formula" "runtime output does not belong to the dispatched channel" "$renderer" \
  --tag "$PREVIEW_TAG" --package somawork-preview --source-repository 2lab-ai/soma-work \
  --source-sha "$PREVIEW_SOURCE_SHA" --manifest-url "$PREVIEW_MANIFEST_URL" \
  --manifest-sha256 "$preview_sha256" --manifest "$preview_fixture" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$preview_template" --runtime-output "$production"

reject "a preview dispatch handed the stable template" "runtime template does not belong to the dispatched channel" "$renderer" \
  --tag "$PREVIEW_TAG" --package somawork-preview --source-repository 2lab-ai/soma-work \
  --source-sha "$PREVIEW_SOURCE_SHA" --manifest-url "$PREVIEW_MANIFEST_URL" \
  --manifest-sha256 "$preview_sha256" --manifest "$preview_fixture" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$production_template" --runtime-output "$preview"

reject "a stable dispatch aimed at the preview formula" "runtime template does not belong to the dispatched channel" "$renderer" \
  --tag "$STABLE_TAG" --package somawork --source-repository 2lab-ai/soma-work \
  --source-sha "$STABLE_SOURCE_SHA" --manifest-url "$STABLE_MANIFEST_URL" \
  --manifest-sha256 "$stable_sha256" --manifest "$stable_fixture" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$preview_template" --runtime-output "$preview"

reject "a runtime aimed at the controller's own formula" "runtime output does not belong to the dispatched channel" "$renderer" \
  --tag "$PREVIEW_TAG" --package somawork-preview --source-repository 2lab-ai/soma-work \
  --source-sha "$PREVIEW_SOURCE_SHA" --manifest-url "$PREVIEW_MANIFEST_URL" \
  --manifest-sha256 "$preview_sha256" --manifest "$preview_fixture" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$preview_template" --runtime-output "$controller"

# ---------------------------------------------------------------------------
# The rendered pair
# ---------------------------------------------------------------------------

rm -f "$controller" "$production" "$preview"
render_preview

for formula in "$controller" "$preview"; do
  ruby -c "$formula" >/dev/null || fail "rendered formula is not valid Ruby: $formula"
  grep -Fq "# tag: $PREVIEW_TAG" "$formula" || fail "immutable tag is not recorded in $formula"
  grep -Fq "# source: $PREVIEW_SOURCE_SHA" "$formula" || fail "source commit is not recorded in $formula"
  grep -Fq "# manifest-sha256: $preview_sha256" "$formula" \
    || fail "manifest digest is not recorded in $formula"
  grep -Fq "# manifest: $PREVIEW_MANIFEST_URL" "$formula" || fail "manifest URL is not recorded in $formula"
  grep -Fq "# package-version: $PACKAGE_VERSION" "$formula" \
    || fail "release package version is not recorded in $formula"
  grep -Fq "# channel: preview" "$formula" || fail "release channel is not recorded in $formula"
  declares_isc_license "$formula" \
    || fail "formula does not declare exactly one ISC license: $formula"
  grep -Eq '^[[:space:]]*service do' "$formula" && fail "formula installs a service: $formula"
  grep -Eq '^[[:space:]]*def post_install' "$formula" && fail "formula runs post_install: $formula"
  grep -Eq '(^|[^_[:alnum:]])(var|etc)/' "$formula" && fail "formula reaches into var/ or etc/: $formula"
  grep -Eq '\.(write|append|mkpath|mkdir)\b' "$formula" && fail "formula writes mutable state: $formula"
  grep -Fq 'https://github.com/2lab-ai/soma-work' "$formula" || fail "formula lost its homepage origin: $formula"
done

# Ruling 3: the controller and the selected runtime are one release, or the pair
# is meaningless. Every identity line must be the same in both files.
for line in "# tag: $PREVIEW_TAG" "# source: $PREVIEW_SOURCE_SHA" \
  "# manifest: $PREVIEW_MANIFEST_URL" "# manifest-sha256: $preview_sha256" \
  "# package-version: $PACKAGE_VERSION" "# channel: preview"; do
  grep -Fq "$line" "$controller" || fail "controller lost the shared identity line: $line"
  grep -Fq "$line" "$preview" || fail "selected runtime lost the shared identity line: $line"
done
[[ "$(grep -c '^  version "' "$controller")" == 1 ]] || fail "controller does not pin one version"
diff <(grep '^  version "' "$controller") <(grep '^  version "' "$preview") >/dev/null \
  || fail "the controller and its runtime disagree about the release version"

grep -Fq 'class SomaworkCli < Formula' "$controller" || fail "controller class name is wrong"
grep -Fq 'class SomaworkPreview < Formula' "$preview" || fail "preview class name is wrong"

# ---------------------------------------------------------------------------
# Monotonic preview versions
# ---------------------------------------------------------------------------

grep -Fq "version \"$PREVIEW_FORMULA_VERSION\"" "$controller" \
  || fail "controller does not carry the run-qualified preview version"
grep -Fq "version \"$PREVIEW_FORMULA_VERSION\"" "$preview" \
  || fail "preview runtime does not carry the run-qualified preview version"
# The package version is still what the payload actually contains, and the
# formula's own test block compares against that, not against the Homebrew
# version it no longer equals.
grep -Fq "assert_match \"$PACKAGE_VERSION\"" "$controller" \
  || fail "controller test asserts a version the payload does not report"
grep -Fq "assert_equal \"$PACKAGE_VERSION\", marker[\"version\"]" "$preview" \
  || fail "preview test asserts a marker version the payload does not carry"

# A later run of the same package version is strictly greater.
later="$work/later-manifest.json"
LATER_TAG=somawork-preview-v0.1.0-987654999
jq --arg tag "$LATER_TAG" \
  --arg base "https://github.com/2lab-ai/soma-work/releases/download/$LATER_TAG" '
    .tag = $tag | .baseUrl = $base
    | .assets = [.assets[] | .url = ($base + "/" + .filename)]' \
  "$preview_fixture" >"$later"
later_sha256="$(shasum -a 256 "$later" | awk '{print $1}')"
render_later() {
  "$renderer" --tag "$LATER_TAG" --package somawork-preview \
    --source-repository 2lab-ai/soma-work --source-sha "$PREVIEW_SOURCE_SHA" \
    --manifest-url "https://github.com/2lab-ai/soma-work/releases/download/$LATER_TAG/somawork-manifest.json" \
    --manifest-sha256 "$later_sha256" --manifest "$later" \
    --controller-template "$controller_template" --controller-output "$controller" \
    --runtime-template "$preview_template" --runtime-output "$preview" "$@"
}
render_later --not-below "$PREVIEW_FORMULA_VERSION"
grep -Fq 'version "0.1.0.987654999"' "$preview" \
  || fail "a later run id did not produce a later formula version"

# An earlier run id cannot be published over it, and the version alone carries
# that fact — the package version is identical in both manifests.
reject "a preview release whose run id went backwards" "rendered version is below an installed formula version" \
  render_preview --not-below 0.1.0.987654999

# The same release re-dispatched is allowed, and is byte-identical.
rm -f "$controller" "$preview"
render_preview --not-below "$PREVIEW_FORMULA_VERSION"
first="$work/first"
mkdir -p "$first"
cp "$controller" "$preview" "$first/"
render_preview --not-below "$PREVIEW_FORMULA_VERSION"
cmp -s "$first/somawork-cli.rb" "$controller" || fail "re-rendering the same release changed the controller"
cmp -s "$first/somawork-preview.rb" "$preview" || fail "re-rendering the same release changed the runtime"

# Equal versions cannot name two different releases: the run id is part of the
# version, so two tags that differ necessarily render versions that differ. That
# is what removes the "is this a no-op or a silent overwrite?" ambiguity — a
# repeat dispatch is byte-identical, and anything else moves the version.
this_release="$(grep '^  version "' "$first/somawork-preview.rb")"
rm -f "$controller" "$preview"
render_later
next_release="$(grep '^  version "' "$preview")"
[[ "$this_release" != "$next_release" ]] \
  || fail "two different preview releases rendered the same version"

# A preview tag that is not exactly version+run-id has no run id to trust.
# `tag:reason` — a tag that does not carry this version and a tag whose run id is
# not a positive decimal are two different refusals, and each case says which.
for bad_case in \
  "somawork-preview-v0.1.0:does not name the manifest version" \
  "somawork-preview-v0.1.0-:does not end in a positive decimal run id" \
  "somawork-preview-v0.1.0-0:does not end in a positive decimal run id" \
  "somawork-preview-v0.1.0-007:does not end in a positive decimal run id" \
  "somawork-preview-v0.1.0-1x:does not end in a positive decimal run id" \
  "somawork-preview-v0.2.0-1:does not name the manifest version" \
  "preview-0.1.0-1:does not name the manifest version"; do
  bad_tag="${bad_case%%:*}"
  bad_reason="preview tag ${bad_case#*:}"
  bad="$work/bad-tag-manifest.json"
  jq --arg tag "$bad_tag" \
    --arg base "https://github.com/2lab-ai/soma-work/releases/download/$bad_tag" '
      .tag = $tag | .baseUrl = $base
      | .assets = [.assets[] | .url = ($base + "/" + .filename)]' \
    "$preview_fixture" >"$bad"
  bad_sha256="$(shasum -a 256 "$bad" | awk '{print $1}')"
  reject "a preview tag that is not version and run id: $bad_tag" "$bad_reason" "$renderer" \
    --tag "$bad_tag" --package somawork-preview --source-repository 2lab-ai/soma-work \
    --source-sha "$PREVIEW_SOURCE_SHA" \
    --manifest-url "https://github.com/2lab-ai/soma-work/releases/download/$bad_tag/somawork-manifest.json" \
    --manifest-sha256 "$bad_sha256" --manifest "$bad" \
    --controller-template "$controller_template" --controller-output "$controller" \
    --runtime-template "$preview_template" --runtime-output "$preview"
done

# Stable composes its run id the same way, so the two channels' versions are
# comparable and the controller they share is ordered by one number.
rm -f "$controller" "$production" "$preview"
render_stable
grep -Fq "version \"$STABLE_FORMULA_VERSION\"" "$production" \
  || fail "stable does not compose its run id into the formula version"
grep -Fq "version \"$STABLE_FORMULA_VERSION\"" "$controller" \
  || fail "the stable controller does not compose its run id into the formula version"
grep -Fq "# package-version: $PACKAGE_VERSION" "$production" \
  || fail "stable does not record the package version the payload reports"
grep -Fq "assert_equal \"$PACKAGE_VERSION\", marker[\"version\"]" "$production" \
  || fail "stable test asserts a marker version the payload does not carry"
grep -Fq "# channel: stable" "$production" || fail "stable channel is not recorded"
render_stable --not-below 0.0.9
reject "a stable release below the installed formula" "rendered version is below an installed formula version" render_stable --not-below 0.2.0

# A stable tag that is not exactly version + run id has no run id to trust, and
# a preview tag is not a stable tag.
for bad_case in \
  "somawork-v0.1.0:does not name the manifest version" \
  "somawork-v0.1.0-:does not end in a positive decimal run id" \
  "somawork-v0.1.0-0:does not end in a positive decimal run id" \
  "somawork-v0.1.0-007:does not end in a positive decimal run id" \
  "somawork-v0.1.0-1x:does not end in a positive decimal run id" \
  "somawork-v0.2.0-1:does not name the manifest version" \
  "somawork-preview-v0.1.0-987654322:does not name the manifest version" \
  "v0.1.0-1:does not name the manifest version"; do
  bad_tag="${bad_case%%:*}"
  bad_reason="stable tag ${bad_case#*:}"
  bad="$work/bad-stable-tag.json"
  jq --arg tag "$bad_tag" \
    --arg base "https://github.com/2lab-ai/soma-work/releases/download/$bad_tag" '
      .tag = $tag | .baseUrl = $base
      | .assets = [.assets[] | .url = ($base + "/" + .filename)]' \
    "$stable_fixture" >"$bad"
  bad_sha256="$(shasum -a 256 "$bad" | awk '{print $1}')"
  reject "a stable tag that is not version and run id: $bad_tag" "$bad_reason" "$renderer" \
    --tag "$bad_tag" --package somawork --source-repository 2lab-ai/soma-work \
    --source-sha "$STABLE_SOURCE_SHA" \
    --manifest-url "https://github.com/2lab-ai/soma-work/releases/download/$bad_tag/somawork-manifest.json" \
    --manifest-sha256 "$bad_sha256" --manifest "$bad" \
    --controller-template "$controller_template" --controller-output "$controller" \
    --runtime-template "$production_template" --runtime-output "$production"
done

# ---------------------------------------------------------------------------
# The shared controller, ordered across channels
#
# `somawork-cli` is written by whichever channel bumped last. Both channels
# compose the same repository-wide GitHub run id, so whichever order they fire
# in, the controller only ever moves forward — and the write path proves it by
# passing the controller's own current version as a baseline alongside the
# runtime's.
# ---------------------------------------------------------------------------

controller_version() { sed -n 's/^  version "\(.*\)"$/\1/p' "$controller" | head -1; }
runtime_version() { sed -n 's/^  version "\(.*\)"$/\1/p' "$1" | head -1; }

# preview(987654321) → stable(987654322): the later stable release takes the
# controller, and does not have to pretend the preview bump never happened.
rm -f "$controller" "$production" "$preview"
render_preview
[[ "$(controller_version)" == "$PREVIEW_FORMULA_VERSION" ]] \
  || fail "the preview bump did not set the controller version"
render_stable --not-below "$(controller_version)"
[[ "$(controller_version)" == "$STABLE_FORMULA_VERSION" ]] \
  || fail "the later stable bump did not take the shared controller"
grep -Fq "# tag: $STABLE_TAG" "$controller" || fail "the controller did not follow the last bump"
grep -Fq "# tag: $PREVIEW_TAG" "$preview" || fail "the stable bump disturbed the preview formula"

# stable(987654322) → preview(987654999): the reverse order, same outcome.
render_later --not-below "$(controller_version)" --not-below "$(runtime_version "$preview")"
[[ "$(controller_version)" == "0.1.0.987654999" ]] \
  || fail "the later preview bump did not take the shared controller"
grep -Fq "# tag: $LATER_TAG" "$controller" || fail "the controller did not follow the last bump"
grep -Fq "# tag: $STABLE_TAG" "$production" || fail "the preview bump disturbed the stable formula"

# And a release older than the controller is refused even when its own channel's
# runtime formula would have accepted it. This is the case that only works
# because both channels compose the same run-id space.
reject "a release older than the shared controller" "rendered version is below an installed formula version" \
  render_stable --not-below 0.1.0.987654999 --not-below "$STABLE_FORMULA_VERSION"

# Downgrade protection is intrinsic, not a favour the caller does. With NO
# `--not-below` at all the renderer still refuses, because it reads the version
# out of each formula it is about to replace — including the controller, which is
# how a stable release older than the current preview is caught.
rm -f "$controller" "$production" "$preview"
render_later
[[ "$(controller_version)" == 0.1.0.987654999 ]] || fail "the later preview bump did not land"
refuse_in_place() {
  local label="${1:?label required}"
  shift
  local before_controller before_runtime runtime
  runtime="$1"; shift
  before_controller="$(shasum -a 256 "$controller" | awk '{print $1}')"
  before_runtime=""
  [[ -f "$runtime" ]] && before_runtime="$(shasum -a 256 "$runtime" | awk '{print $1}')"
  if "$@" >/dev/null 2>&1; then
    fail "renderer accepted $label"
  fi
  [[ "$(shasum -a 256 "$controller" | awk '{print $1}')" == "$before_controller" ]] \
    || fail "a refused render replaced the controller: $label"
  if [[ -n "$before_runtime" ]]; then
    [[ "$(shasum -a 256 "$runtime" | awk '{print $1}')" == "$before_runtime" ]] \
      || fail "a refused render replaced the runtime: $label"
  else
    [[ -e "$runtime" ]] && fail "a refused render created the runtime: $label"
  fi
  return 0
}

refuse_in_place "an older preview with no caller floor at all" "$preview" render_preview
refuse_in_place "an older stable with no caller floor at all" "$production" render_stable
# A caller floor may add, never subtract: a floor far below the on-disk version
# does not license the downgrade the on-disk version forbids.
refuse_in_place "an older preview under a permissive caller floor" "$preview" \
  render_preview --not-below 0.0.1
refuse_in_place "an older stable under a permissive caller floor" "$production" \
  render_stable --not-below 0.0.1
# And a caller floor above the on-disk version still binds.
refuse_in_place "a release below a stricter caller floor" "$preview" \
  render_later --not-below 0.9.9

# Equal version, different release: Homebrew would not call that an upgrade, so
# the tap must not serve bytes nobody can reach.
rm -f "$controller" "$production" "$preview"
render_preview
impostor="$work/impostor-manifest.json"
jq '.assets[2].sha256 = "'"$(printf 'd%.0s' {1..64})"'"' "$preview_fixture" >"$impostor"
impostor_sha256="$(shasum -a 256 "$impostor" | awk '{print $1}')"
preview_bytes="$(shasum -a 256 "$preview" | awk '{print $1}')"
if "$renderer" \
  --tag "$PREVIEW_TAG" --package somawork-preview --source-repository 2lab-ai/soma-work \
  --source-sha "$PREVIEW_SOURCE_SHA" --manifest-url "$PREVIEW_MANIFEST_URL" \
  --manifest-sha256 "$impostor_sha256" --manifest "$impostor" \
  --not-below "$PREVIEW_FORMULA_VERSION" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$preview_template" --runtime-output "$preview" >/dev/null 2>&1; then
  fail "renderer accepted a different release at an already-published version"
fi
[[ "$(shasum -a 256 "$preview" | awk '{print $1}')" == "$preview_bytes" ]] \
  || fail "a refused equal-version render still replaced the formula"

# The exact same release again is the one equal-version write that is allowed.
render_preview --not-below "$PREVIEW_FORMULA_VERSION"
[[ "$(shasum -a 256 "$preview" | awk '{print $1}')" == "$preview_bytes" ]] \
  || fail "an idempotent re-dispatch changed the formula bytes"

# ---------------------------------------------------------------------------
# Exact URLs and digests, straight out of the manifest
# ---------------------------------------------------------------------------

asset_url() { jq -r --arg p "$2" '.assets[] | select(.package == $p) | .url' "$1"; }
asset_sha() { jq -r --arg p "$2" '.assets[] | select(.package == $p) | .sha256' "$1"; }

rm -f "$controller" "$production" "$preview"
render_preview
grep -Fq "url \"$(asset_url "$preview_fixture" somawork-cli)\"" "$controller" \
  || fail "controller does not carry the exact controller URL"
grep -Fq "sha256 \"$(asset_sha "$preview_fixture" somawork-cli)\"" "$controller" \
  || fail "controller does not carry the exact controller digest"
grep -Fq "url \"$(asset_url "$preview_fixture" somawork-preview)\"" "$preview" \
  || fail "preview runtime does not carry the exact preview URL"
grep -Fq "sha256 \"$(asset_sha "$preview_fixture" somawork-preview)\"" "$preview" \
  || fail "preview runtime does not carry the exact preview digest"
# The preview manifest's production archive is preview-channel bits; it must not
# appear anywhere in what a preview dispatch publishes.
for formula in "$controller" "$preview"; do
  grep -Fq "$(asset_url "$preview_fixture" somawork)" "$formula" \
    && fail "a preview dispatch published the production-profile archive: $formula"
  grep -Fq "$(asset_sha "$preview_fixture" somawork)" "$formula" \
    && fail "a preview dispatch published the production-profile digest: $formula"
done
for formula in "$controller" "$preview"; do
  [[ "$(grep -c '^  url "' "$formula")" == 1 ]] || fail "$formula does not pin exactly one url"
  [[ "$(grep -c '^  sha256 "' "$formula")" == 1 ]] || fail "$formula does not pin exactly one sha256"
done

rm -f "$controller" "$production" "$preview"
render_stable
grep -Fq "url \"$(asset_url "$stable_fixture" somawork)\"" "$production" \
  || fail "production runtime does not carry the exact production URL"
grep -Fq "$(asset_url "$stable_fixture" somawork-preview)" "$production" \
  && fail "a stable dispatch published the preview-profile archive"

# ---------------------------------------------------------------------------
# Dependency graph, linked executables, coexistence, caveats
# ---------------------------------------------------------------------------

rm -f "$controller" "$production" "$preview"
render_preview
render_stable

grep -Fq 'depends_on "node"' "$controller" || fail "controller does not depend on Homebrew node"
grep -Fq 'depends_on "2lab-ai/tap/llmux"' "$controller" \
  || fail "controller does not depend on the fully-qualified llmux formula"
grep -Fq 'depends_on "2lab-ai/tap/slack-cli"' "$controller" \
  || fail "controller does not depend on the fully-qualified Slack CLI formula"
grep -Fq '# minimum-node: 20.0.0' "$controller" || fail "controller does not record the Node floor"
grep -Fq 'depends_on "2lab-ai/tap/somawork-cli"' "$controller" && fail "controller depends on itself"
grep -Fq 'keg_only' "$controller" && fail "controller is keg_only and could not link somawork"
grep -Fq 'bin.install_symlink prefix/"libexec/bin/somawork" => "somawork"' "$controller" \
  || fail "controller does not link the manifest-declared entry as somawork"
[[ "$(grep -c 'bin.install_symlink' "$controller")" == 1 ]] \
  || fail "controller links more than one executable"
grep -Fq 'prefix.install Dir["*"] + Dir[".[^.]*"]' "$controller" \
  || fail "controller does not install its payload at the keg prefix root"
grep -Fq 'brew install 2lab-ai/tap/somawork-preview' "$controller" \
  || fail "controller caveats do not name the preview runtime formula"
grep -Fq 'brew install 2lab-ai/tap/somawork' "$controller" \
  || fail "controller caveats do not name the production runtime formula"

for formula in "$production" "$preview"; do
  grep -Fq 'depends_on "2lab-ai/tap/somawork-cli"' "$formula" \
    || fail "$formula does not depend on the fully-qualified controller formula"
  grep -Fq 'depends_on "node"' "$formula" && fail "$formula duplicates the controller's Node dependency"
  grep -Eq '\bbin\b' "$formula" && fail "$formula touches bin/ — runtimes must not link an executable"
  grep -Fq 'link_overwrite' "$formula" && fail "$formula overwrites another keg's links"
  grep -Fq 'keg_only' "$formula" || fail "$formula is not keg_only, so two runtimes could collide"
  grep -Fq 'prefix.install Dir["*"] + Dir[".[^.]*"]' "$formula" \
    || fail "$formula does not install the payload at the keg prefix root"
  grep -Fq 'libexec/runtime' "$formula" \
    && fail "$formula nests the runtime below the prefix the controller resolves"
  for entry in .somawork-package.json package.json dist/cli/index.js \
    dist/run-with-rotating-logs.js dist/index.js; do
    grep -Fq "prefix/\"$entry\"" "$formula" \
      || fail "$formula does not assert the manifest-declared runtime entry $entry"
  done
done

# The two runtime kegs are separate installs of separate archives.
[[ "$(asset_url "$stable_fixture" somawork)" != "$(asset_url "$preview_fixture" somawork-preview)" ]] \
  || fail "the fixtures do not actually distinguish the two runtime archives"
diff <(grep '^  url "' "$production") <(grep '^  url "' "$preview") >/dev/null \
  && fail "the two runtime formulae install the same archive"

grep -Fq 'somawork setup --profile preview' "$preview" \
  || fail "preview caveats lack the exact setup command"
grep -Fq 'somawork setup --profile production' "$production" \
  || fail "production caveats lack the exact setup command"
grep -Fq 'somawork setup --profile production' "$preview" \
  && fail "preview caveats name the production profile"
grep -Fq 'somawork setup --profile preview' "$production" \
  && fail "production caveats name the preview profile"
grep -Fq '"preview"' "$preview" || fail "preview formula does not assert its profile marker"
grep -Fq '"production"' "$production" || fail "production formula does not assert its profile marker"
for formula in "$controller" "$production" "$preview"; do
  grep -Eiq '(token|password|secret|credential|api[_ -]?key)' "$formula" \
    && fail "$formula suggests a credential: $formula"
done

# ---------------------------------------------------------------------------
# The Slack CLI the controller depends on
#
# `somawork setup` logs a workspace in through the official Slack CLI, and
# soma-work's own setup code (src/cli/setup/slack-auth.ts) is explicit that
# packaging owns that binary: a missing `slack` is reported as a precondition
# the packager failed to meet, not something setup goes and installs. A Homebrew
# formula cannot depend on a cask, so the dependency target has to be a formula
# in this tap.
#
# Which makes "the controller depends on slack-cli" worth nothing on its own —
# slack-cli could quietly become any archive at all. So the target is pinned
# here too: the exact official v4.6.0 macOS arm64 asset, the digest GitHub's
# release and Homebrew's own official cask both publish, and an install that
# yields `bin/slack`. Repointing any of those turns this suite red.
# ---------------------------------------------------------------------------

slack_formula="$root/Formula/slack-cli.rb"
[[ -f "$slack_formula" ]] \
  || fail "the controller's Slack CLI dependency target is missing: Formula/slack-cli.rb"
ruby -c "$slack_formula" >/dev/null || fail "Formula/slack-cli.rb is not valid Ruby"
grep -Fqx '  version "4.6.0"' "$slack_formula" \
  || fail "slack-cli does not pin the exact upstream version"
grep -Fqx '  url "https://github.com/slackapi/slack-cli/releases/download/v4.6.0/slack_cli_4.6.0_macOS_arm64.tar.gz"' "$slack_formula" \
  || fail "slack-cli does not pin the official v4.6.0 macOS arm64 release asset"
grep -Fqx '  sha256 "c1586ad5625a31d802abb31aa4b023bd12fe3c794221aaf17f6814aaa321a792"' "$slack_formula" \
  || fail "slack-cli does not pin the digest the release and the official cask agree on"
[[ "$(grep -c '^  url "' "$slack_formula")" == 1 ]] || fail "slack-cli does not pin exactly one url"
[[ "$(grep -c '^  sha256 "' "$slack_formula")" == 1 ]] \
  || fail "slack-cli does not pin exactly one archive sha256"
grep -Fqx '  license "Apache-2.0"' "$slack_formula" \
  || fail "slack-cli does not declare the upstream Apache-2.0 license"
grep -Fq 'depends_on arch: :arm64' "$slack_formula" \
  || fail "slack-cli does not refuse architectures its archive has no bits for"
grep -Fq 'depends_on :macos' "$slack_formula" \
  || fail "slack-cli does not refuse platforms its archive has no bits for"

# The archive is `./bin/slack` and nothing else — no LICENSE, no NOTICE, checked
# with `tar -tzf` against the real asset. Apache-2.0 4(a) asks that a copy of
# the License travel with the object form, so the upstream LICENSE is a second
# pinned download rather than an assumption about what is in the tarball.
# The path the formula installs is Homebrew's, not the tarball's. Extraction
# leaves one top-level entry, `bin/`, and the download strategy chdirs into a
# lone directory before `install` runs (Library/Homebrew/download_strategy/
# abstract_download_strategy.rb, `chdir`), so the build directory *is* that
# `bin/` and the executable sits at its root. Naming the tar member `bin/slack`
# here is an `Errno::ENOENT` at install time — which is how it was found, on a
# live install, after this suite had already gone green on the wrong path. The
# harness now replays Homebrew's own unpack rather than a raw `tar -xzf`.
grep -Fq 'bin.install "slack"' "$slack_formula" \
  || fail "slack-cli does not install the Homebrew-normalized slack path"
grep -Fq 'bin.install "bin/slack"' "$slack_formula" \
  && fail "slack-cli installs the raw tar path Homebrew's staging has already chdir'd past"
grep -Fq 'resource "license" do' "$slack_formula" \
  || fail "slack-cli redistributes an Apache-2.0 binary without carrying the License"
grep -Fq 'url "https://raw.githubusercontent.com/slackapi/slack-cli/v4.6.0/LICENSE", using: :nounzip' "$slack_formula" \
  || fail "slack-cli's License is not taken from the immutable upstream tag"
grep -Fq 'sha256 "a65d087cf010a52f8736da6b387df1feb7089e2c0636ef21cb86bef05940e0a4"' "$slack_formula" \
  || fail "slack-cli's License is not pinned by digest"
grep -Fq 'prefix.install "LICENSE"' "$slack_formula" \
  || fail "slack-cli fetches the License but does not install it into the keg"

# `slack` is a name several unrelated tools answer to, so a test that only ran
# the binary would pass on the wrong one. `_fingerprint` is the public CLI's own
# identity command and answers the same constant in every environment; the
# version line pins what this formula claims to have installed.
grep -Fq 'd41d8cd98f00b204e9800998ecf8427e' "$slack_formula" \
  || fail "slack-cli's test does not check the public CLI fingerprint"
grep -Fq 'Using slack v#{version}' "$slack_formula" \
  || fail "slack-cli's test does not check the version the formula claims"

# ---------------------------------------------------------------------------
# The license, in all three formulae and under mutation
#
# soma-work is ISC. A formula copies this field verbatim, so the license lives
# in the templates as fixed project metadata: the manifest has no license field,
# schema version 1 says it may not grow one, and no release payload gets to name
# the license this tap publishes. Both channels were rendered just above, so all
# three formulae are here to check at once.
# ---------------------------------------------------------------------------

for formula in "$controller" "$production" "$preview"; do
  declares_isc_license "$formula" \
    || fail "rendered formula does not declare exactly one ISC license: $formula"
  # Homebrew's own FormulaAudit/ComponentsOrder cop wants `license` after
  # `sha256`, and `brew style` — which is where that would otherwise be caught —
  # needs a real tap and a Homebrew install this suite does not assume. So the
  # ordering it enforces is asserted here, on the bytes that get committed.
  sha_at="$(grep -n '^  sha256 "' "$formula" | head -1 | cut -d: -f1)"
  license_at="$(grep -n '^  license ' "$formula" | head -1 | cut -d: -f1)"
  [[ -n "$sha_at" && -n "$license_at" && "$license_at" -gt "$sha_at" ]] \
    || fail "license is not ordered after sha256, which brew style rejects: $formula"
done
for template in "$controller_template" "$production_template" "$preview_template"; do
  declares_isc_license "$template" \
    || fail "template does not declare exactly one ISC license: $template"
done

# A guard nobody has watched fail is not a guard. Each case below renders from
# copies of the real templates whose license line has been deleted, changed to
# another SPDX id, duplicated, or commented out, and requires the assertion above
# to reject every formula that comes out. Deleting `license "ISC"` from a
# template is what turns this suite red.
license_mutation_is_caught() {
  local label="${1:?label required}"
  shift
  local dir="$work/license-mutation" name formula
  rm -rf "$dir"
  mkdir -p "$dir/Formula" "$dir/out"
  for name in somawork-cli somawork somawork-preview; do
    "$@" <"$root/Formula/$name.rb.tmpl" >"$dir/Formula/$name.rb.tmpl"
    cmp -s "$root/Formula/$name.rb.tmpl" "$dir/Formula/$name.rb.tmpl" \
      && fail "the mutation left $name.rb.tmpl unchanged, so it proves nothing: $label"
  done
  # The mutation touches nothing but the license, so the renderer still accepts
  # these templates — which is exactly why the assertion, not the renderer, has
  # to be the thing that catches it.
  "$renderer" \
    --tag "$PREVIEW_TAG" --package somawork-preview --source-repository 2lab-ai/soma-work \
    --source-sha "$PREVIEW_SOURCE_SHA" --manifest-url "$PREVIEW_MANIFEST_URL" \
    --manifest-sha256 "$preview_sha256" --manifest "$preview_fixture" \
    --controller-template "$dir/Formula/somawork-cli.rb.tmpl" \
    --controller-output "$dir/out/somawork-cli.rb" \
    --runtime-template "$dir/Formula/somawork-preview.rb.tmpl" \
    --runtime-output "$dir/out/somawork-preview.rb" >/dev/null \
    || fail "the renderer refused a preview template mutated only in its license: $label"
  "$renderer" \
    --tag "$STABLE_TAG" --package somawork --source-repository 2lab-ai/soma-work \
    --source-sha "$STABLE_SOURCE_SHA" --manifest-url "$STABLE_MANIFEST_URL" \
    --manifest-sha256 "$stable_sha256" --manifest "$stable_fixture" \
    --controller-template "$dir/Formula/somawork-cli.rb.tmpl" \
    --controller-output "$dir/out/somawork-cli.rb" \
    --runtime-template "$dir/Formula/somawork.rb.tmpl" \
    --runtime-output "$dir/out/somawork.rb" >/dev/null \
    || fail "the renderer refused a stable template mutated only in its license: $label"
  for formula in "$dir/out/somawork-cli.rb" "$dir/out/somawork.rb" "$dir/out/somawork-preview.rb"; do
    if declares_isc_license "$formula"; then
      fail "the license assertion passed a formula rendered from a mutated template: $label ($formula)"
    fi
  done
  rm -rf "$dir"
  return 0
}

license_mutation_is_caught "a template with the license line deleted" \
  sed '/^  license "ISC"$/d'
license_mutation_is_caught "a template that names a different license" \
  sed 's/^  license "ISC"$/  license "MIT"/'
license_mutation_is_caught "a template that declares the license twice" \
  awk '{ print } /^  license "ISC"$/ { print }'
license_mutation_is_caught "a template whose license line is commented out" \
  sed 's/^  license "ISC"$/  # license "ISC"/'

# The tracked templates were only ever read above, and still say what they said.
for template in "$controller_template" "$production_template" "$preview_template"; do
  declares_isc_license "$template" \
    || fail "a license mutation case wrote back into the tracked template: $template"
done

# ---------------------------------------------------------------------------
# Rejections — every one of these must leave no formula behind
# ---------------------------------------------------------------------------

mutate() {
  local filter="${1:?filter required}"
  local target="$work/mutated.json"
  jq "$filter" "$preview_fixture" >"$target"
  printf '%s' "$target"
}

render_manifest() {
  local manifest="${1:?manifest required}"
  local sha
  sha="$(shasum -a 256 "$manifest" | awk '{print $1}')"
  "$renderer" \
    --tag "$PREVIEW_TAG" --package somawork-preview --source-repository 2lab-ai/soma-work \
    --source-sha "$PREVIEW_SOURCE_SHA" --manifest-url "$PREVIEW_MANIFEST_URL" \
    --manifest-sha256 "$sha" --manifest "$manifest" \
    --controller-template "$controller_template" --controller-output "$controller" \
    --runtime-template "$preview_template" --runtime-output "$preview"
}

reject "a foreign schema version" "manifest schema version is not the exact integer 1" render_manifest "$(mutate '.schemaVersion = 2')"
reject "an unknown runtime layout version" "manifest layout version is not the exact integer 1" render_manifest "$(mutate '.layoutVersion = 2')"
reject "an unknown channel" "manifest channel is not a known release channel" render_manifest "$(mutate '.channel = "nightly"')"
reject "a channel the dispatch package contradicts" "dispatch package does not match the manifest channel" render_manifest "$(mutate '.channel = "stable"')"
reject "a foreign platform" "manifest platform is not the supported platform" render_manifest "$(mutate '.platform = "darwin-x86_64"')"
reject "a Node floor the tap has not verified" "manifest raises the Node floor above the version this tap has verified" render_manifest "$(mutate '.minimumNode = "22.0.0"')"
reject "a base URL that disagrees with its own assets" "manifest base URL is not the canonical release origin" \
  render_manifest "$(mutate '.baseUrl = "https://github.com/2lab-ai/soma-work/releases/download/other"')"
reject "a mirrored base URL" "manifest base URL is not the canonical release origin" \
  render_manifest "$(mutate '.baseUrl = "https://evil.example.com/2lab-ai/soma-work/releases/download/somawork-preview-v0.1.0-987654321" | .assets = [.assets[] | .url = ("https://evil.example.com/2lab-ai/soma-work/releases/download/somawork-preview-v0.1.0-987654321/" + .filename)]')"
reject "an asset URL off the release base" "manifest asset somawork-cli URL is not the immutable release URL" \
  render_manifest "$(mutate '.assets[0].url = "https://github.com/2lab-ai/soma-work/releases/download/other/somawork-cli-0.1.0-darwin-arm64.tar.gz"')"
reject "an invented asset filename" "manifest asset somawork-cli filename must be somawork-cli-0.1.0-darwin-arm64.tar.gz" render_manifest "$(mutate '.assets[0].filename = "somawork-cli.tar.gz"')"
reject "a reordered asset list" "manifest asset 0 must be somawork-cli" render_manifest "$(mutate '.assets = [.assets[2], .assets[1], .assets[0]]')"
reject "a fourth asset" "manifest must describe exactly three assets" render_manifest "$(mutate '.assets += [.assets[0]]')"
reject "a dropped asset" "manifest must describe exactly three assets" render_manifest "$(mutate '.assets = [.assets[0], .assets[1]]')"
reject "a controller that claims a runtime profile" "manifest asset somawork-cli must install profile None" render_manifest "$(mutate '.assets[0].profile = "preview"')"
reject "a runtime with the wrong profile" "manifest asset somawork must install profile production" render_manifest "$(mutate '.assets[1].profile = "preview"')"
reject "a non-integer byte count" "manifest asset somawork-cli byte count is not a positive integer" render_manifest "$(mutate '.assets[0].bytes = 56.0')"
reject "a boolean byte count" "manifest asset somawork-cli byte count is not a positive integer" render_manifest "$(mutate '.assets[0].bytes = true')"
reject "a zero byte count" "manifest asset somawork-cli byte count is not a positive integer" render_manifest "$(mutate '.assets[0].bytes = 0')"
reject "a truncated digest" "manifest asset somawork-cli SHA-256 is invalid" render_manifest "$(mutate '.assets[0].sha256 = "abc"')"
reject "an upper-case digest" "manifest asset somawork-cli SHA-256 is invalid" render_manifest "$(mutate '.assets[0].sha256 = (.assets[0].sha256 | ascii_upcase)')"
reject "an extra manifest field" "manifest fields are not exact" render_manifest "$(mutate '.extra = 1')"
# The license is the tap's, not the release's. Schema version 1 has no license
# field, so a payload that tries to name one is refused here rather than being
# ignored quietly — an ignored field is one refactor away from an honoured one.
reject "a manifest that tries to name the license" "manifest fields are not exact" render_manifest "$(mutate '.license = "MIT"')"
reject "a missing manifest field" "manifest fields are not exact" render_manifest "$(mutate 'del(.minimumNode)')"
reject "an extra asset field" "manifest asset 0 fields are not exact" render_manifest "$(mutate '.assets[0].extra = 1')"
# A constraint this tap imposes on soma-work, recorded here because it is not
# obvious from either side: soma-work's manifest grammar accepts `0.2.0-rc.1`,
# but the composed Homebrew version is ordered as a tuple of integers, so a
# package version with a non-numeric part cannot be published at all. It fails
# closed rather than being published at a version Homebrew and this renderer
# would order differently.
# The tag has to move with the version, or this never reaches the ordering check:
# a tag still naming `0.1.0` is refused by the tag bind first, and the case would
# be asserting a rule it does not exercise.
non_numeric="$work/non-numeric.json"
NON_NUMERIC_TAG=somawork-preview-v0.1.0rc1-987654321
NON_NUMERIC_BASE="https://github.com/2lab-ai/soma-work/releases/download/$NON_NUMERIC_TAG"
jq --arg tag "$NON_NUMERIC_TAG" --arg base "$NON_NUMERIC_BASE" '
    .version = "0.1.0rc1" | .tag = $tag | .baseUrl = $base
    | .assets = [.assets[]
        | .filename = (.package + "-0.1.0rc1-darwin-arm64.tar.gz")
        | .url = ($base + "/" + .filename)]' \
  "$preview_fixture" >"$non_numeric"
reject "a non-numeric package version, which this tap cannot order" \
  "composed formula version is not a comparable dotted numeric version" \
  "$renderer" \
  --tag "$NON_NUMERIC_TAG" --package somawork-preview --source-repository 2lab-ai/soma-work \
  --source-sha "$PREVIEW_SOURCE_SHA" \
  --manifest-url "$NON_NUMERIC_BASE/somawork-manifest.json" \
  --manifest-sha256 "$(shasum -a 256 "$non_numeric" | awk '{print $1}')" \
  --manifest "$non_numeric" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$preview_template" --runtime-output "$preview"
reject "an escaping controller entry" "layout controller.entry is not a safe, normalized relative path" render_manifest "$(mutate '.layout.controller.entry = "../../etc/somawork"')"
reject "a controller entry at the wrong depth" "layout controller.entry must be 3 path segments deep" render_manifest "$(mutate '.layout.controller.entry = "bin/somawork"')"
reject "an unnormalized controller entry" "layout controller.entry is not a safe, normalized relative path" render_manifest "$(mutate '.layout.controller.entry = "libexec/./bin/somawork"')"
reject "an absolute runtime entry" "layout runtime.daemon is not a safe, normalized relative path" render_manifest "$(mutate '.layout.runtime.daemon = "/etc/passwd"')"
reject "a non-prefix install mode" "manifest layout install mode is not prefix-rooted" render_manifest "$(mutate '.layout.install = "libexec"')"
reject "a missing layout block" "manifest fields are not exact" render_manifest "$(mutate 'del(.layout)')"

reject "a tag the manifest does not describe" "manifest tag does not match the dispatch" "$renderer" \
  --tag somawork-preview-v0.1.0-111111111 --package somawork-preview \
  --source-repository 2lab-ai/soma-work --source-sha "$PREVIEW_SOURCE_SHA" \
  --manifest-url "https://github.com/2lab-ai/soma-work/releases/download/somawork-preview-v0.1.0-111111111/somawork-manifest.json" \
  --manifest-sha256 "$preview_sha256" --manifest "$preview_fixture" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$preview_template" --runtime-output "$preview"

reject "a source commit the release does not point at" "manifest source SHA does not match the resolved release commit" "$renderer" \
  --tag "$PREVIEW_TAG" --package somawork-preview --source-repository 2lab-ai/soma-work \
  --source-sha ffffffffffffffffffffffffffffffffffffffff --manifest-url "$PREVIEW_MANIFEST_URL" \
  --manifest-sha256 "$preview_sha256" --manifest "$preview_fixture" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$preview_template" --runtime-output "$preview"

reject "a foreign source repository" "dispatch source repository is not the somawork project" "$renderer" \
  --tag "$PREVIEW_TAG" --package somawork-preview --source-repository evil/soma-work \
  --source-sha "$PREVIEW_SOURCE_SHA" --manifest-url "$PREVIEW_MANIFEST_URL" \
  --manifest-sha256 "$preview_sha256" --manifest "$preview_fixture" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$preview_template" --runtime-output "$preview"

# The controller is not a release channel. Its own paths are used here so the
# path binding passes and the package check is what has to refuse this.
mkdir -p "$work/impostor"
reject "a dispatch package that is the controller" "dispatch package is not a somawork release channel" "$renderer" \
  --tag "$PREVIEW_TAG" --package somawork-cli --source-repository 2lab-ai/soma-work \
  --source-sha "$PREVIEW_SOURCE_SHA" --manifest-url "$PREVIEW_MANIFEST_URL" \
  --manifest-sha256 "$preview_sha256" --manifest "$preview_fixture" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$controller_template" --runtime-output "$work/impostor/somawork-cli.rb"
[[ -e "$work/impostor/somawork-cli.rb" ]] && fail "renderer wrote a formula for the controller package"

reject "a manifest URL that is not the release manifest" "dispatch manifest URL is not the exact immutable release URL" "$renderer" \
  --tag "$PREVIEW_TAG" --package somawork-preview --source-repository 2lab-ai/soma-work \
  --source-sha "$PREVIEW_SOURCE_SHA" --manifest-url "$PREVIEW_BASE/manifest.json" \
  --manifest-sha256 "$preview_sha256" --manifest "$preview_fixture" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$preview_template" --runtime-output "$preview"

reject "a mismatched manifest digest" "manifest SHA-256 does not match the dispatch" "$renderer" \
  --tag "$PREVIEW_TAG" --package somawork-preview --source-repository 2lab-ai/soma-work \
  --source-sha "$PREVIEW_SOURCE_SHA" --manifest-url "$PREVIEW_MANIFEST_URL" \
  --manifest-sha256 ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff \
  --manifest "$preview_fixture" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$preview_template" --runtime-output "$preview"

# Duplicate JSON object keys: two "version" members, one document.
duplicate="$work/duplicate.json"
awk 'NR == 2 { print "  \"version\": \"9.9.9\"," } { print }' "$preview_fixture" >"$duplicate"
reject "duplicate JSON object keys" "duplicate JSON object key: version" render_manifest "$duplicate"

# Symlinked inputs and outputs.
link_manifest="$work/linked-manifest.json"
ln -sf "$preview_fixture" "$link_manifest"
reject "a symlinked manifest" "manifest must be a regular file, not a symlink" render_manifest "$link_manifest"

link_template="$work/somawork-preview.rb.tmpl"
ln -sf "$preview_template" "$link_template"
reject "a symlinked template" "somawork-preview template must be a regular file, not a symlink" "$renderer" \
  --tag "$PREVIEW_TAG" --package somawork-preview --source-repository 2lab-ai/soma-work \
  --source-sha "$PREVIEW_SOURCE_SHA" --manifest-url "$PREVIEW_MANIFEST_URL" \
  --manifest-sha256 "$preview_sha256" --manifest "$preview_fixture" \
  --controller-template "$controller_template" --controller-output "$controller" \
  --runtime-template "$link_template" --runtime-output "$preview"

decoy="$work/decoy.rb"
: >"$decoy"
rm -f "$controller" "$preview"
ln -sf "$decoy" "$preview"
if render_preview >/dev/null 2>&1; then
  fail "renderer accepted a symlinked output"
fi
[[ -s "$decoy" ]] && fail "renderer wrote through a symlinked output"
[[ -e "$controller" ]] && fail "renderer wrote one formula before refusing the other"
rm -f "$preview"

# Atomicity within a channel: a mid-run refusal must not replace what is there.
render_preview
before_controller="$(shasum -a 256 "$controller" | awk '{print $1}')"
before_preview="$(shasum -a 256 "$preview" | awk '{print $1}')"
broken="$work/broken.json"
jq '.assets[2].sha256 = "nope"' "$preview_fixture" >"$broken"
if render_manifest "$broken" >/dev/null 2>&1; then
  fail "renderer accepted a manifest with an invalid runtime digest"
fi
[[ "$(shasum -a 256 "$controller" | awk '{print $1}')" == "$before_controller" ]] \
  || fail "a rejected render replaced the controller formula"
[[ "$(shasum -a 256 "$preview" | awk '{print $1}')" == "$before_preview" ]] \
  || fail "a rejected render replaced the preview formula"

echo "somawork tap contract: ok"
