#!/usr/bin/env bash
#
# somawork preflight contract — the unprivileged payload verifier and the
# privileged proof validator, exercised over synthetic archives built here.
#
# Nothing in this file reaches the network, executes a release payload, or
# touches an installed Homebrew prefix. The archives are three tiny tarballs
# carrying the layout the manifest declares.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
verifier="$root/scripts/verify-somawork-assets.py"
validator="$root/scripts/validate-somawork-preflight.py"

TAG=somawork-preview-v1.0.0-987654321
SOURCE_SHA=0123456789abcdef0123456789abcdef01234567
VERSION=1.0.0
BASE="https://github.com/2lab-ai/soma-work/releases/download/$TAG"

fail() {
  echo "somawork preflight contract: $*" >&2
  exit 1
}

[[ -x "$verifier" ]] || fail "tracked executable payload verifier is missing"
[[ -x "$validator" ]] || fail "tracked executable proof validator is missing"

work="$(mktemp -d "${TMPDIR:-/tmp}/somawork-preflight.XXXXXX")"
trap 'rm -rf "$work"' EXIT HUP INT TERM
assets="$work/assets"
mkdir -p "$assets"

marker() {
  local package="$1" profile="$2"
  jq -n \
    --arg package "$package" --argjson profile "$profile" \
    --arg version "$VERSION" --arg source_sha "$SOURCE_SHA" '
      {
        schemaVersion: 1, package: $package, profile: $profile, channel: "preview",
        version: $version, sourceSha: $source_sha, platform: "darwin-arm64",
        layoutVersion: 1
      }'
}

build_controller() {
  local tree="$work/build/somawork-cli"
  rm -rf "$tree" && mkdir -p "$tree/libexec/bin"
  printf '#!/usr/bin/env node\nconsole.log("somawork controller");\n' >"$tree/libexec/bin/somawork"
  chmod 0755 "$tree/libexec/bin/somawork"
  jq -n --arg version "$VERSION" '
    {
      name: "somawork-cli", version: $version, description: "somawork controller CLI",
      private: true, bin: {somawork: "libexec/bin/somawork"}, engines: {node: ">=20.0.0"}
    }' >"$tree/package.json"
  marker somawork-cli null >"$tree/.somawork-package.json"
  ( cd "$tree" && tar -czf "$assets/somawork-cli-$VERSION-darwin-arm64.tar.gz" . )
}

build_runtime() {
  local package="$1" profile="$2"
  local tree="$work/build/$package"
  rm -rf "$tree" && mkdir -p "$tree/dist/cli" "$tree/node_modules/.bin"
  printf 'module.exports = {};\n' >"$tree/dist/cli/index.js"
  printf 'module.exports = {};\n' >"$tree/dist/index.js"
  printf 'module.exports = {};\n' >"$tree/dist/run-with-rotating-logs.js"
  printf '{}\n' >"$tree/config.default.json"
  jq -n --arg version "$VERSION" '{name: "soma-work", version: $version, private: true}' \
    >"$tree/package.json"
  # A relative symlink that stays inside the payload: npm workspaces produce
  # these, so the verifier has to accept them rather than refuse the archive.
  ln -s ../../dist/cli/index.js "$tree/node_modules/.bin/somawork-runtime"
  marker "$package" "\"$profile\"" >"$tree/.somawork-package.json"
  ( cd "$tree" && tar -czf "$assets/$package-$VERSION-darwin-arm64.tar.gz" . )
}

build_controller
build_runtime somawork production
build_runtime somawork-preview preview

asset_json() {
  local package="$1" profile="$2"
  local filename="$package-$VERSION-darwin-arm64.tar.gz"
  local path="$assets/$filename"
  jq -n \
    --arg package "$package" --argjson profile "$profile" \
    --arg filename "$filename" --arg url "$BASE/$filename" \
    --arg sha256 "$(shasum -a 256 "$path" | awk '{print $1}')" \
    --argjson bytes "$(wc -c <"$path" | tr -d ' ')" '
      {package: $package, profile: $profile, filename: $filename, url: $url,
       sha256: $sha256, bytes: $bytes}'
}

