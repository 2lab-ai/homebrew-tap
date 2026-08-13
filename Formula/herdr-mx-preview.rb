class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.08.13.1540"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-13-1540-aa9f6e147582/herdr-macos-aarch64"
      sha256 "5a7b9d3843ceb4d63093eabd54f6f7cc242ab909d7f14276a7ef63ef791e7fae"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-13-1540-aa9f6e147582/herdr-macos-x86_64"
      sha256 "4e4e378919b055ce1a106eec32aa8c4b2afcf5c4384ae0bd84d513f068da4332"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-13-1540-aa9f6e147582/herdr-linux-aarch64"
      sha256 "b4488fd3b961a87f0c636814564afa80fc36f8e215e1eea2322d08165f563903"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-13-1540-aa9f6e147582/herdr-linux-x86_64"
      sha256 "91138d7920a5ff7330dcf56103bd2f73ca82843ecd161f7a1b1b61e89422a973"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
