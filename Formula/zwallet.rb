class Zwallet < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/v0.1.0/zwallet-macos-aarch64"
      sha256 "3e892dd974110edd27a98cee3d4622c3a444fdb96257631c774eb30cc52fb7e3"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/v0.1.0/zwallet-macos-x86_64"
      sha256 "ccb4e0998344f9fb4a4f0f69b36814d924375bf0c6ad845b1bd285377f94e65e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/v0.1.0/zwallet-linux-aarch64"
      sha256 "8bc365232fb102ba3b737d51d8ee5a2afa672237a245bc324b392ad41e6c4681"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/v0.1.0/zwallet-linux-x86_64"
      sha256 "131109e6b98572058f484ad9209d1001efe35d8aea77f73c1dc2c637bac0cfc3"
    end
  end

  link_overwrite "bin/zwallet"

  def install
    bin.install Dir["zwallet-*"].first => "zwallet"
  end

  test do
    assert_match "zwallet #{version} (release ", shell_output("#{bin}/zwallet --version")
  end
end
