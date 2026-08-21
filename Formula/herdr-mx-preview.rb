class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.08.21.1724"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-21-1724-f5993c8c8461/herdr-macos-aarch64"
      sha256 "ff421f7b9afae97af0aeadb081fd8e3f62c0dee2bc1b42d1efc119200da28356"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-21-1724-f5993c8c8461/herdr-macos-x86_64"
      sha256 "eebecacdf5f35160ada4d8518333f781c997274b70bb699a3e976884902c7ceb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-21-1724-f5993c8c8461/herdr-linux-aarch64"
      sha256 "c0542f45d00f83055b328bc6d509a9143671e96ed27e9172d711a1b7126ab388"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-21-1724-f5993c8c8461/herdr-linux-x86_64"
      sha256 "9d2da5000b5310ceea791e2ed0a255a54be9afa4a86ccb66157c5a9bfbd555ba"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
