class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.01.0233"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-01-0233-0173bf710828/llmux-macos-aarch64"
      sha256 "9bc82e3c648ab0d9b46daa46639b6f5c52a3c88e916fb89feb2733dc42c87a34"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-01-0233-0173bf710828/llmux-macos-x86_64"
      sha256 "2881f2be2d6b8e4c3e7809f5af274605bfdbfd7da38805047f78e5ebb2a2a50f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-01-0233-0173bf710828/llmux-linux-aarch64"
      sha256 "3a46c80ef98705dff98f60ffd5bc68b4a98960ae5e3796375e862aec33081003"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-01-0233-0173bf710828/llmux-linux-x86_64"
      sha256 "3fcf1b8555fc25c36a7ea50458bdde2e29911e51fdaa4ebf9422517e1267836e"
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
