class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.30.1133"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-30-1133-0994f9a64648/zwallet-macos-aarch64"
      sha256 "3c6855c4e36787ff155a352bc91c98e632f6ab654c725b087c93bde55a1423aa"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-30-1133-0994f9a64648/zwallet-macos-x86_64"
      sha256 "937c8d859671df75a0daaade137822ca0d85816a2d1bbf94fec7429786094c52"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-30-1133-0994f9a64648/zwallet-linux-aarch64"
      sha256 "d0a09e906052b6977da959a8f2fb81012b1e4f02019b356c1f774f79a11e4e25"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-30-1133-0994f9a64648/zwallet-linux-x86_64"
      sha256 "63a896c0fdc684fa7a6ce31a95d014b624d96d6da066630fd4f51d19c901c0ef"
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
