class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.30.2026"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-2026-48a4d7dc07d6/llmux-macos-aarch64"
      sha256 "09a2ca982cc7ef488b3b4e19cf334ea72f2b8b254ae9d6d2c5b9ffad7a296ab0"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-2026-48a4d7dc07d6/llmux-macos-x86_64"
      sha256 "45c4656e2838d221cf432891b29388563178c951ffaa0afa20d0d68e76ca7719"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-2026-48a4d7dc07d6/llmux-linux-aarch64"
      sha256 "04a1898228de0005a8f0540fc93b4a85ada6ff622487401fdaa48188d66c9111"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-2026-48a4d7dc07d6/llmux-linux-x86_64"
      sha256 "7547ba1aa958938e6f980983e1eef794e0db2e164530b7aee3182d9c6cf52e3a"
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
