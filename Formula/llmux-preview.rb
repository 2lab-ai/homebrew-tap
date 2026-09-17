class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.17.1006"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-17-1006-acc55d6480f7/llmux-macos-aarch64"
      sha256 "4be1abb5b4f37075929f01454063bd115bf796473f26dec771f39d4c2cdb7b7a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-17-1006-acc55d6480f7/llmux-macos-x86_64"
      sha256 "cc9626c4c50bd8c50ad43057d479df1816ffb00e33e65b4af760f63daf6bf37f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-17-1006-acc55d6480f7/llmux-linux-aarch64"
      sha256 "f3e551a42835b85c0ae2b1692852f2aecf8e920e1a2a86b985610ab942b14a10"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-17-1006-acc55d6480f7/llmux-linux-x86_64"
      sha256 "205831a34919aa19a3a24736cd74855378d2c6f347b822af6377aaf524a506c7"
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
