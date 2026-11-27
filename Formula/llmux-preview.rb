class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.27.0324"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0324-32c2183a3812/llmux-macos-aarch64"
      sha256 "2d0a148b35e9e0e57b3afcd27ed99b1ca12a66b3ac6f72bd370ea1afe7fd67e2"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0324-32c2183a3812/llmux-macos-x86_64"
      sha256 "0379f62643c9942e6e3edbb15c26d3108389c7fc1bf72bdade06f162fd07587c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0324-32c2183a3812/llmux-linux-aarch64"
      sha256 "5de15301d06aeda05cf8953350d95f2f86ab803ab89d80fc56f76ff4dc4b81a4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0324-32c2183a3812/llmux-linux-x86_64"
      sha256 "da1504eadce1aa5258c69f6ea3a7135ed69ee8a38ee509c63db505fb2dc63a22"
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
