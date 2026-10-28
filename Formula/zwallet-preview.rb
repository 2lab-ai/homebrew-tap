class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.28.0510"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-28-0510-9ecfe932b0fe/zwallet-macos-aarch64"
      sha256 "fc7f0130dc6211240a17adf124d1a2fd673570eb3529ccc316084eeead04adde"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-28-0510-9ecfe932b0fe/zwallet-macos-x86_64"
      sha256 "a0eb61914a7826d6b73a382a441a693c78d65018a0e2f99bcfa1edf15a1175db"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-28-0510-9ecfe932b0fe/zwallet-linux-aarch64"
      sha256 "8ba400952e157accf485b431a7d8418629c69962891a898bd81f549dac088843"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-28-0510-9ecfe932b0fe/zwallet-linux-x86_64"
      sha256 "ddd33864e9a81d6588ec764ed165bdc2f4c92f805d7d085cb72b382f4d6e6d2a"
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
