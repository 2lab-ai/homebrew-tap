class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.16.1724"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-16-1724-b94ac65dc1e3/llmux-macos-aarch64"
      sha256 "92838e7fe0b5cefdbe71bec94ec9e4e5bedb402faff170d84ad123d07c90b5b2"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-16-1724-b94ac65dc1e3/llmux-macos-x86_64"
      sha256 "3128c9d62b300dfcda60c5878071cd08669f97900225d2bb0b98e323afa4d6cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-16-1724-b94ac65dc1e3/llmux-linux-aarch64"
      sha256 "f1a998fed4944268a03b003c57d88e558351ae455dc674239aa29cd07f94d561"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-16-1724-b94ac65dc1e3/llmux-linux-x86_64"
      sha256 "e6ddfcd6f06733a992940d09cce5193f77a861579895775db8f525552ac360e7"
    end
  end

  link_overwrite "bin/llmux"

  def install
    bin.install Dir["llmux-*"].first => "llmux"
  end

  test do
    assert_match "preview", shell_output("#{bin}/llmux --version")
  end
end
