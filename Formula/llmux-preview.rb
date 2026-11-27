class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.27.0630"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0630-35b7aab3e2bc/llmux-macos-aarch64"
      sha256 "297a78240dc5f49158a3cb40f6aee48e79c557e64bd7249adacf163fb8d1699a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0630-35b7aab3e2bc/llmux-macos-x86_64"
      sha256 "3e48f6871d0bf4f946058fdbc5708d090088123aad9e0165c2dd85390fe5abe5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0630-35b7aab3e2bc/llmux-linux-aarch64"
      sha256 "5d457b108444724c572331f8eac231814653e2950260699bd8e79f928cacbec0"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0630-35b7aab3e2bc/llmux-linux-x86_64"
      sha256 "90f7ba67f691678b26d45b80b804e3c9ed07de59e71d6eb937a7b315034bcb5d"
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
