class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.21.0435"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0435-60ecbd382836/llmux-macos-aarch64"
      sha256 "15fc31fcb6b21993070bd43e7a3366f06c3acbe00825c4ce9954a4d406be396a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0435-60ecbd382836/llmux-macos-x86_64"
      sha256 "01814f0ce5e88c088beb534bde0ae5c6274b8f11166e7f3f81c63a5450a9036a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0435-60ecbd382836/llmux-linux-aarch64"
      sha256 "f54bf1e62e8606460e826cf5b6271d58793c41e62b62967afa8ba203a7e9805d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0435-60ecbd382836/llmux-linux-x86_64"
      sha256 "49e48959c18a495c33e4596087e25e51746db8b992a9e5a41b4ff9d4cac06d4f"
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
