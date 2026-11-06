class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.06.0444"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-0444-a7520e969c74/llmux-macos-aarch64"
      sha256 "b3796f760b0761b0181a0033b96de31332a4f9abca0788b7e80d188683b47c4d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-0444-a7520e969c74/llmux-macos-x86_64"
      sha256 "2d83516176e930953edbe9ace3472e469e8d2535aba02273141a4241074ddf4b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-0444-a7520e969c74/llmux-linux-aarch64"
      sha256 "b6226a8661ec298596cf3f78fe5c5dfeac8e2c38cfa13ecbd0c41c379b950217"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-0444-a7520e969c74/llmux-linux-x86_64"
      sha256 "2daa5c3a41c179fe749eada9214339215b1e62a58210a9e1e96b59af9d216358"
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
