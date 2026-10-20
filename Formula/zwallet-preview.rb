class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.20.2311"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-20-2311-e17b2bebb0c8/zwallet-macos-aarch64"
      sha256 "5854a2406cd19d62aaf31a9a46a3c7cb021008332c732f6b8d86c985d3a3903a"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-20-2311-e17b2bebb0c8/zwallet-macos-x86_64"
      sha256 "fea58eb9f72d58f21403701a3c7e562ea2dc440d79edd3f5cdb1a1401dfa11bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-20-2311-e17b2bebb0c8/zwallet-linux-aarch64"
      sha256 "266b1947f227ff85cde5c70b27f77fefe925f1328063166a7dd12384566d78be"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-20-2311-e17b2bebb0c8/zwallet-linux-x86_64"
      sha256 "84f9439b5700302f3a31b5653590eeae7e71edf5840994098940b04767eaf37c"
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
