class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.15.0128"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-15-0128-c71ffd842687/llmux-macos-aarch64"
      sha256 "a83b950510bd2d54a0a2d0fed7116c8b9b2c03ec2d5f33315c7e0ab99599c787"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-15-0128-c71ffd842687/llmux-macos-x86_64"
      sha256 "8c362eb1af731f2e7681a5536cecbc88d2b80b8e358e73a4e329baa484a74af7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-15-0128-c71ffd842687/llmux-linux-aarch64"
      sha256 "1745f4300740939b0b8854ae6f33d1ca96b5d6e4b740c59095fb1e4ec84359a6"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-15-0128-c71ffd842687/llmux-linux-x86_64"
      sha256 "00571d6baa7f1a66cb111cfb832255a7c8506cf63bd17b89d2c6a0a2bb1f0853"
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
