class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.27.0628"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-27-0628-c7d3f1314e78/zwallet-macos-aarch64"
      sha256 "00e5d83fe4eb5f6e2fe974b00b479fc1e9bbd39f4451bf4a81e6a8514cfde677"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-27-0628-c7d3f1314e78/zwallet-macos-x86_64"
      sha256 "e5d97ff21ac631251ecb7ebb69cd5591473de6122082db3a7385dca509119afd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-27-0628-c7d3f1314e78/zwallet-linux-aarch64"
      sha256 "cd8024ca9a166e541885ec7998a37bb67560210bf3a5417f7fb1eb9aae5e5695"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-27-0628-c7d3f1314e78/zwallet-linux-x86_64"
      sha256 "8b0489177cbdc515ee306798dd128cc8752301cb013027185c08ae71d8c29790"
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
