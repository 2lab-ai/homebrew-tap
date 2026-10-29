class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.29.0318"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-0318-51b4a51b4fae/zwallet-macos-aarch64"
      sha256 "00d28887d57e3790951a5debf44b9b61ce2b2a1d76f1ba2f9497c0e817c30994"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-0318-51b4a51b4fae/zwallet-macos-x86_64"
      sha256 "51f3f3ba4995e2cf878349749a0b4e8438dd948bbdfb7277f9159d0c5ac27c3b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-0318-51b4a51b4fae/zwallet-linux-aarch64"
      sha256 "7b56574fd66042f74ff9351ab38027ab13c9825aa50bc68cc1c8644b578491a2"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-29-0318-51b4a51b4fae/zwallet-linux-x86_64"
      sha256 "b57791758e8c5af85e768622476d044e0ea8ac1679f827862ebb81c84b50d5ec"
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
