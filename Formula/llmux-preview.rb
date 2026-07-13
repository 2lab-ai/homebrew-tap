class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.13.1253"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-1253-2131ccc15355/llmux-macos-aarch64"
      sha256 "d34cec01050470c1cdd2a8e6f7ff978c08da7ab12a520ea02afea63a286ee3b7"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-1253-2131ccc15355/llmux-macos-x86_64"
      sha256 "b2191e5cc1b325a6c4974eb52eb7b383317dbd905610b669a3cc072773bf1278"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-1253-2131ccc15355/llmux-linux-aarch64"
      sha256 "24915f7fd60d7d8bcd2e718965011a7c0f825a0ce6216867e96fad12226a35ba"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-1253-2131ccc15355/llmux-linux-x86_64"
      sha256 "58fd4eb30800bab862234a9a26edeedda5bf819e7b5001340d637a6b445e242c"
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
