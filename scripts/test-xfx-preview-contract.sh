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
check(runs.include?("expected_names") || runs.include?("exact SHA256SUMS"),
      "job does not pin the SHA256SUMS entry set")
check(runs.include?("preview_version_gt"),
      "job has no numeric freshness comparator")
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

# ----------------------------------------------------------------- rendering --

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

sha_of() {
  awk -v name="$1" '{ file = $2; sub(/^\*/, "", file); if (file == name) print $1 }' \
    "$assets/SHA256SUMS"
}

formula="$work/xfx-preview.rb"
sed -e "s/@VERSION@/$version/g" \
    -e "s/@TAG@/$tag/g" \
    -e "s/@SOURCE_SHA@/$source_sha/g" \
    -e "s/@SOURCE_SHA12@/$source_sha12/g" \
    -e "s/@SHA_MACOS_AARCH64@/$(sha_of xfx-macos-aarch64)/" \
    -e "s/@SHA_MACOS_X86_64@/$(sha_of xfx-macos-x86_64)/" \
    -e "s/@SHA_LINUX_AARCH64@/$(sha_of xfx-linux-aarch64)/" \
    -e "s/@SHA_LINUX_X86_64@/$(sha_of xfx-linux-x86_64)/" \
    "$template" >"$formula"

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
