class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.18.0257"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-18-0257-a34f8353c6a0/llmux-macos-aarch64"
      sha256 "730b5420c2fd4719adfa3ef1216c02c78b35781cb5432582f7d2ef4a148a9e69"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-18-0257-a34f8353c6a0/llmux-macos-x86_64"
      sha256 "3a36896f0d870dbae16ed0691667290dc77772098f6ecbcf5daf11996a6ae5da"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-18-0257-a34f8353c6a0/llmux-linux-aarch64"
      sha256 "08cae8047c7e6728687deb0243c2b1b2fba95d96f8cb58a6a64012fc4ddc6136"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-18-0257-a34f8353c6a0/llmux-linux-x86_64"
      sha256 "fd2774739adeccd01e289fec04a55ec44eb811f22fc220cbee0fcb7c04cce811"
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
