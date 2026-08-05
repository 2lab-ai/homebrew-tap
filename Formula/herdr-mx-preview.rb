class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.08.05.0228"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-05-0228-287e67b28626/herdr-macos-aarch64"
      sha256 "37ddbf51536b36aa884bb28097b0b2a15039967dc94ddc4f7f60ef6754f10fa7"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-05-0228-287e67b28626/herdr-macos-x86_64"
      sha256 "59445f8656c750df180d29e465ef326ea4454d5508b2c79f92ec307764e3c3da"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-05-0228-287e67b28626/herdr-linux-aarch64"
      sha256 "71808ab41cc4f7bf519c995d2abe4f948a0e4c025b23caa25e60689ed01d3406"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-05-0228-287e67b28626/herdr-linux-x86_64"
      sha256 "ba6ec1360b62d62c46213964fa42b7524a3d44a1913f332539b1e29303a4ead9"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
