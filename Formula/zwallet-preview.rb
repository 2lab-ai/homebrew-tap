class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.27.1649"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-27-1649-50d3da4e08f1/zwallet-macos-aarch64"
      sha256 "68e2feb429881c50c4558fe1589ddf6598253377355c36cf31a1c55ba62c0c50"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-27-1649-50d3da4e08f1/zwallet-macos-x86_64"
      sha256 "2f734da7643ee8e7228f4ce331bdc785679da1db29c7dc7eb6d12914c4b76b75"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-27-1649-50d3da4e08f1/zwallet-linux-aarch64"
      sha256 "8d4ca901dd586e2f2c9ee4ee9345e18c3897ccb04862c808c42b5ee206c8fbd3"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-27-1649-50d3da4e08f1/zwallet-linux-x86_64"
      sha256 "a49e6514f81ca239c275f1bf801cb32906ea4e540c50022b75386b79edbf2821"
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
