class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.27.0200"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-27-0200-f4c88b382c93/zwallet-macos-aarch64"
      sha256 "35e348853842a4356dc73e0158e5178df5e6639cef69b0231270f94795f05277"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-27-0200-f4c88b382c93/zwallet-macos-x86_64"
      sha256 "8acd53442f84831812ad4881f8eb2f3809979d87b67d8696fb0c39ca4c02dd81"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-27-0200-f4c88b382c93/zwallet-linux-aarch64"
      sha256 "d5d9777101cb6840ac370f53666738835082255ede2a690f362ebd8b28f332f8"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-27-0200-f4c88b382c93/zwallet-linux-x86_64"
      sha256 "b36c2477ff89b4643c9f510f7efeacd57c46bb8249869ebd2e5946f180c1e703"
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
