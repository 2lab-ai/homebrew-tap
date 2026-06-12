class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.06.11.2357"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-11-929525382782/herdr-macos-aarch64"
      sha256 "eb60410e590fa478e1d0464b2f6a410fabf062b0a1ad86ef68157b73b2c2bd6b"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-11-929525382782/herdr-macos-x86_64"
      sha256 "8cdc4e1796398e495fa8a084b64c7c8bd2628ae32d546dfb6c2e7d2f17156317"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-11-929525382782/herdr-linux-aarch64"
      sha256 "2b8a23d55bd74bb7e2bb8029a681aee5c88941a4e4917c5ad345ed3c506d52d4"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-11-929525382782/herdr-linux-x86_64"
      sha256 "60d435f1a6961057faa9ce4949655d8b09338a853d2ea4050d15cd612520cccf"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
