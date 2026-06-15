class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.15.0043"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-15-0043-d590f62cedc5/llmux-macos-aarch64"
      sha256 "6060f776ea20c9a8b52e9db0cd305a0a140b7c626d1a9b118efa1e69c222c4f7"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-15-0043-d590f62cedc5/llmux-macos-x86_64"
      sha256 "5f573ea0a78fc67766b3abeea28d691b92a1884db12a0590248e0f60d7d71394"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-15-0043-d590f62cedc5/llmux-linux-aarch64"
      sha256 "04f0db8650cf99cc8442ab806431a69306c4eaa3748b757d562ccf36784c5894"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-15-0043-d590f62cedc5/llmux-linux-x86_64"
      sha256 "6aa68eb6e2bd7f994c9d2898014b14d1f87579d2e7b39ff424a1515adb40a1c6"
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
