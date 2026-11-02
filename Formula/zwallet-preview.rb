class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.11.02.0456"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-02-0456-7be8d518c5fd/zwallet-macos-aarch64"
      sha256 "22ecd70fa5c91da0d041cc2d4ece03694dd79cecc71d45c1b7b5bd7737cab882"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-02-0456-7be8d518c5fd/zwallet-macos-x86_64"
      sha256 "02234a995b910f3f6c9fc4d3b36d9120f5ac26a2b3920311b3a6137a4da7b28c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-02-0456-7be8d518c5fd/zwallet-linux-aarch64"
      sha256 "00d9b61e1964b1479fcad55bde9a01388f2cc3662f99a664ee8eefa95c568224"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-02-0456-7be8d518c5fd/zwallet-linux-x86_64"
      sha256 "982a3604f4e4bf17b25bfe591652f23269efa545b3daff6773032c31247ddef4"
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
