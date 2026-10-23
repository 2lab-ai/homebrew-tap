class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.23.0722"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-23-0722-4f3b484f6ec2/zwallet-macos-aarch64"
      sha256 "25cf0d57a5dbb10855dbc1806720e75682e9f20a372474aed16e23952207f8c4"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-23-0722-4f3b484f6ec2/zwallet-macos-x86_64"
      sha256 "8044e5f28e76ba14cce24d0cfafec68858adb2b9a376051248a8794bde3335a4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-23-0722-4f3b484f6ec2/zwallet-linux-aarch64"
      sha256 "2cdbf24213daf8786385598dae066b154955ac1adfc0249893f59bc1a69d73e2"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-23-0722-4f3b484f6ec2/zwallet-linux-x86_64"
      sha256 "34e2d7f36340db1286fd1e9709c67716c7f6441587a6fb706a354e1986eb6b52"
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
