class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.07.18.0951"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-18-0951-efbe88acfd70/herdr-macos-aarch64"
      sha256 "d874eaac9248abff96852da9347403efa9e8dab3e1dc86e5cfe4d83a54dc796e"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-18-0951-efbe88acfd70/herdr-macos-x86_64"
      sha256 "4573f15ff62f31da671340a2370fef2029e2963fc937dae2b80272aec948c152"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-18-0951-efbe88acfd70/herdr-linux-aarch64"
      sha256 "b58edccf7b522a16a0a1bca06738b9600b3f19ec3df4663fb8efda0bb700d178"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-18-0951-efbe88acfd70/herdr-linux-x86_64"
      sha256 "d37756dbaf14ff6e4ed3d1c544aaa18f0cd0a4ab9e086d40b2da957dc27fb000"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
