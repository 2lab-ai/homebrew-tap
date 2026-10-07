class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.07.1210"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1210-1991a8bd5737/llmux-macos-aarch64"
      sha256 "cc5825e44097b765e11df644323e875c71dc50ae5235321c9927a1b7f9a98ea4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1210-1991a8bd5737/llmux-macos-x86_64"
      sha256 "ca2ea6a88e35677a7c995242248ebc4a658e0cfcb8d64b9b1e85da80ff89ce2a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1210-1991a8bd5737/llmux-linux-aarch64"
      sha256 "0f0686576194e62983526406e566b984fa7e77c9d3fea2fe73070e37f605defd"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1210-1991a8bd5737/llmux-linux-x86_64"
      sha256 "91269bae9f9b253e39da2c68462b4eab7ed585f688f8306f703c5803112acbd4"
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
