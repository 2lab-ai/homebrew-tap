class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.06.0704"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-0704-e30390b45483/llmux-macos-aarch64"
      sha256 "ff8bb0ba1104a57b8848c2b118b1161e5e6c09c9bdf81a499236e74a846f06e8"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-0704-e30390b45483/llmux-macos-x86_64"
      sha256 "eed6db0b905f6b489c042430dc958053029fdacc20d42f89e2a957b5bf25acd8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-0704-e30390b45483/llmux-linux-aarch64"
      sha256 "d9b2bf0faf99b0e2fe64d8771168a1dc918fe35bda73f22dc0c906bdb147fdd5"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-0704-e30390b45483/llmux-linux-x86_64"
      sha256 "3e4d013a11d3cf8593cfd9ff0d5b1135f578e485f31a8a218654712f5e5ccd8e"
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
