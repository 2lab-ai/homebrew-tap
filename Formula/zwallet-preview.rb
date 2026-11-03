class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.11.03.1955"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-03-1955-8eaf05155751/zwallet-macos-aarch64"
      sha256 "2106e4ce29b971cee355f3342c5b2f98f70405e7cac0f7bc6cea61ba7ec4be5f"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-03-1955-8eaf05155751/zwallet-macos-x86_64"
      sha256 "bb8ac8ef86506a8e44c30686c4927d7f239855e5be3bdea87eefcb8c2ef71a4b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-03-1955-8eaf05155751/zwallet-linux-aarch64"
      sha256 "d9b9cc9bfe765759b3f9d113a6d9e67f024236bc402f1c2b36b35a1a77761f47"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-11-03-1955-8eaf05155751/zwallet-linux-x86_64"
      sha256 "724113bb50cd56e87335621cea68075c5b777a9a0b2241d4dd21fbc3cc499348"
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
