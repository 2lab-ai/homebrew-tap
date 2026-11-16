class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.16.0822"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-0822-80cf5d3e98a9/llmux-macos-aarch64"
      sha256 "d09b858f3a5e80cc9ddab6119fc15a48c67ffd09f20032ed7ed5893f4248d819"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-0822-80cf5d3e98a9/llmux-macos-x86_64"
      sha256 "4c6b507a1e7e0d99fb86b6833576c6b8382de5420ddd650a3f2ce2bd7e0539c4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-0822-80cf5d3e98a9/llmux-linux-aarch64"
      sha256 "2fd061c5ab9584d4896565f3d83aa988905347d113d67a76f696316a6ac78cbf"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-0822-80cf5d3e98a9/llmux-linux-x86_64"
      sha256 "667d070c1a069cda752e3e346fdfe1673fa0313b750148bf8ebd8afb49399cbe"
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
