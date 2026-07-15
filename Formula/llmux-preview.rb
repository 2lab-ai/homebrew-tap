class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.15.0159"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0159-759097ec7591/llmux-macos-aarch64"
      sha256 "da3379b80cdd42f587001c0d91018de16d18d519bb9636b2681fb2c7ed8970ab"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0159-759097ec7591/llmux-macos-x86_64"
      sha256 "2bb2972b7c99a8892bd91f4e4c0ab09c09ee768d253f3ba83752186e8f5a6eb1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0159-759097ec7591/llmux-linux-aarch64"
      sha256 "615824397d0a1aadc887d80519b2db30676052446f2fd8eab9a0feb8f1c7fe0a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0159-759097ec7591/llmux-linux-x86_64"
      sha256 "2ad3b5f31674df528688b7891ab9e9e1c81c3188e059ea7bbcfac0a56f0ad24e"
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
