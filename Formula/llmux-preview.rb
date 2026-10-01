class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.01.1034"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-01-1034-969f32454f17/llmux-macos-aarch64"
      sha256 "1bffeff3d1fb3e59ed63182dbfe7bee08019826a94de110db6247b2778c8edf1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-01-1034-969f32454f17/llmux-macos-x86_64"
      sha256 "240c0d6dfb176def4b0394550746388ef6c5af21bdd45636baf79cde71a2ee2c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-01-1034-969f32454f17/llmux-linux-aarch64"
      sha256 "638c72848b21f8942f89b052ce3d0bbf9f20c6ae4f0b9eca1dc9167fe9f71dda"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-01-1034-969f32454f17/llmux-linux-x86_64"
      sha256 "67ee4ec3ac044cec2a7d541d1be51e0a43ac95aa555a061dbb7cc0b951ea234e"
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
