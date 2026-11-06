class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.11.06.1138"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-1138-36e848324dad/zwallet-macos-aarch64"
      sha256 "aea1991947e410d7ff8325a2125c0dba081621f235c9d1ab1eaf8873b2d4eaf2"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-1138-36e848324dad/zwallet-macos-x86_64"
      sha256 "0b024841c374e28a8892ed976e299b30337296d88ee9fc17c5af510f2187c434"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-1138-36e848324dad/zwallet-linux-aarch64"
      sha256 "dc39b9b262ca293bac421c5dc2cc4d266168a1b5420b2c6d5578a9d21ceaf83c"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-1138-36e848324dad/zwallet-linux-x86_64"
      sha256 "d30f0c413d9f3ee493118f076d033f823011acee5d12df17bca917cf04ef01f8"
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
