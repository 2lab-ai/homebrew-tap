class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.09.11.0302"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-09-11-0302-79803d1841bb/herdr-macos-aarch64"
      sha256 "42d2d4053193d5e8fd1744110c7716484ddb687490204e5b0ff35569983221a2"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-09-11-0302-79803d1841bb/herdr-macos-x86_64"
      sha256 "a15ab8115c39037269178e9e622f8447f186b38c127e5f5f44af7d13b12bb083"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-09-11-0302-79803d1841bb/herdr-linux-aarch64"
      sha256 "a6c6a63764da3fa7b19549fc83ec9a16ffb2ae26def6d39048397fc9557670ea"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-09-11-0302-79803d1841bb/herdr-linux-x86_64"
      sha256 "27045dae305766da61a63df1d12942fb1f3383dd1051067856b8fa389379268f"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
