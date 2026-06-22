class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.22.0159"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-22-0159-7a04f4eeb6b4/llmux-macos-aarch64"
      sha256 "531d57b36fa47181183ec7f7def922a2750ddac08dcbc9898f5c48dd98830b1d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-22-0159-7a04f4eeb6b4/llmux-macos-x86_64"
      sha256 "d684a678013c638f011794e706ef84738ce12e2c7ef425ea7b542d0570dc5d44"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-22-0159-7a04f4eeb6b4/llmux-linux-aarch64"
      sha256 "be396d998350e3586efedd0c0fb4b8d693ac8acee99d95a9df809f112221b256"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-22-0159-7a04f4eeb6b4/llmux-linux-x86_64"
      sha256 "0824c541ab142a0d98f57831c0b0547bafe4c74f74766e503c546ab03d0a1687"
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
