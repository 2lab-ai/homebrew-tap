class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.29.2315"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-2315-d6fb99db6469/zwallet-macos-aarch64"
      sha256 "443a3850d7e1071917d4d08a55239012eb6626e0546a6417a72a8daae1cc329b"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-2315-d6fb99db6469/zwallet-macos-x86_64"
      sha256 "fdade1ea44c3f076feec14f4c7d6719986910a960c0ad47061d4031af09004db"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-2315-d6fb99db6469/zwallet-linux-aarch64"
      sha256 "ad5db641968ecb1c1241e294c4aa699eacb525145145adca30bc47e882e063a7"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-2315-d6fb99db6469/zwallet-linux-x86_64"
      sha256 "0c66a1d2a46df94bbd8fd72d7b3c202dbd263bebda02cc2138b242841095cd57"
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
