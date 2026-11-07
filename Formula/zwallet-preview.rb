class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.11.06.2120"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-2120-bb010db209d3/zwallet-macos-aarch64"
      sha256 "e8a48446cfb12163126fe138d856749386ca59eca2cbdddcd1ce9fa3d94f49b6"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-2120-bb010db209d3/zwallet-macos-x86_64"
      sha256 "b786db0fa6f604fd59d69460f4d13131b8b74f239524acf57de719c7e9e3df92"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-2120-bb010db209d3/zwallet-linux-aarch64"
      sha256 "5d76229a0a82fa76997bfa07ca1aa8160b5d7f6876b7ce6ece82d5ba07ce4a7e"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-06-2120-bb010db209d3/zwallet-linux-x86_64"
      sha256 "bcc7db63a9abafb5bdb35c59c58a8c8b4dd786f7ddc5704b05cf53a5abc8925d"
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