manifest="$work/somawork-manifest.json"
jq -n \
  --arg version "$VERSION" --arg tag "$TAG" --arg source_sha "$SOURCE_SHA" \
  --arg base "$BASE" \
  --slurpfile controller <(asset_json somawork-cli null) \
  --slurpfile production <(asset_json somawork '"production"') \
  --slurpfile preview <(asset_json somawork-preview '"preview"') '
    {
      schemaVersion: 1, layoutVersion: 1, channel: "preview", version: $version,
      tag: $tag, sourceSha: $source_sha, platform: "darwin-arm64",
      minimumNode: "20.0.0", baseUrl: $base,
      layout: {
        install: "prefix",
        controller: {entry: "libexec/bin/somawork", manifest: "package.json"},
        runtime: {
          marker: ".somawork-package.json", manifest: "package.json",
          controllerEntry: "dist/cli/index.js",
          supervisor: "dist/run-with-rotating-logs.js", daemon: "dist/index.js"
        }
      },
      assets: [$controller[0], $production[0], $preview[0]]
    }' >"$manifest"
manifest_sha256="$(shasum -a 256 "$manifest" | awk '{print $1}')"

# ---------------------------------------------------------------------------
# The unprivileged verifier measures and inspects; it never runs the payload.
# ---------------------------------------------------------------------------

proof="$work/somawork-tap-preflight.json"
GH_TOKEN=preflight-contract-sentinel \
GITHUB_TOKEN=preflight-contract-sentinel \
ACTIONS_RUNTIME_TOKEN=preflight-contract-sentinel \
  "$verifier" --manifest "$manifest" --assets-dir "$assets" --output "$proof" >/dev/null

jq -e '.schema == "somawork.tap-preflight.v1"' "$proof" >/dev/null \
  || fail "proof does not carry the expected schema"
jq -e '.assets | length == 3' "$proof" >/dev/null || fail "proof does not measure three assets"
jq -e '[.assets[].package] == ["somawork-cli", "somawork", "somawork-preview"]' "$proof" >/dev/null \
  || fail "proof does not preserve the manifest asset order"
jq -e '.assets[0].installable.entryMode == "0755"' "$proof" >/dev/null \
  || fail "proof does not measure the controller entry mode"
jq -e '[.assets[].installable.reservedTopLevelDirectories] | flatten | length == 0' "$proof" >/dev/null \
  || fail "proof does not record the absence of linkable top-level directories"
if grep -Fq preflight-contract-sentinel "$proof"; then
  fail "proof carries a token from the verifier environment"
fi

# The proof must not be overwritable: a second run into the same path fails.
if GH_TOKEN=x "$verifier" --manifest "$manifest" --assets-dir "$assets" --output "$proof" \
  >/dev/null 2>&1; then
  fail "verifier overwrote an existing proof"
fi

validate() {
  "$validator" \
    --manifest "$manifest" \
    --proof "$proof" \
    --expected-tag "$TAG" \
    --expected-package somawork-preview \
    --expected-source-repository 2lab-ai/soma-work \
    --expected-source-sha "$SOURCE_SHA" \
    --expected-manifest-url "$BASE/somawork-manifest.json" \
    --expected-manifest-sha256 "$manifest_sha256" \
    "$@"
}
validate >/dev/null || fail "the privileged validator rejected an honest proof"

# ---------------------------------------------------------------------------
# Tampering, on both sides of the privilege boundary
# ---------------------------------------------------------------------------

