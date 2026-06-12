class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.06.12.1559"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-12-1559-2df71bfa1968/herdr-macos-aarch64"
      sha256 "c9c04aeef5ef457474597e6c050b07d4eaa0fdc6b3859f65fe91ecdaa1f7e8e6"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-12-1559-2df71bfa1968/herdr-macos-x86_64"
      sha256 "a989a4f9004c02bff081ddd1fd538669795f6962e77958036ea97758c09b0b0c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-12-1559-2df71bfa1968/herdr-linux-aarch64"
      sha256 "1adadff57a3bee5451a10b116942a5433e61bcfa78ec5af852050ca8d37be617"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-12-1559-2df71bfa1968/herdr-linux-x86_64"
      sha256 "9156fad20026e12d6d4f4167faa69897d0b668471fda56f0a0010d39a2239e31"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
