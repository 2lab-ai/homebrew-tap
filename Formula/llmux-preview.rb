class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.17.0936"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-17-0936-c7f4e775a4e0/llmux-macos-aarch64"
      sha256 "42c77953208c309f98b088c6a021694254fdb5b1424ebf3743a192b4caac8aba"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-17-0936-c7f4e775a4e0/llmux-macos-x86_64"
      sha256 "2c06bbb3dd1135a6daade0c9340662d7a2e10631c30fa4f9ee140d59e6071345"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-17-0936-c7f4e775a4e0/llmux-linux-aarch64"
      sha256 "ae058facd3b15bdc906aafec7ab6035e81e89594791ff7cf55188eb050d94306"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-17-0936-c7f4e775a4e0/llmux-linux-x86_64"
      sha256 "bfc9da4bbf2b926bbed0ae56a91a34dea8265c511dcfe336d1746926052287e1"
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
