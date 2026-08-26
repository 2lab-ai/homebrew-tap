#!/usr/bin/env bash
#
# somawork install harness — two releases, a temporary tap, local archives.
#
# ## What this does, and what it deliberately does not
#
# It models the real end state: a preview release and a stable release, each
# dispatched separately, each rendering the shared controller plus its own
# runtime. Preview goes first, stable second, so the tap ends with the stable
# controller and both runtime kegs — which is the "last channel bump updates the
# common controller" behaviour, exercised rather than asserted.
#
# The formulae come from the production renderer with nothing weakened; only the
# `url` and `sha256` lines are then swapped for `file://` fixtures under this
# script's control, and the result is diffed against canonical to prove nothing
# else moved.
#
# It does NOT install into the machine's Homebrew prefix. `brew install` writes
# into `HOMEBREW_CELLAR`, links into `HOMEBREW_PREFIX`, and leaves receipts —
# doing that against the developer's own prefix to prove a point about
# coexistence would be a worse outcome than not proving it here. So the install
# stage runs only when `SOMAWORK_TEST_HOMEBREW_PREFIX` names a Homebrew
# installation this harness is allowed to mutate. Task 4 of the packaging plan is
# where that prefix gets created; until then this script prepares everything and
# prints the exact commands that were not run, rather than printing a receipt
# nobody earned.
#
# Usage:
#   scripts/test-somawork-install-harness.sh
#   SOMAWORK_TEST_HOMEBREW_PREFIX=/tmp/brew scripts/test-somawork-install-harness.sh
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
renderer="$root/scripts/render-somawork-formulae.py"

VERSION=1.0.0
PREVIEW_TAG=somawork-preview-v1.0.0-987654321
PREVIEW_SOURCE_SHA=0123456789abcdef0123456789abcdef01234567
PREVIEW_FORMULA_VERSION=1.0.0.987654321
STABLE_TAG=somawork-v1.0.0-987654322
STABLE_SOURCE_SHA=89abcdef0123456789abcdef0123456789abcdef
STABLE_FORMULA_VERSION=1.0.0.987654322

fail() {
  echo "somawork install harness: $*" >&2
  exit 1
}

[[ -x "$renderer" ]] || fail "tracked executable renderer is missing"
command -v brew >/dev/null 2>&1 || fail "brew is not on PATH"

work="$(mktemp -d "${TMPDIR:-/tmp}/somawork-install-harness.XXXXXX")"
trap 'rm -rf "$work"' EXIT HUP INT TERM
tap="$work/tap/2lab-ai/homebrew-somawork-test"
mkdir -p "$tap/Formula"

# --- everything Homebrew writes goes inside this scratch directory ------------
#
# Redirecting the prefix is not enough. `brew` downloads into HOMEBREW_CACHE,
# unpacks through HOMEBREW_TEMP and writes HOMEBREW_LOGS, and all three default
# to the *user's* home (`~/Library/Caches/Homebrew`, `~/Library/Logs/Homebrew`)
# no matter which prefix it is running out of. A Task 4 run that only moved the
# prefix would still leave artefacts of a synthetic release in the developer's
# home directory. These are exported before anything runs, so the prepare-only
# path and the install path use exactly the same environment.
export HOMEBREW_CACHE="$work/homebrew/cache"
export HOMEBREW_TEMP="$work/homebrew/temp"
export HOMEBREW_LOGS="$work/homebrew/logs"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSTALL_FROM_API=1

