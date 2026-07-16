class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.07.16.0938"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-16-0938-5802d6fafc54/herdr-macos-aarch64"
      sha256 "6c9f3849ac6ac48ab193fbee6e2b4788f28af25b3c2e0cd8bb9751d6c8c1fd67"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-16-0938-5802d6fafc54/herdr-macos-x86_64"
      sha256 "c91a2ae8049880a473f2a3b52332eced92cf3bc8cd245833d7817634733c9ac8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-16-0938-5802d6fafc54/herdr-linux-aarch64"
      sha256 "362a8034bd98c66ad89f223d4193059e455e7e19a0e857fee689ce11e31caaef"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-16-0938-5802d6fafc54/herdr-linux-x86_64"
      sha256 "8638268ae3d2df8664d8d35279497e2e66d8da4eb79bfe72216e53b70bb36c76"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
