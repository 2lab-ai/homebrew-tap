class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.30.0233"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-30-0233-6f1a2c91ab3a/zwallet-macos-aarch64"
      sha256 "82e149c88d42baf9f41a2a36dc004ca0eae0a7032e30f0058365d4217c306d8e"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-30-0233-6f1a2c91ab3a/zwallet-macos-x86_64"
      sha256 "637d75c5972b534a062a36d18484b43c653a4a5432ba6f41916f04ece88d1e01"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-30-0233-6f1a2c91ab3a/zwallet-linux-aarch64"
      sha256 "c3255a6a3a4c6571dd4769ece1690684ece121af78ab1c2a276d2c33f9baf78c"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-30-0233-6f1a2c91ab3a/zwallet-linux-x86_64"
      sha256 "48df1e0d668461ccfc83e5be955979e99ff493443f4ff7f08dd743e7cb18fe41"
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
