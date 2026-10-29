class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.29.2134"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-2134-599bde9ee211/zwallet-macos-aarch64"
      sha256 "becebcf6a52f274d63bff14e6b3bc2e95f50f8b68998922fe5408da77169ed66"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-2134-599bde9ee211/zwallet-macos-x86_64"
      sha256 "86ec321633f7c51b932dd5722a03e744aa5571927a92fb384db5ee2173a17b56"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-2134-599bde9ee211/zwallet-linux-aarch64"
      sha256 "b1c666e5db4cf172d952b295713ed623e86f35f1e14a593eda6447571ef20ed1"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-2134-599bde9ee211/zwallet-linux-x86_64"
      sha256 "19c3228c99740e00d335d79fca5b31d49144bce5d7f4f8eda560f094b2fe2412"
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
