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

# An archive laid out exactly like the official Slack CLI release: `./bin/slack`,
# mode 0755, and nothing else — no LICENSE, no NOTICE. That layout was read off
# the real v4.6.0 macOS arm64 asset with `tar -tzf`, and it is what the tap's
# slack-cli formula is written against. Reproducing it here means a formula that
# names a path the release does not carry fails in this harness rather than on a
# user's machine.
SLACK_CLI_VERSION=4.6.0
SLACK_CLI_FINGERPRINT=d41d8cd98f00b204e9800998ecf8427e
slack_archive="$work/assets/slack-cli/slack_cli_${SLACK_CLI_VERSION}_macOS_arm64.tar.gz"

build_slack_cli() {
  local tree="$work/build/slack-cli"
  mkdir -p "$tree/bin" "$(dirname "$slack_archive")"
  cat >"$tree/bin/slack" <<SLACK
#!/bin/sh
case "\$1" in
  _fingerprint) echo $SLACK_CLI_FINGERPRINT ;;
  version) echo "Using slack v$SLACK_CLI_VERSION" ;;
  *) exit 1 ;;
esac
SLACK
  chmod 0755 "$tree/bin/slack"
  ( cd "$tree" && tar -czf "$slack_archive" . )
}

build_slack_cli

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

# --- the Slack CLI in the controller's dependency closure ---------------------
#
# `somawork setup` cannot log a workspace in without the official Slack CLI, and
# soma-work's setup code (src/cli/setup/slack-auth.ts) says packaging owns that
# binary rather than installing it. So the closure the controller declares has to
# end at something that puts `slack` on PATH — checked here mechanically, not by
# reading a README that says so.
#
# Three steps: take the tap-qualified dependencies out of the rendered
# controller; require each to be a formula this tap actually defines; take the
# executables those formulae install and require `slack` among them. Then replay
# the slack-cli install line against the official-layout archive built above, so
# a formula naming a path the release does not carry fails here too.
#
# The real `brew install` proof is in the install stage below. This part runs
# whether or not an isolated prefix exists, because a closure that has stopped
# provisioning `slack` is a defect either way.

closure_executables=""
slack_dependency=""
while IFS= read -r dep; do
  [[ -n "$dep" ]] || continue
  dep_formula="$root/Formula/$dep.rb"
  [[ -f "$dep_formula" ]] \
    || fail "the controller depends on 2lab-ai/tap/$dep, which this tap does not define"
  if [[ "$dep" == slack-cli ]]; then
    slack_dependency="$dep_formula"
  fi
  closure_executables="$closure_executables
$(sed -n -e 's/^.*bin\.install[^=]*=> "\([^"]*\)".*$/\1/p' \
         -e 's/^ *bin\.install "\([^"]*\)"$/\1/p' "$dep_formula" | sed 's|.*/||')"
done < <(sed -n 's|^  depends_on "2lab-ai/tap/\(.*\)"$|\1|p' "$canonical/somawork-cli.rb")

printf '%s\n' "$closure_executables" | grep -Fqx slack \
  || fail "the controller's dependency closure provisions no slack executable"
[[ -n "$slack_dependency" ]] || fail "the controller does not depend on this tap's Slack CLI formula"

# The raw archive layout, kept as its own assertion so the fixture stays a
# faithful stand-in: `tar -tzf` on the pinned v4.6.0 asset lists exactly `./`,
# `./bin/` and `./bin/slack`.
[[ "$(tar -tzf "$slack_archive" | sort | tr '\n' ' ')" == "./ ./bin/ ./bin/slack " ]] \
  || fail "the fixture archive no longer has the official release's tar layout"

# …and then what Homebrew actually hands `def install`, which is not that. This
# suite used to replay a plain `tar -xzf` and went green on a formula that
# installed `bin/slack`; a live `brew install` then died with
# `Errno::ENOENT: bin/slack`, because extraction leaves one top-level entry and
# the download strategy chdirs into a lone directory before `install` runs
# (Library/Homebrew/download_strategy/abstract_download_strategy.rb, `chdir`).
# So the staging is done by Homebrew's own UnpackStrategy through `brew ruby`,
# rather than by this script re-deriving a rule it got wrong once already.
cat >"$work/homebrew-stage.rb" <<'RUBY'
require "unpack_strategy"
archive = Pathname(ARGV.fetch(0))
staged = Pathname(ARGV.fetch(1))
staged.mkpath
Dir.chdir(staged) do
  UnpackStrategy.detect(archive, prioritize_extension: true)
                .extract_nestedly(basename: archive.basename, prioritize_extension: true, verbose: false)
  entries = Dir["*"]
  raise "Empty archive" if entries.empty?
  if entries.length == 1 && File.directory?(entries.fetch(0))
    puts File.join(Dir.pwd, entries.fetch(0))
  else
    puts Dir.pwd
  end
end
RUBY
slack_stage="$work/slack-stage"
rm -rf "$slack_stage"
slack_buildpath="$(brew ruby "$work/homebrew-stage.rb" "$slack_archive" "$slack_stage" | tail -1)"
[[ -d "$slack_buildpath" ]] \
  || fail "Homebrew's own unpack produced no build directory for the Slack CLI archive"
[[ "$slack_buildpath" != "$slack_stage" ]] \
  || fail "Homebrew no longer chdirs past the archive's single top-level directory, so slack-cli's install path is stale"

slack_source="$(sed -n 's/^ *bin\.install "\([^"]*\)".*$/\1/p' "$slack_dependency" | head -1)"
[[ -n "$slack_source" ]] || fail "slack-cli does not name the path it installs as slack"
[[ -x "$slack_buildpath/$slack_source" ]] \
  || fail "slack-cli installs \"$slack_source\", which is not an executable in the directory Homebrew stages for it"
[[ "$("$slack_buildpath/$slack_source" _fingerprint)" == "$SLACK_CLI_FINGERPRINT" ]] \
  || fail "the replayed slack-cli install did not yield the public Slack CLI"

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
    slack _fingerprint               # the Slack CLI the closure provisions
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
# The dependency closure, resolved by Homebrew rather than by this script: the
# controller declares 2lab-ai/tap/slack-cli, so installing the controller has to
# have put the official Slack CLI on this prefix's PATH.
[[ -x "$prefix/bin/slack" ]] \
  || fail "the controller's dependency closure did not put a slack executable on PATH"
[[ "$("$prefix/bin/slack" _fingerprint)" == "$SLACK_CLI_FINGERPRINT" ]] \
  || fail "the slack on this prefix's PATH is not the official Slack CLI"
[[ "$("$prefix/bin/somawork" --version)" == "$VERSION" ]] \
  || fail "the linked controller does not report the release version"

echo "somawork install harness: ok (isolated prefix $prefix)"