# Rejection is asserted with the reason, not just the exit code: several of
# these inputs are refused by more than one check, and a test that only looked
# at the status could not tell which one is still doing the work.
reject_verifier() {
  local label="${1:?label required}"
  local because="${2:?expected reason required}"
  shift 2
  local output="$work/rejected-proof.json"
  local stderr="$work/rejected-proof.err"
  rm -f "$output"
  if "$verifier" --manifest "$1" --assets-dir "${2:-$assets}" --output "$output" \
    >/dev/null 2>"$stderr"; then
    fail "verifier accepted $label"
  fi
  grep -Fq "$because" "$stderr" \
    || fail "verifier rejected $label for the wrong reason: $(cat "$stderr")"
  [[ -e "$output" ]] && fail "verifier wrote a proof while rejecting $label"
  return 0
}

mutated="$work/mutated-manifest.json"
jq '.assets[0].sha256 = "'"$(printf 'a%.0s' {1..64})"'"' "$manifest" >"$mutated"
reject_verifier "an asset digest that does not match the bytes" "archive digest disagrees" "$mutated"
jq '.assets[1].bytes = 1' "$manifest" >"$mutated"
reject_verifier "an asset byte count that does not match the bytes" "byte count disagrees" "$mutated"
jq '.layout.runtime.daemon = "dist/missing.js"' "$manifest" >"$mutated"
reject_verifier "a runtime archive missing a formula-required entry" "is missing dist/missing.js" "$mutated"
jq '.assets[2].profile = "production"' "$manifest" >"$mutated"
reject_verifier "a manifest that gives a runtime the wrong profile" "must install profile" "$mutated"

# The archive, not the manifest: a preview tarball whose own marker claims the
# production profile would install a production runtime into the preview keg.
lying="$work/lying"
mkdir -p "$lying/assets"
cp -R "$work/build/somawork-preview" "$lying/build"
marker somawork-preview '"production"' >"$lying/build/.somawork-package.json"
( cd "$lying/build" && tar -czf "$lying/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" . )
cp "$assets/somawork-cli-$VERSION-darwin-arm64.tar.gz" \
  "$assets/somawork-$VERSION-darwin-arm64.tar.gz" "$lying/assets/"
lying_manifest="$lying/somawork-manifest.json"
jq --arg sha "$(shasum -a 256 "$lying/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" | awk '{print $1}')" \
  --argjson bytes "$(wc -c <"$lying/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" | tr -d ' ')" \
  '.assets[2].sha256 = $sha | .assets[2].bytes = $bytes' "$manifest" >"$lying_manifest"
reject_verifier "a runtime archive whose marker contradicts the manifest profile" \
  "release marker disagrees" "$lying_manifest" "$lying/assets"

# The controller's own package.json has to point `somawork` at the entry the
# formula symlinks; otherwise the linked command resolves to nothing.
crooked="$work/crooked"
mkdir -p "$crooked/assets"
cp -R "$work/build/somawork-cli" "$crooked/build"
jq '.bin.somawork = "libexec/bin/other"' "$crooked/build/package.json" >"$crooked/build/package.json.new"
mv "$crooked/build/package.json.new" "$crooked/build/package.json"
( cd "$crooked/build" && tar -czf "$crooked/assets/somawork-cli-$VERSION-darwin-arm64.tar.gz" . )
cp "$assets/somawork-$VERSION-darwin-arm64.tar.gz" \
  "$assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" "$crooked/assets/"
crooked_manifest="$crooked/somawork-manifest.json"
jq --arg sha "$(shasum -a 256 "$crooked/assets/somawork-cli-$VERSION-darwin-arm64.tar.gz" | awk '{print $1}')" \
  --argjson bytes "$(wc -c <"$crooked/assets/somawork-cli-$VERSION-darwin-arm64.tar.gz" | tr -d ' ')" \
  '.assets[0].sha256 = $sha | .assets[0].bytes = $bytes' "$manifest" >"$crooked_manifest"
reject_verifier "a controller whose package.json points somawork elsewhere" \
  "does not point somawork at the entry" "$crooked_manifest" "$crooked/assets"
