class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.20.1328"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-20-1328-3cf50915b356/zwallet-macos-aarch64"
      sha256 "2776d10d26cb0dc5a5f957d51e1ef32685571c2e21161a8192a26f46ac433e5f"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-20-1328-3cf50915b356/zwallet-macos-x86_64"
      sha256 "d2dfc71cba7f6de6f94a82f0b09f23b191bb1c2c57359255e955f3242a50645a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-20-1328-3cf50915b356/zwallet-linux-aarch64"
      sha256 "b92e463cd6bf619a59a1514d26d832d6feaf653270692a3f6ff3ebd586d91f6d"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-20-1328-3cf50915b356/zwallet-linux-x86_64"
      sha256 "17eabd8505b3203f1925f0335457d4715efaecfd91cf505b713f1c7410772c40"
    end
  end

  link_overwrite "bin/zwallet"

  def install
    bin.install Dir["zwallet-*"].first => "zwallet"
  end

  test do
    assert_match "(preview ", shell_output("#{bin}/zwallet --version")
  end
end
