class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.12.0738"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0738-dbe8401f1050/llmux-macos-aarch64"
      sha256 "0019508d5d8986bf494649ed98b4eaf32d78a76fb39146a71688973051b24e60"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0738-dbe8401f1050/llmux-macos-x86_64"
      sha256 "2a1b3bbd9a2a07ee9dbe81ae52c0fac7ba48b4193c00522cd6fe9f523e77171d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0738-dbe8401f1050/llmux-linux-aarch64"
      sha256 "a5ef50154eaffa398fc86c08eaaad05ba33c164c71a3f590389f99ee84d2cb43"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0738-dbe8401f1050/llmux-linux-x86_64"
      sha256 "808dbef80237261df669c53f21f4e12d0e28ae2d5b137b8618f51880176f623f"
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
