class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.12.0447"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0447-358380480125/llmux-macos-aarch64"
      sha256 "fa28f63146e1bc61d50e1cceaa426d073b3464415739cec565ee064b0f43ee68"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0447-358380480125/llmux-macos-x86_64"
      sha256 "cd3e2e77047ea61d7b3107adffcac24e29c711f23ea22ccbadf396c8b0dfe8c0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0447-358380480125/llmux-linux-aarch64"
      sha256 "7a2a97a2a666241d2726087a15db672cc03d236340e64626e14ed0b113d3972f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0447-358380480125/llmux-linux-x86_64"
      sha256 "0c2b5eecb43004c9dd5a43e8ae00562dc1bfd71383c459aa4f487237d3eec0f4"
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
