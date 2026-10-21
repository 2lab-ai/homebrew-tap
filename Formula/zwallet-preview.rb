class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.21.0656"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-21-0656-436d5dcefe1c/zwallet-macos-aarch64"
      sha256 "09d6df6ca71af2d2834c84355c3d304b9345f153526888f129b55a66e8f3be1f"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-21-0656-436d5dcefe1c/zwallet-macos-x86_64"
      sha256 "d48528c1394c51c90728100a07b5d1108e8138e5109ad9ada225ceab9b5b266f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-21-0656-436d5dcefe1c/zwallet-linux-aarch64"
      sha256 "596a236433fc56064faced9fbfe61878551db266cb55d10d993ce299feed933f"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-21-0656-436d5dcefe1c/zwallet-linux-x86_64"
      sha256 "66372ab8eaab4eb77ca71d4ad4394e373f9f3f7a5267a0c4aab8ecd4bc2cae66"
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
