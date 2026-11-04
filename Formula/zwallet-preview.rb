class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.11.03.2208"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-03-2208-846b08d1a8c3/zwallet-macos-aarch64"
      sha256 "524a315cd2970b221415e32126f6128e21595db4a7dea5f59873aaf6f907d36a"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-03-2208-846b08d1a8c3/zwallet-macos-x86_64"
      sha256 "57d649efb660a88c6d83fc600b5ccf80b5b6d8a8a5ad3e9ab28d772f31709b0f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-03-2208-846b08d1a8c3/zwallet-linux-aarch64"
      sha256 "782481d0d02ab739cbd6b7e94c1998d9e244e702f8ba229e18b923c29eaa5cc3"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-03-2208-846b08d1a8c3/zwallet-linux-x86_64"
      sha256 "e278c55234780bd906eb34c4fbd73adae7f96bb7aff207cd9cdc517fef64afcd"
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
