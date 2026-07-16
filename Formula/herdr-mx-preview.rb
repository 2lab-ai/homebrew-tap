class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.07.16.1503"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-16-1503-f41af67a860d/herdr-macos-aarch64"
      sha256 "14cdacdd8102c3f274a6a76b6282c2962c9e744d2041155377cb705e20fa4cd1"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-16-1503-f41af67a860d/herdr-macos-x86_64"
      sha256 "06cd5c87d55e809a7933fe7b4bd57aa263309e8df71a2a4e85c0e8d15edc747f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-16-1503-f41af67a860d/herdr-linux-aarch64"
      sha256 "23dcc04cc3220da8f3736eb290a1422596f0ba180d66ccedec97be3fbc230976"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-16-1503-f41af67a860d/herdr-linux-x86_64"
      sha256 "14e664131bdba37c69e703ef9d8c9619e799b42df8b85488b566e79a724f3a5b"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
