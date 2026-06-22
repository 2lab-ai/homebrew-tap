class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.22.0646"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-22-0646-86af158b2b72/llmux-macos-aarch64"
      sha256 "78cf0a316b19f1d2c1313497d6e735187da65e23e40a26e35290b9f29c33ff37"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-22-0646-86af158b2b72/llmux-macos-x86_64"
      sha256 "8fc42b05332d0c19e05dbd3ec408db504476acdbd059a8e56788ee099832f3bb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-22-0646-86af158b2b72/llmux-linux-aarch64"
      sha256 "4314daeb94578777204df90c53bf1b27e79c105111546a211e507f7a3eafda35"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-22-0646-86af158b2b72/llmux-linux-x86_64"
      sha256 "7486bdc4854448ca736dd9dd3b7f9cfc0e46de2497a0f388450925fb03d3087a"
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