# …and prove it, rather than trusting the assignment. Each redirect must be a
# real directory under this scratch tree, and must not be the machine's own
# prefix, home, or Homebrew defaults. The lexical check comes before `mkdir`, so
# a redirect pointing somewhere it should not never gets a directory created for
# it on the way to being rejected.
real_prefix="$(brew --prefix)"
scratch_root="$(cd "$work" && pwd -P)"
for redirect in HOMEBREW_CACHE HOMEBREW_TEMP HOMEBREW_LOGS; do
  value="$(eval "printf '%s' \"\$$redirect\"")"
  [[ -n "$value" ]] || fail "$redirect is empty"
  case "$value" in
    "$work"/*) ;;
    *) fail "$redirect escapes the harness scratch directory: $value" ;;
  esac
  mkdir -p "$value"
  resolved="$(cd "$value" && pwd -P)"
  case "$resolved" in
    "$scratch_root"/*) ;;
    *) fail "$redirect escapes the harness scratch directory: $resolved" ;;
  esac
  [[ "$resolved" != "$real_prefix" ]] || fail "$redirect is the machine's Homebrew prefix"
  [[ "$resolved" != "$HOME" ]] || fail "$redirect is the user's home directory"
  case "$resolved" in
    "$HOME"/Library/Caches/Homebrew*|"$HOME"/Library/Logs/Homebrew*|"$HOME"/.cache/Homebrew*)
      fail "$redirect is a Homebrew default under the user's home: $resolved" ;;
  esac
  [[ "$resolved" != "$real_prefix"/* ]] || fail "$redirect is inside the machine's Homebrew prefix"
done

# --- synthetic archives, one set per release ---------------------------------

marker() {
  jq -n --arg package "$1" --argjson profile "$2" --arg channel "$3" \
    --arg version "$VERSION" --arg source_sha "$4" '
      {schemaVersion: 1, package: $package, profile: $profile, channel: $channel,
       version: $version, sourceSha: $source_sha, platform: "darwin-arm64",
       layoutVersion: 1}'
}

build_controller() {
  local channel="$1" source_sha="$2" assets="$3"
  local tree="$work/build/$channel/somawork-cli"
  mkdir -p "$tree/libexec/bin"
  cat >"$tree/libexec/bin/somawork" <<'NODE'
#!/usr/bin/env node
const {version} = require(`${__dirname}/../../package.json`);
if (process.argv[2] === '--version') { console.log(version); process.exit(0); }
console.log('somawork controller');
NODE
  chmod 0755 "$tree/libexec/bin/somawork"
  jq -n --arg version "$VERSION" '
    {name: "somawork-cli", version: $version, private: true,
     bin: {somawork: "libexec/bin/somawork"}, engines: {node: ">=20.0.0"}}' \
    >"$tree/package.json"
  marker somawork-cli null "$channel" "$source_sha" >"$tree/.somawork-package.json"
  ( cd "$tree" && tar -czf "$assets/somawork-cli-$VERSION-darwin-arm64.tar.gz" . )
}

build_runtime() {
  local package="$1" profile="$2" channel="$3" source_sha="$4" assets="$5"
  local tree="$work/build/$channel/$package"
  mkdir -p "$tree/dist/cli"
  printf 'module.exports = {};\n' >"$tree/dist/cli/index.js"
  printf 'module.exports = {};\n' >"$tree/dist/index.js"
  printf 'module.exports = {};\n' >"$tree/dist/run-with-rotating-logs.js"
  printf '{}\n' >"$tree/config.default.json"
  jq -n --arg version "$VERSION" '{name: "soma-work", version: $version, private: true}' \
    >"$tree/package.json"
  marker "$package" "\"$profile\"" "$channel" "$source_sha" >"$tree/.somawork-package.json"
  ( cd "$tree" && tar -czf "$assets/$package-$VERSION-darwin-arm64.tar.gz" . )
}

asset_json() {
  local package="$1" profile="$2" base="$3" assets="$4"
  local filename="$package-$VERSION-darwin-arm64.tar.gz"
  jq -n --arg package "$package" --argjson profile "$profile" \
    --arg filename "$filename" --arg url "$base/$filename" \
    --arg sha256 "$(shasum -a 256 "$assets/$filename" | awk '{print $1}')" \
    --argjson bytes "$(wc -c <"$assets/$filename" | tr -d ' ')" '
      {package: $package, profile: $profile, filename: $filename, url: $url,
       sha256: $sha256, bytes: $bytes}'
}

build_release() {
  local channel="$1" tag="$2" source_sha="$3"
  local assets="$work/assets/$channel"
  local base="https://github.com/2lab-ai/soma-work/releases/download/$tag"
  mkdir -p "$assets"
  build_controller "$channel" "$source_sha" "$assets"
  build_runtime somawork production "$channel" "$source_sha" "$assets"
  build_runtime somawork-preview preview "$channel" "$source_sha" "$assets"
  jq -n --arg channel "$channel" --arg version "$VERSION" --arg tag "$tag" \
    --arg source_sha "$source_sha" --arg base "$base" \
    --slurpfile controller <(asset_json somawork-cli null "$base" "$assets") \
    --slurpfile production <(asset_json somawork '"production"' "$base" "$assets") \
    --slurpfile preview <(asset_json somawork-preview '"preview"' "$base" "$assets") '
      {schemaVersion: 1, layoutVersion: 1, channel: $channel, version: $version,
       tag: $tag, sourceSha: $source_sha, platform: "darwin-arm64",
       minimumNode: "20.0.0", baseUrl: $base,
       layout: {install: "prefix",
         controller: {entry: "libexec/bin/somawork", manifest: "package.json"},
         runtime: {marker: ".somawork-package.json", manifest: "package.json",
           controllerEntry: "dist/cli/index.js",
           supervisor: "dist/run-with-rotating-logs.js", daemon: "dist/index.js"}},
       assets: [$controller[0], $production[0], $preview[0]]}' \
    >"$work/$channel-manifest.json"
}

build_release preview "$PREVIEW_TAG" "$PREVIEW_SOURCE_SHA"
build_release stable "$STABLE_TAG" "$STABLE_SOURCE_SHA"

# --- render, one dispatch at a time ------------------------------------------

canonical="$work/canonical"
mkdir -p "$canonical"

# Every formula the dispatch would replace contributes a baseline, exactly as the
# write job does it — the controller included, which is what keeps the two
# channels ordered against each other.
dispatch() {
  local channel="$1" package="$2" tag="$3" source_sha="$4"
  local manifest="$work/$channel-manifest.json"
  local base="https://github.com/2lab-ai/soma-work/releases/download/$tag"
  # `${a[@]+"${a[@]}"}` rather than `"${a[@]}"`: macOS ships bash 3.2, where
  # expanding an empty array under `set -u` is an unbound-variable error.
  local baseline=()
  local existing current
  for existing in "$canonical/somawork-cli.rb" "$canonical/$package.rb"; do
    [[ -f "$existing" ]] || continue
    current="$(sed -n 's/^  version "\(.*\)"$/\1/p' "$existing" | head -1)"
    [[ -n "$current" ]] || fail "$existing has no version to baseline against"
    baseline+=(--not-below "$current")
  done
  "$renderer" \
    --tag "$tag" --package "$package" --source-repository 2lab-ai/soma-work \
    --source-sha "$source_sha" ${baseline[@]+"${baseline[@]}"} \
    --manifest-url "$base/somawork-manifest.json" \
    --manifest-sha256 "$(shasum -a 256 "$manifest" | awk '{print $1}')" \
    --manifest "$manifest" \
    --controller-template "$root/Formula/somawork-cli.rb.tmpl" \
    --controller-output "$canonical/somawork-cli.rb" \
    --runtime-template "$root/Formula/$package.rb.tmpl" \
    --runtime-output "$canonical/$package.rb" >/dev/null
}

dispatch preview somawork-preview "$PREVIEW_TAG" "$PREVIEW_SOURCE_SHA"
grep -Fq "version \"$PREVIEW_FORMULA_VERSION\"" "$canonical/somawork-preview.rb" \
  || fail "the preview dispatch did not produce a run-qualified version"
[[ -e "$canonical/somawork.rb" ]] && fail "the preview dispatch created the stable formula"

dispatch stable somawork "$STABLE_TAG" "$STABLE_SOURCE_SHA"
grep -Fq "version \"$STABLE_FORMULA_VERSION\"" "$canonical/somawork.rb" \
  || fail "the stable dispatch did not compose its run id"
grep -Fq "version \"$PREVIEW_FORMULA_VERSION\"" "$canonical/somawork-preview.rb" \
  || fail "the stable dispatch rewrote the preview formula"
# The shared controller follows the last bump, and because both channels compose
# the same repository-wide run id it moves forward doing so.
grep -Fq "# tag: $STABLE_TAG" "$canonical/somawork-cli.rb" \
  || fail "the last channel bump did not take the shared controller"
grep -Fq "version \"$STABLE_FORMULA_VERSION\"" "$canonical/somawork-cli.rb" \
  || fail "the shared controller did not advance with the last bump"
# What the software reports is still the package version, which is what the
# formulae assert and what the install stage below checks.
grep -Fq "# package-version: $VERSION" "$canonical/somawork-cli.rb" \
  || fail "the controller does not record the package version"

# --- localize into a throwaway tap -------------------------------------------

localize() {
  local channel="$1" package="$2"
  local archive="$work/assets/$channel/$package-$VERSION-darwin-arm64.tar.gz"
  local digest
  digest="$(shasum -a 256 "$archive" | awk '{print $1}')"
  awk -v url="file://$archive" -v sha="$digest" '
    /^  url "/ { print "  url \"" url "\""; next }
    /^  sha256 "/ { print "  sha256 \"" sha "\""; next }
    { print }
  ' "$canonical/$package.rb" >"$tap/Formula/$package.rb"
  ruby -c "$tap/Formula/$package.rb" >/dev/null || fail "$package.rb is not valid Ruby"
  grep -Fq "file://$archive" "$tap/Formula/$package.rb" || fail "$package.rb was not localized"
  diff <(grep -v '^  url "\|^  sha256 "' "$tap/Formula/$package.rb") \
       <(grep -v '^  url "\|^  sha256 "' "$canonical/$package.rb") >/dev/null \
    || fail "the localized $package.rb differs from canonical beyond url/sha256"
}
# The controller in the tap is the stable one, so its bytes come from the stable
# release's archive.
localize stable somawork-cli
localize stable somawork
localize preview somawork-preview

echo "somawork install harness: prepared"
echo "  tap:      $tap"
echo "  archives: $work/assets"
echo "  cache:    $HOMEBREW_CACHE"
echo "  temp:     $HOMEBREW_TEMP"
echo "  logs:     $HOMEBREW_LOGS"

prefix="${SOMAWORK_TEST_HOMEBREW_PREFIX:-}"
if [[ -z "$prefix" ]]; then
  cat <<EOS
somawork install harness: install stage NOT run — no isolated Homebrew prefix.

  Installing into this machine's prefix ($(brew --prefix)) would create real
  kegs, links and receipts for a synthetic release. That is not a test result,
  so it is refused rather than faked.

  The receipt this harness exists to produce is packaging-plan Task 4:

    export HOMEBREW_PREFIX=<fresh prefix>   # plus HOMEBREW_CELLAR/REPOSITORY
    SOMAWORK_TEST_HOMEBREW_PREFIX="\$HOMEBREW_PREFIX" \\
      scripts/test-somawork-install-harness.sh

  which would then run, against that prefix only:

    brew install <tap>/Formula/somawork-cli.rb
    brew install <tap>/Formula/somawork-preview.rb
    brew install <tap>/Formula/somawork.rb
    brew --prefix somawork-preview   # runtime root, keg-local
    brew --prefix somawork           # second runtime root, coexisting
    somawork --version               # the single linked controller
EOS
  exit 0
fi

[[ -x "$prefix/bin/brew" ]] || fail "SOMAWORK_TEST_HOMEBREW_PREFIX has no bin/brew"
[[ "$(cd "$prefix" && pwd -P)" != "$(brew --prefix)" ]] \
  || fail "refusing to install into this machine's own Homebrew prefix"

isolated_brew="$prefix/bin/brew"
# HOMEBREW_CACHE/TEMP/LOGS and the no-network flags were exported at the top of
# this script and checked there; the install path inherits exactly the same
# environment the prepare-only path ran under.
[[ "$HOMEBREW_CACHE" == "$work"/* ]] || fail "the cache redirect was lost before install"
[[ "$HOMEBREW_TEMP" == "$work"/* ]] || fail "the temp redirect was lost before install"
[[ "$HOMEBREW_LOGS" == "$work"/* ]] || fail "the log redirect was lost before install"

"$isolated_brew" install --formula "$tap/Formula/somawork-cli.rb"
"$isolated_brew" install --formula "$tap/Formula/somawork-preview.rb"
"$isolated_brew" install --formula "$tap/Formula/somawork.rb"

preview_root="$("$isolated_brew" --prefix somawork-preview)"
production_root="$("$isolated_brew" --prefix somawork)"
[[ "$preview_root" != "$production_root" ]] || fail "the two runtimes resolved to one root"
for entry in dist/run-with-rotating-logs.js dist/index.js package.json .somawork-package.json; do
  [[ -f "$preview_root/$entry" ]] || fail "preview runtime is missing $entry"
  [[ -f "$production_root/$entry" ]] || fail "production runtime is missing $entry"
done
[[ "$(jq -r .profile "$preview_root/.somawork-package.json")" == preview ]] \
  || fail "the preview keg does not carry the preview profile"
[[ "$(jq -r .profile "$production_root/.somawork-package.json")" == production ]] \
  || fail "the production keg does not carry the production profile"
[[ -L "$prefix/bin/somawork" ]] || fail "the controller did not link somawork"
[[ "$("$prefix/bin/somawork" --version)" == "$VERSION" ]] \
  || fail "the linked controller does not report the release version"

echo "somawork install harness: ok (isolated prefix $prefix)"
