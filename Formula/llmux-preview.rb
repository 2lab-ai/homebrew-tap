class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.15.0759"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0759-d36e6b4821ae/llmux-macos-aarch64"
      sha256 "e4857ed5d2dfbf5156f759a37dbc76a329d37dbbfb9e845a98171fd27c3118fb"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0759-d36e6b4821ae/llmux-macos-x86_64"
      sha256 "4ea60d3fcaec24befa5b0e0964e2a3e61721c25e710a9aafd3c3ccd0c36f8c10"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0759-d36e6b4821ae/llmux-linux-aarch64"
      sha256 "df2db0d34d26f3275b3478877afd00837ca0a0ccb6cd833e78b64ff7421011ab"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0759-d36e6b4821ae/llmux-linux-x86_64"
      sha256 "81663ddcb51a7e87ada10d9980ee11c8fe952ebe99a601ddf8407e084d6aca0b"
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
