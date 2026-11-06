class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.11.06.2001"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-2001-2eab208ca1c7/zwallet-macos-aarch64"
      sha256 "2016b229670c3d60655d01c47775a8f6b3e0fa8252dc2707b1c209cb3e79660b"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-2001-2eab208ca1c7/zwallet-macos-x86_64"
      sha256 "f44c9876958c503b67ddf7c0987471d5af2f41acfc94e77f2976c65db2cf8acb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-2001-2eab208ca1c7/zwallet-linux-aarch64"
      sha256 "8841d5cc98b4f71cd8de9dc1f4118b2c48c2daeb283211686b0d3c2aecb8df39"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-2001-2eab208ca1c7/zwallet-linux-x86_64"
      sha256 "9090ba8eabdfc245b60c191c124a77a6b4d7bae75dc15c85e4efd89eeba6a611"
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