jq '.version = "9.9.9" | .assets[].filename |= sub("1\\.0\\.0"; "9.9.9") | .assets[].url |= sub("1\\.0\\.0"; "9.9.9")' \
  "$manifest" >"$mutated"
reject_verifier "a rewritten asset URL" "URL is not the immutable release URL" "$mutated"

# An archive that would collide with Homebrew's link tree.
hostile="$work/hostile"
mkdir -p "$hostile/assets" "$hostile/build/bin" "$hostile/build/dist/cli"
cp -R "$work/build/somawork-preview/." "$hostile/build/"
printf 'no\n' >"$hostile/build/bin/somawork"
( cd "$hostile/build" && tar -czf "$hostile/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" . )
cp "$assets/somawork-cli-$VERSION-darwin-arm64.tar.gz" \
  "$assets/somawork-$VERSION-darwin-arm64.tar.gz" "$hostile/assets/"
hostile_manifest="$hostile/somawork-manifest.json"
jq --arg sha "$(shasum -a 256 "$hostile/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" | awk '{print $1}')" \
  --argjson bytes "$(wc -c <"$hostile/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" | tr -d ' ')" \
  '.assets[2].sha256 = $sha | .assets[2].bytes = $bytes' "$manifest" >"$hostile_manifest"
reject_verifier "a runtime archive carrying a linkable bin/ directory" "Homebrew-linkable directories: bin" "$hostile_manifest" "$hostile/assets"

# A path-escaping archive member.
escape="$work/escape"
mkdir -p "$escape/assets"
python3 - "$escape/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" <<'PY'
import io, sys, tarfile
with tarfile.open(sys.argv[1], "w:gz") as archive:
    payload = b"escaped\n"
    info = tarfile.TarInfo("../escaped.js")
    info.size = len(payload)
    archive.addfile(info, io.BytesIO(payload))
PY
cp "$assets/somawork-cli-$VERSION-darwin-arm64.tar.gz" \
  "$assets/somawork-$VERSION-darwin-arm64.tar.gz" "$escape/assets/"
escape_manifest="$escape/somawork-manifest.json"
jq --arg sha "$(shasum -a 256 "$escape/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" | awk '{print $1}')" \
  --argjson bytes "$(wc -c <"$escape/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" | tr -d ' ')" \
  '.assets[2].sha256 = $sha | .assets[2].bytes = $bytes' "$manifest" >"$escape_manifest"
reject_verifier "an archive member that escapes the extraction root" "member name is unsafe" "$escape_manifest" "$escape/assets"

# A member name Python's own extraction filters consider ordinary but this
# script does not: a backslash is a legal POSIX filename byte and a path
# separator everywhere the extracted tree might later be read.
odd="$work/odd"
mkdir -p "$odd/assets"
python3 - "$odd/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" <<'PY2'
import io, sys, tarfile
with tarfile.open(sys.argv[1], "w:gz") as archive:
    payload = b"odd\n"
    info = tarfile.TarInfo("dist\\..\\escape.js")
    info.size = len(payload)
    archive.addfile(info, io.BytesIO(payload))
PY2
cp "$assets/somawork-cli-$VERSION-darwin-arm64.tar.gz" \
  "$assets/somawork-$VERSION-darwin-arm64.tar.gz" "$odd/assets/"
odd_manifest="$odd/somawork-manifest.json"
jq --arg sha "$(shasum -a 256 "$odd/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" | awk '{print $1}')" \
  --argjson bytes "$(wc -c <"$odd/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" | tr -d ' ')" \
  '.assets[2].sha256 = $sha | .assets[2].bytes = $bytes' "$manifest" >"$odd_manifest"
reject_verifier "an archive member carrying a path separator this tap does not accept" \
  "member name is unsafe" "$odd_manifest" "$odd/assets"

