class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.17.1250"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-17-1250-0884521c243b/llmux-macos-aarch64"
      sha256 "dbc911587c1924467508af0ec3fd2650a3288ec5a0e3c8cfcdcd30b32e0309ec"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-17-1250-0884521c243b/llmux-macos-x86_64"
      sha256 "d84783446d7b41f6b9ee7802fded8cc8a6de448fbcf48cf40cc82f95c15608e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-17-1250-0884521c243b/llmux-linux-aarch64"
      sha256 "d76e8ae5f0b3c86b0397ee3b6509b42d511de6bbaf0546ecf16e67cb081495c1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-17-1250-0884521c243b/llmux-linux-x86_64"
      sha256 "e571c0c63a7426c17ab3fe228a1da455d57d507f49bae8e59124a819e8fd3805"
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
