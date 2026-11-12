class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.12.0520"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0520-14b9f4c7c3e4/llmux-macos-aarch64"
      sha256 "2e9becc25eebbe3a960a0e0ce88703ba8185669113fd237ea71f56f7c0e2f78a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0520-14b9f4c7c3e4/llmux-macos-x86_64"
      sha256 "ff68df75a1a097e79daf6247ce536a55bac0c78782830a9203c337fc36c6e264"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0520-14b9f4c7c3e4/llmux-linux-aarch64"
      sha256 "93e2e22f5f60e9842ef1d9e4cb3e82de5089a338aff90ae9e83fa97d23f53366"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0520-14b9f4c7c3e4/llmux-linux-x86_64"
      sha256 "af26b81aa6fa6da3cbf3e9122e514bd6c2f0db8f6b2dff62e08e245507d0b4b4"
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
