class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.06.11.1606"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-11-21b5cc546761/herdr-macos-aarch64"
      sha256 "808b1ea764f1337b5173c683605bc5c6dc7df10f2296579bd0d1d111669d09e4"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-11-21b5cc546761/herdr-macos-x86_64"
      sha256 "9cae01e609a6ed539dab193d2ccd08f00cb6c1b669cb19c88c69fd35c3cf5514"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-11-21b5cc546761/herdr-linux-aarch64"
      sha256 "68740774cb6cd5c4197e4d8ce8cb904c92fda7b8a590acd4937f54d2d64be371"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-11-21b5cc546761/herdr-linux-x86_64"
      sha256 "aade3275010b3e74628f076791ab2f7f86ff733f24c94a22f928e9ec565f239b"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
