class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.17.0111"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-17-0111-50042b2a3de7/llmux-macos-aarch64"
      sha256 "e6b16410492c6c66a3bdca2845da5fe32324fe77db2256e3d689214074aa03e5"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-17-0111-50042b2a3de7/llmux-macos-x86_64"
      sha256 "840e3b7016a8d8e2cca21d84a761acb89edb3a963b869e51c337fbf0743dc109"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-17-0111-50042b2a3de7/llmux-linux-aarch64"
      sha256 "9d10c76945da2d1d887caf11498beb721ba8488116c23b51fdb8c1cf62591f34"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-17-0111-50042b2a3de7/llmux-linux-x86_64"
      sha256 "1eeedb5d184e33868006713c00023392464dad669105d05468d4fbca4fefb1a5"
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
