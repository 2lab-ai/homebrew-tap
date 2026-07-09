class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.09.0749"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0749-9e33f525f822/llmux-macos-aarch64"
      sha256 "c2f12d759e31dbbf8ced6824d63009084c460451a7163caf3d0be6df4f06b494"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0749-9e33f525f822/llmux-macos-x86_64"
      sha256 "0d5db98eaeadc68c78aa42026a2513c7267e7e43cf7b55de342e2f3811ac5191"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0749-9e33f525f822/llmux-linux-aarch64"
      sha256 "81cce0e7c745634d410a03040817c9498cd2de9a600a47d24850cd72674067e6"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0749-9e33f525f822/llmux-linux-x86_64"
      sha256 "f53674cf6199eea2b43bda8731381f293788f82f8c8f5d3386409cba239c4e29"
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
