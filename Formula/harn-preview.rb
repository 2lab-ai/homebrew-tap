class HarnPreview < Formula
  desc "Lists the harness an AI coding agent loads for a directory, reversibly"
  homepage "https://github.com/2lab-ai/harn"
  version "2026.10.13.0650"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-0650-79b3279e5c63/harn-macos-aarch64"
      sha256 "31fee222203b6fe3edde0e2afdabb33dc64ba013e2bbf479836b93706a0200cb"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-0650-79b3279e5c63/harn-macos-x86_64"
      sha256 "5d216b9a2dc87dc04eb39034f82f6e4aa571910b2658a3a71abc584955083da6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-0650-79b3279e5c63/harn-linux-aarch64"
      sha256 "9b7f016d4d29bbca89e57f42faea9a55dcc0eaf7a2e084ca3c94f74758c416df"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-0650-79b3279e5c63/harn-linux-x86_64"
      sha256 "e0f1118bc042a7a53742263860c3cf0fb731ce13f44634fc49480211837d7ee9"
    end
  end

  link_overwrite "bin/harn"

  def install
    bin.install Dir["harn-*"].first => "harn"
  end

  test do
    assert_match "preview", shell_output("#{bin}/harn --version")
  end
end
