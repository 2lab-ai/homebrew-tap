class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.06.12.0715"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-12-0715-363254ffc9df/herdr-macos-aarch64"
      sha256 "97c1d4c59c58fdc27720603e0e9572f5695a0494f39f315dba4c334ba8e5f857"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-12-0715-363254ffc9df/herdr-macos-x86_64"
      sha256 "669f4d2d825f3eb9e0de44c4c0bca6f5bb8938468b0c61751853d3906a9f2ad0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-12-0715-363254ffc9df/herdr-linux-aarch64"
      sha256 "1926152421d4527ed4de988e8ab9e640fc9e08c9048d0bf92b97d08136d8de39"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-12-0715-363254ffc9df/herdr-linux-x86_64"
      sha256 "8cd94518ba6bb87248714e7ddf1a2d5ab11a341580c3e20d92e3e9b499f4ad35"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
