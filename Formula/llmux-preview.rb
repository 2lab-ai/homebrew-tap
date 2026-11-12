class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.12.0540"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0540-b8a864fcf417/llmux-macos-aarch64"
      sha256 "7fc6197e167d72eb06dc80dd0f546063b066f8d89e86b44f0a9aa2fc58117606"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0540-b8a864fcf417/llmux-macos-x86_64"
      sha256 "16e126746c436dbd28597e44ecf0c9d16a0471afbc2c6fabe984f1806cfaa4fe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0540-b8a864fcf417/llmux-linux-aarch64"
      sha256 "a1fc94d6d503d042e9369e428d078ca6b7bd0cfd33fd447e0376b9b2adf6d7d2"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0540-b8a864fcf417/llmux-linux-x86_64"
      sha256 "79c17a90e9b34dd3c79c5f99ca749c079a633432f3eb1331aca73a1b1dccf994"
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
