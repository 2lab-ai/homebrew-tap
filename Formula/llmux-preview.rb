class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.23.0153"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-23-0153-9b09a73e75b8/llmux-macos-aarch64"
      sha256 "731d3bd509baf9950273404239d7d859decc9895cd3fc1e46a22c3cfe6b0878d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-23-0153-9b09a73e75b8/llmux-macos-x86_64"
      sha256 "a310c00dbe06f221eb749acb9b638f7366597f37e62d8fc0895a0b7218a4c2f7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-23-0153-9b09a73e75b8/llmux-linux-aarch64"
      sha256 "06521f4999c15e0ed2d5a923c23919198590c0325a546a8c41c5cac37bce4e84"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-23-0153-9b09a73e75b8/llmux-linux-x86_64"
      sha256 "0f57d9a949c29b9975a0f65c830dd0566c5bdb8bf49149afc75dd8bb395e0d91"
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
