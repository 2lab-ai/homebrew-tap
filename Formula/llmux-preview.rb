class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.22.1102"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-22-1102-fbf1f060a19a/llmux-macos-aarch64"
      sha256 "bdf39bf00f1245826b0a9e8d5a29bb307747ab5cb251566c35a7faebc67e9db3"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-22-1102-fbf1f060a19a/llmux-macos-x86_64"
      sha256 "53993a91ae2036b3fb5e5e800c9d5fa56b6ba1f45176ffeac725d68f4502c2c7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-22-1102-fbf1f060a19a/llmux-linux-aarch64"
      sha256 "73fc99d9a6e4265ff12d4690ce4e2d23b72904696f0542b74542277ca71ef9ab"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-22-1102-fbf1f060a19a/llmux-linux-x86_64"
      sha256 "3ff56f00a1ff1de0ac23fa24316de08f285498dd755172f0a4e04f102c1dcb82"
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
