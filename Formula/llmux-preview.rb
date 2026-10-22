class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.22.0837"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-22-0837-26b5ab994e9f/llmux-macos-aarch64"
      sha256 "6d0be7d1771204a5b8ee4264611b6c7ccac162102fc3564f321c1e5a0991b05c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-22-0837-26b5ab994e9f/llmux-macos-x86_64"
      sha256 "2da564bda1fa79621a8f8ab81549ab2b776b902e0d84a37c32863fc201757a35"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-22-0837-26b5ab994e9f/llmux-linux-aarch64"
      sha256 "b1eed6f250e5bd55c4949f7c44e4d7272cec94a073ecc01f29cf8ecaaa56d4fc"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-22-0837-26b5ab994e9f/llmux-linux-x86_64"
      sha256 "120b634a20e2d32894ce3613e28188c4dac0495e0396fbc442412851f470a5d3"
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
