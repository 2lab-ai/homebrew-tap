class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.2/llmux-macos-aarch64"
      sha256 "8234622eac895a0c31665454f96ae7151fe05bc251ea61951fe21fbf5b4174d8"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.2/llmux-macos-x86_64"
      sha256 "60200d2f03994557700a91cb2b1a1b4de9e52b0517fcc1443fb558b2bcf020cd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.2/llmux-linux-aarch64"
      sha256 "d6d385e8e229df5d6b54a5a6ca5bbc7f7387e903b20b19a2af14cf34538cbb80"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.2/llmux-linux-x86_64"
      sha256 "83befb2960f8510c320ea8bb4b3e936eab0357332f85514ae8a21562b4260cef"
    end
  end

  link_overwrite "bin/llmux"

  def install
    bin.install Dir["llmux-*"].first => "llmux"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmux --version")
  end
end
