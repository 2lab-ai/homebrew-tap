class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.21.0406"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-21-0406-e5ae1d25e958/zwallet-macos-aarch64"
      sha256 "673b022d740032e79f2e4677ccefe210902d5af12feaa532c97847ba4c411e70"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-21-0406-e5ae1d25e958/zwallet-macos-x86_64"
      sha256 "1a928fbb57b515fa1d5fd6e3f7ebe448c0639e21488478277646712831659eb6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-21-0406-e5ae1d25e958/zwallet-linux-aarch64"
      sha256 "1a1a38d3cbad24634f35f9b89fb4e45ad2ffa6d7b25daa35f9cc1c112a5fe39d"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-21-0406-e5ae1d25e958/zwallet-linux-x86_64"
      sha256 "743efe8291aca5eb0dac618ebe0c1df9bb565a4cf2d588d7964eb9a87b7b6a97"
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
