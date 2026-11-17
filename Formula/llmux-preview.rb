class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.17.1050"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-17-1050-b0d437aab7f3/llmux-macos-aarch64"
      sha256 "81865c43af2a0358d8adb0b46b145241c201aead9bd1a8fad39e7ac43a2edb0a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-17-1050-b0d437aab7f3/llmux-macos-x86_64"
      sha256 "e99c5ee1bc3e5e21fa904918cdd269a9cd6a9a457f7015a03c474766592f3779"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-17-1050-b0d437aab7f3/llmux-linux-aarch64"
      sha256 "f3dfe2f657161b4ca01118b9f9c904df376f5610eb1d9e70b51f6d8e81890619"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-17-1050-b0d437aab7f3/llmux-linux-x86_64"
      sha256 "58a89623a5aa571323e017d729498490afa18d7b547af35c8b4c42747109ae19"
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