# ---------------------------------------------------------------------------
# One hostile archive per member-level defence
#
# Each of these is a valid release payload with exactly one thing wrong, so
# deleting the single check that catches it makes the verifier accept the
# archive — or refuse it for a different reason, which the reason assertion also
# catches. Nothing here leans on Python's own extraction filter to do the work:
# where the filter would also object, the message it produces is not the message
# asserted.
# ---------------------------------------------------------------------------

hostile_assets() {
  local name="${1:?name required}"
  local dir="$work/hostile-$name"
  rm -rf "$dir"
  mkdir -p "$dir/assets"
  printf '%s' "$dir"
}

# Copy the two archives this case is not attacking, then restate the manifest
# with the hostile archive's real size and digest, so the only thing under test
# is the archive's contents.
hostile_manifest() {
  local dir="${1:?dir required}" index="${2:?index required}" package="${3:?package required}"
  local other
  for other in somawork-cli somawork somawork-preview; do
    [[ "$other" == "$package" ]] && continue
    cp "$assets/$other-$VERSION-darwin-arm64.tar.gz" "$dir/assets/"
  done
  local archive="$dir/assets/$package-$VERSION-darwin-arm64.tar.gz"
  jq --argjson i "$index" \
    --arg sha "$(shasum -a 256 "$archive" | awk '{print $1}')" \
    --argjson bytes "$(wc -c <"$archive" | tr -d ' ')" \
    '.assets[$i].sha256 = $sha | .assets[$i].bytes = $bytes' \
    "$manifest" >"$dir/somawork-manifest.json"
  printf '%s' "$dir/somawork-manifest.json"
}

# A fresh copy of the good preview runtime tree, to be spoiled one way.
hostile_runtime_tree() {
  local dir="${1:?dir required}"
  cp -R "$work/build/somawork-preview" "$dir/tree"
  printf '%s' "$dir/tree"
}

pack() {
  local tree="${1:?tree required}" archive="${2:?archive required}"
  # `--no-xattrs`: bsdtar warns on stderr when it cannot carry extended
  # attributes for a FIFO, and a noisy gate is a gate people stop reading.
  ( cd "$tree" && COPYFILE_DISABLE=1 tar --no-xattrs -czf "$archive" . )
}

# 1. An absolute member path. Written with `tarfile` because `tar` will not
#    produce one from a real tree.
dir="$(hostile_assets absolute)"
python3 - "$dir/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz" <<'PY'
import io, sys, tarfile
with tarfile.open(sys.argv[1], "w:gz") as archive:
    payload = b"absolute\n"
    info = tarfile.TarInfo("/etc/somawork-escape")
    info.size = len(payload)
    archive.addfile(info, io.BytesIO(payload))
PY
reject_verifier "an archive member with an absolute path" "member name is unsafe" \
  "$(hostile_manifest "$dir" 2 somawork-preview)" "$dir/assets"

# 2. A hard link. `ln` makes a real one; bsdtar records the second entry as a
#    link rather than a second copy.
dir="$(hostile_assets hardlink)"
tree="$(hostile_runtime_tree "$dir")"
ln "$tree/dist/index.js" "$tree/dist/index-hardlink.js"
pack "$tree" "$dir/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz"
reject_verifier "an archive carrying a hard link" "carries a hard link" \
  "$(hostile_manifest "$dir" 2 somawork-preview)" "$dir/assets"

# 3. A setuid member. The extractor normalizes modes, so nothing downstream would
#    ever notice this one — the refusal is the only thing that sees it.
dir="$(hostile_assets setuid)"
tree="$(hostile_runtime_tree "$dir")"
chmod 4755 "$tree/dist/index.js"
pack "$tree" "$dir/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz"
reject_verifier "an archive carrying a setuid member" "carries a setuid or setgid member" \
  "$(hostile_manifest "$dir" 2 somawork-preview)" "$dir/assets"

