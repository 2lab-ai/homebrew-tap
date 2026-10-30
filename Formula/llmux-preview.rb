class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.30.2155"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-2155-dcd51eb68e00/llmux-macos-aarch64"
      sha256 "6add8a52c371eca7d0d5efed1f12e20dbd1a02d11ccc32bee59c5a1cf60c6356"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-2155-dcd51eb68e00/llmux-macos-x86_64"
      sha256 "539ca0e8befa5e16bec186ce1ef81929e520b8f6ad9cd3ca86e0ff7e21c188b0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-2155-dcd51eb68e00/llmux-linux-aarch64"
      sha256 "783aebb29143afe3418ebea88d3a2306e2e0eab695d778054409eb7aa537837b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-2155-dcd51eb68e00/llmux-linux-x86_64"
      sha256 "40e2a3c7d33c2ab56232db92bbb304ad02633bd3956875899c3d8dfbfef1b816"
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
