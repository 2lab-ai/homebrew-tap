class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.26.1119"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-26-1119-787a64002b76/zwallet-macos-aarch64"
      sha256 "00f7d93e404263ee81646fbdf0844ce632ab7bdf7b4e0f8e64909159addaf476"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-26-1119-787a64002b76/zwallet-macos-x86_64"
      sha256 "ded68e55dde67b46d2f1ab4ad71a1a89666589fdb1c207c646f15c703cc37ee3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-26-1119-787a64002b76/zwallet-linux-aarch64"
      sha256 "c0b1545d1be6cf27cbce0b92ee10543ff1434169dd7f805242c0e75de5d64d3d"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-26-1119-787a64002b76/zwallet-linux-x86_64"
      sha256 "a50a4f38ebe2967de196368d524d9bad27e887f09316268edc67a6777a8a0980"
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
