class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.11.10.1326"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-10-1326-988401889353/zwallet-macos-aarch64"
      sha256 "181eca0303b1ba819b9b9be73247360e6cd8d0177061c03e819179d7afeb4f46"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-10-1326-988401889353/zwallet-macos-x86_64"
      sha256 "a32d5ba9f03648ade6b3cf1862a1feeb07683d1e0f417f091b913b94172e7618"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-10-1326-988401889353/zwallet-linux-aarch64"
      sha256 "e63cd81d8dd835b4e4483338e4aea274eabe98799c20ea51762a8e318cb77098"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-10-1326-988401889353/zwallet-linux-x86_64"
      sha256 "b6cbf12d3e73815e36a2c5a7b4091d342fc4f20a43a129d4463d97973860b85f"
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
