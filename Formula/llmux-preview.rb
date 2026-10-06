class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.06.0513"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-06-0513-4b3d4a4a0be8/llmux-macos-aarch64"
      sha256 "a199a80fc4e17644e91d03395873003c05953e53a9a8da9e76d1020ffb496089"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-06-0513-4b3d4a4a0be8/llmux-macos-x86_64"
      sha256 "8d0301d96ab516b81c0364739fe3f5d1a0f394890d1c70cd94eae1644b140283"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-06-0513-4b3d4a4a0be8/llmux-linux-aarch64"
      sha256 "97e616fa9124b098024b14e0cf476ed341c5f6c219f90ba4a86f34e5408bc90d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-06-0513-4b3d4a4a0be8/llmux-linux-x86_64"
      sha256 "88f5b59c53354f933f96edbbcc2cc5f95228e09d3e0656920419242650515a57"
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
