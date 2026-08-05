class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.08.05.0653"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-05-0653-d5b76b9e2cf8/herdr-macos-aarch64"
      sha256 "ca9586fd6d60f95f725d96f8f02ec79348c4cc2eff81385b5379343b20a72017"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-05-0653-d5b76b9e2cf8/herdr-macos-x86_64"
      sha256 "4b52b34a24f37fff3915d461c2acc47bb58d646ac873a6291a744acd57e46444"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-05-0653-d5b76b9e2cf8/herdr-linux-aarch64"
      sha256 "2863c396b10c2b81dd896b1b9159f41b90f9f2151eb5cc82540040217d852eaf"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-05-0653-d5b76b9e2cf8/herdr-linux-x86_64"
      sha256 "caef6662cdbbe5d3cfe84c8f0db2b1b5567cdd53f71266b9c8e7b0c42dfd32a7"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
