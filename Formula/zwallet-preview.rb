class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.11.06.1823"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-1823-1bcb7cd9656d/zwallet-macos-aarch64"
      sha256 "462f0748f71900c07567ec69c991cb6a3ceed96e61bf0de2dc6520d080b9ef51"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-1823-1bcb7cd9656d/zwallet-macos-x86_64"
      sha256 "c02dd5d1e35f91ef95b54aac2c70ea798cd58dbaab40e8946d43f52849cea6e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-1823-1bcb7cd9656d/zwallet-linux-aarch64"
      sha256 "a751866c3e86e3d2338e7765e4369b3067d50de8e524d9096bd5b29990314ebf"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-1823-1bcb7cd9656d/zwallet-linux-x86_64"
      sha256 "c4295a2664db7879b5334da99b237fb6f52a8d124f1e8a4e7d7de48b7ab88817"
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
