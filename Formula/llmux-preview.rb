class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.04.0558"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-04-0558-4cc97acd45dc/llmux-macos-aarch64"
      sha256 "aee0efd9f9b0ad22d1e0e56697bc5f9f798a814d26904a7bc45df2c5b91ed946"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-04-0558-4cc97acd45dc/llmux-macos-x86_64"
      sha256 "660971f4a7a5e29ed66e29c2549c3ca5ac5dc896757cd43f04eaab66c221541f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-04-0558-4cc97acd45dc/llmux-linux-aarch64"
      sha256 "8010597f15b727019b41bafade4adcf88689be77ff81e507bb69c148ea5dddfc"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-04-0558-4cc97acd45dc/llmux-linux-x86_64"
      sha256 "6501904c75b412a0e7154f4d9de4286d45b2d443094415823f6e64da0bcccd05"
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
