class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.25.0717"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-25-0717-08bc69692a78/llmux-macos-aarch64"
      sha256 "165ccce78662d83262f41db20504e67186004c824b1390ab93d651a1d18149c3"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-25-0717-08bc69692a78/llmux-macos-x86_64"
      sha256 "df92b36f430b6c3e66b6f42893ad8e3787f71248fbd244bcf3ddd5f97cc1f227"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-25-0717-08bc69692a78/llmux-linux-aarch64"
      sha256 "3f249468a3a7eeeeb3d7c93bb927a57fb404c4a15ebd1f2cd1bf633387183b75"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-25-0717-08bc69692a78/llmux-linux-x86_64"
      sha256 "1a319f58d9dc992becae1964d48d897ad1dd606eb2c239144c642af67a956e0a"
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
