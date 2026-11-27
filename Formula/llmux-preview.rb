class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.27.0603"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0603-8b2d7860a912/llmux-macos-aarch64"
      sha256 "c51111a3e974c155629e1b3e3dc7e0d0f74bb73260c63f83360d9faae56c204f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0603-8b2d7860a912/llmux-macos-x86_64"
      sha256 "7fa32cade2a7e9e2d19e51651a09ae19378f0f4900824143a5f70f066c0517f8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0603-8b2d7860a912/llmux-linux-aarch64"
      sha256 "0ce475bfda9991badc0d1e49975ebf3404205ce0d20a7093affbd0939167debb"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0603-8b2d7860a912/llmux-linux-x86_64"
      sha256 "fa8c09b7e8ab0f9d3a1964d6d795bcbbc3f120cf04e66c161e90601a164801d7"
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
