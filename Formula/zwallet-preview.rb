class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.29.0617"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-0617-99fff4eae7a9/zwallet-macos-aarch64"
      sha256 "c4d3717d0dbd56165e12ae882ff2ad8ceb3cd301c89ca5424f385f2ada535ef5"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-0617-99fff4eae7a9/zwallet-macos-x86_64"
      sha256 "e188e33b109fd5b2960dc84db80374f2cb60a25663893bc76a1df0fbe0f6a43d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-0617-99fff4eae7a9/zwallet-linux-aarch64"
      sha256 "a05a9ecabf71ed3e01f9ba5d1e0deb602ccf17431b0fcab0f1dece0e41f786ea"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-0617-99fff4eae7a9/zwallet-linux-x86_64"
      sha256 "7ce09df5ff0518d7a39fda68a05ab18e56791ec392273307dfd3518fce07f7ba"
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