# 3b. …and setgid, which is the same bit pair and the same one-line check.
dir="$(hostile_assets setgid)"
tree="$(hostile_runtime_tree "$dir")"
chmod 2755 "$tree/dist/index.js"
pack "$tree" "$dir/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz"
reject_verifier "an archive carrying a setgid member" "carries a setuid or setgid member" \
  "$(hostile_manifest "$dir" 2 somawork-preview)" "$dir/assets"

# 4. A symlink pointing out of the tree. In-tree symlinks are accepted (the good
#    fixture has one), so this is the escape specifically.
dir="$(hostile_assets escaping-symlink)"
tree="$(hostile_runtime_tree "$dir")"
ln -s ../../../../etc/passwd "$tree/dist/escape.js"
pack "$tree" "$dir/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz"
reject_verifier "an archive carrying a symlink out of the tree" \
  "carries a symlink that escapes the tree" \
  "$(hostile_manifest "$dir" 2 somawork-preview)" "$dir/assets"

# 5. A FIFO. `mkfifo` needs no privilege, and Python's `tar` filter would extract
#    it happily.
dir="$(hostile_assets fifo)"
tree="$(hostile_runtime_tree "$dir")"
mkfifo "$tree/dist/pipe"
pack "$tree" "$dir/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz"
reject_verifier "an archive carrying a FIFO" "carries a device or FIFO member" \
  "$(hostile_manifest "$dir" 2 somawork-preview)" "$dir/assets"

# 6. A top-level entry the formula's own install glob cannot see. `Dir["*"]`
#    misses it and `Dir[".[^.]*"]` misses it, so it would be left behind in the
#    build directory with nothing reporting that it had been.
dir="$(hostile_assets unreachable-entry)"
tree="$(hostile_runtime_tree "$dir")"
mkdir "$tree/..stash"
printf 'left behind\n' >"$tree/..stash/payload.js"
pack "$tree" "$dir/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz"
reject_verifier "an archive with a top-level entry the install glob cannot reach" \
  "top-level entry the formula would not install" \
  "$(hostile_manifest "$dir" 2 somawork-preview)" "$dir/assets"

# 7. A payload Homebrew would re-root. One non-dot top-level entry, and it is a
#    directory, so `AbstractFileDownloadStrategy#chdir` descends into it and
#    `prefix.install Dir["*"]` would install its contents a level too high.
dir="$(hostile_assets re-root)"
mkdir -p "$dir/tree/somawork-$VERSION"
cp -R "$work/build/somawork-preview/." "$dir/tree/somawork-$VERSION/"
pack "$dir/tree" "$dir/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz"
reject_verifier "an archive Homebrew would re-root into its single directory" \
  "re-rooted by Homebrew into a single top-level directory" \
  "$(hostile_manifest "$dir" 2 somawork-preview)" "$dir/assets"

# 7b. The subtler shape: a real top-level tree whose only *visible* entry is a
#     directory, because the rest are dotfiles. Same re-root, same refusal.
dir="$(hostile_assets re-root-dotfiles)"
mkdir -p "$dir/tree/dist/cli"
cp "$work/build/somawork-preview/dist/cli/index.js" "$dir/tree/dist/cli/"
cp "$work/build/somawork-preview/dist/index.js" \
  "$work/build/somawork-preview/dist/run-with-rotating-logs.js" "$dir/tree/dist/"
cp "$work/build/somawork-preview/package.json" "$dir/tree/.package.json"
cp "$work/build/somawork-preview/.somawork-package.json" "$dir/tree/"
pack "$dir/tree" "$dir/assets/somawork-preview-$VERSION-darwin-arm64.tar.gz"
reject_verifier "an archive whose only visible top-level entry is a directory" \
  "re-rooted by Homebrew into a single top-level directory" \
  "$(hostile_manifest "$dir" 2 somawork-preview)" "$dir/assets"

