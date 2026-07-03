class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.03.0633"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-03-0633-68a5d3beaded/llmux-macos-aarch64"
      sha256 "c42a6ffa1262b152c26e902bea55b91d9d5c283e75b2fec76e5e6054878d4a7f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-03-0633-68a5d3beaded/llmux-macos-x86_64"
      sha256 "873ff31ad31478bdc88fe9b4a4fdbea93722e420a6396fe3d027240775a93b2c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-03-0633-68a5d3beaded/llmux-linux-aarch64"
      sha256 "41aacc5e47fe38dcd3c3896d4115d34ac8c64e37b13c7e2d28195768f0e0639f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-03-0633-68a5d3beaded/llmux-linux-x86_64"
      sha256 "76165d9b9cd3fd53bc4de18c4d4cc6acabc25e2b573022f02a23b638ff488bc0"
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
