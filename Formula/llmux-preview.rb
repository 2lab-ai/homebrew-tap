class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.11.0852"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-0852-cd3d909a0e78/llmux-macos-aarch64"
      sha256 "a46ad00ea1045acc31473e0f1926d6df60ede0a6f997bfe6b89b89f868f82808"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-0852-cd3d909a0e78/llmux-macos-x86_64"
      sha256 "ad1e1d2ed0847db92180d29196b765a956942f2091599f492851fa352a7ff9d6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-0852-cd3d909a0e78/llmux-linux-aarch64"
      sha256 "cbd23780baa2137f3c01e9ec3814025e888890df36341f1a30bc0977bdc32ef2"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-0852-cd3d909a0e78/llmux-linux-x86_64"
      sha256 "674c0c8f75864f2abf4e558d0b8b89b25d1e38b4e2934dca077eb8f3c9ca8d72"
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