# 8. A controller whose entry is not executable. The formula symlinks it onto
#    PATH, and nothing downstream would notice: the proof's `"entryMode"` is a
#    literal the validator re-derives, so only this check sees it.
dir="$(hostile_assets unexecutable-controller)"
cp -R "$work/build/somawork-cli" "$dir/tree"
chmod 0644 "$dir/tree/libexec/bin/somawork"
pack "$dir/tree" "$dir/assets/somawork-cli-$VERSION-darwin-arm64.tar.gz"
reject_verifier "a controller whose entry is not executable" \
  "controller entry is not executable" \
  "$(hostile_manifest "$dir" 0 somawork-cli)" "$dir/assets"

# The privileged side refuses a proof that disagrees with the manifest.
# Same rule as `reject_verifier`: the refusal has to be the one the case is for.
# The validator refuses most bad input twice — once by name and once through the
# whole-document comparison — so a helper that only looked at the exit status
# would let the named check be deleted without noticing.
reject_validator() {
  local label="${1:?label required}"
  local because="${2:?expected reason required}"
  shift 2
  local stderr="$work/rejected-validator.err"
  if "$@" >/dev/null 2>"$stderr"; then
    fail "validator accepted $label"
  fi
  grep -Fq "$because" "$stderr" \
    || fail "validator rejected $label for the wrong reason: $(cat "$stderr")"
  return 0
}

tampered_proof="$work/tampered-proof.json"
jq '.assets[0].sha256 = "'"$(printf 'b%.0s' {1..64})"'"' "$proof" >"$tampered_proof"
reject_validator "a proof whose measurement was edited" \
  "the preflight proof disagrees with the manifest" \
  "$validator" --manifest "$manifest" --proof "$tampered_proof" \
  --expected-tag "$TAG" --expected-package somawork-preview \
  --expected-source-repository 2lab-ai/soma-work --expected-source-sha "$SOURCE_SHA" \
  --expected-manifest-url "$BASE/somawork-manifest.json" \
  --expected-manifest-sha256 "$manifest_sha256"

jq '.assets[2].installable.markerProfile = "production"' "$proof" >"$tampered_proof"
reject_validator "a proof whose profile receipt was edited" \
  "the preflight proof disagrees with the manifest" \
  "$validator" --manifest "$manifest" --proof "$tampered_proof" \
  --expected-tag "$TAG" --expected-package somawork-preview \
  --expected-source-repository 2lab-ai/soma-work --expected-source-sha "$SOURCE_SHA" \
  --expected-manifest-url "$BASE/somawork-manifest.json" \
  --expected-manifest-sha256 "$manifest_sha256"

# The re-root finding is one the validator cannot re-measure — it only has the
# manifest — so it insists on the value instead, by name and not only through the
# deep comparison. A proof claiming Homebrew would re-root is refused for that
# reason.
jq '.assets[2].installable.reRootsOnInstall = true' "$proof" >"$tampered_proof"
reroot_error="$work/reroot.err"
if "$validator" --manifest "$manifest" --proof "$tampered_proof" \
  --expected-tag "$TAG" --expected-package somawork-preview \
  --expected-source-repository 2lab-ai/soma-work --expected-source-sha "$SOURCE_SHA" \
  --expected-manifest-url "$BASE/somawork-manifest.json" \
  --expected-manifest-sha256 "$manifest_sha256" >/dev/null 2>"$reroot_error"; then
  fail "validator accepted a proof admitting Homebrew would re-root the archive"
fi
grep -Fq "archive Homebrew would re-root" "$reroot_error" \
  || fail "validator refused a re-rooting proof for the wrong reason: $(cat "$reroot_error")"

reject_validator "a dispatch digest that does not match the manifest bytes" \
  "manifest bytes disagree with the dispatched SHA-256" \
  "$validator" --manifest "$manifest" --proof "$proof" \
  --expected-tag "$TAG" --expected-package somawork-preview \
  --expected-source-repository 2lab-ai/soma-work --expected-source-sha "$SOURCE_SHA" \
  --expected-manifest-url "$BASE/somawork-manifest.json" \
  --expected-manifest-sha256 "$(printf 'c%.0s' {1..64})"

