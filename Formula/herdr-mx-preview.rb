class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.07.27.0419"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-27-0419-e4ab803575e3/herdr-macos-aarch64"
      sha256 "89c30a43129999063890fb041f7d9f3979bf735c1b4bc215419e4077d71e8613"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-27-0419-e4ab803575e3/herdr-macos-x86_64"
      sha256 "644c0489327d412c48662e3b2d9b8b19b6fbeefb25c1c4fd8d6860e4cb5b8679"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-27-0419-e4ab803575e3/herdr-linux-aarch64"
      sha256 "eea888a186cc65cf49bb44137083935ca8056e3ef1558a5587db01f7748a1b18"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-27-0419-e4ab803575e3/herdr-linux-x86_64"
      sha256 "bcc200bb29c2848c2285b60f0544e60a1d8fca14bb2088e62f75e5bc9e8835f8"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
