class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.06.0501"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-06-0501-6184febb7d28/llmux-macos-aarch64"
      sha256 "39a8b38e35025342d514abfcfe26baa9e40a47ab686d280698536cb9ff83e5db"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-06-0501-6184febb7d28/llmux-macos-x86_64"
      sha256 "81302ae9c70f47fd1b33b3d306c3df0a412597a95508feead8ff01253668f8e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-06-0501-6184febb7d28/llmux-linux-aarch64"
      sha256 "0f8887f926e7fc41d2cc1b476498bd40b47e5120a14b24451b0df73686c910cb"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-06-0501-6184febb7d28/llmux-linux-x86_64"
      sha256 "e0aaad5a8b8891dcc63d212cbde9c5de782d5d21aec631fab6c25b56397d0f44"
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