reject_validator "a source commit the dispatch did not resolve" \
  "manifest source SHA disagrees with the resolved release commit" \
  "$validator" --manifest "$manifest" --proof "$proof" \
  --expected-tag "$TAG" --expected-package somawork-preview \
  --expected-source-repository 2lab-ai/soma-work \
  --expected-source-sha ffffffffffffffffffffffffffffffffffffffff \
  --expected-manifest-url "$BASE/somawork-manifest.json" \
  --expected-manifest-sha256 "$manifest_sha256"

# The dispatch-package/channel bind, head-on and in both directions. This is the
# validator's copy of the rule the renderer also enforces; in the real workflow
# it runs first, so if it is the one that goes missing the renderer is the only
# thing left between a preview release and the stable formula.
reject_validator "a real preview release dispatched as the stable package" \
  "dispatch package does not match the manifest channel" \
  "$validator" --manifest "$manifest" --proof "$proof" \
  --expected-tag "$TAG" --expected-package somawork \
  --expected-source-repository 2lab-ai/soma-work --expected-source-sha "$SOURCE_SHA" \
  --expected-manifest-url "$BASE/somawork-manifest.json" \
  --expected-manifest-sha256 "$manifest_sha256"

# The mirror needs a stable-channel release to dispatch, so build one from the
# same measured payload: same archives, same digests, stable channel and a stable
# tag. The proof is the one the verifier produced, which is what makes this the
# validator's own bind under test rather than a manifest-shape rejection.
STABLE_TAG=somawork-v$VERSION-987654322
STABLE_BASE="https://github.com/2lab-ai/soma-work/releases/download/$STABLE_TAG"
stable_manifest="$work/stable-manifest.json"
jq --arg tag "$STABLE_TAG" --arg base "$STABLE_BASE" '
    .channel = "stable" | .tag = $tag | .baseUrl = $base
    | .assets = [.assets[] | .url = ($base + "/" + .filename)]' \
  "$manifest" >"$stable_manifest"
stable_manifest_sha256="$(shasum -a 256 "$stable_manifest" | awk '{print $1}')"
reject_validator "a real stable release dispatched as the preview package" \
  "dispatch package does not match the manifest channel" \
  "$validator" --manifest "$stable_manifest" --proof "$proof" \
  --expected-tag "$STABLE_TAG" --expected-package somawork-preview \
  --expected-source-repository 2lab-ai/soma-work --expected-source-sha "$SOURCE_SHA" \
  --expected-manifest-url "$STABLE_BASE/somawork-manifest.json" \
  --expected-manifest-sha256 "$stable_manifest_sha256"

reject_validator "a foreign source repository" \
  "dispatch source repository is not the somawork project" \
  "$validator" --manifest "$manifest" --proof "$proof" \
  --expected-tag "$TAG" --expected-package somawork-preview \
  --expected-source-repository evil/soma-work --expected-source-sha "$SOURCE_SHA" \
  --expected-manifest-url "$BASE/somawork-manifest.json" \
  --expected-manifest-sha256 "$manifest_sha256"

ln -sf "$proof" "$work/linked-proof.json"
reject_validator "a symlinked proof" \
  "preflight proof must be a regular file, not a link" \
  "$validator" --manifest "$manifest" --proof "$work/linked-proof.json" \
  --expected-tag "$TAG" --expected-package somawork-preview \
  --expected-source-repository 2lab-ai/soma-work --expected-source-sha "$SOURCE_SHA" \
  --expected-manifest-url "$BASE/somawork-manifest.json" \
  --expected-manifest-sha256 "$manifest_sha256"

echo "somawork preflight contract: ok"
