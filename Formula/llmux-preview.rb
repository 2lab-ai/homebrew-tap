class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.07.1948"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1948-34eb95544bbd/llmux-macos-aarch64"
      sha256 "fc13f0a0351320bc4deea7f1f4cd34fdb56764d4395b472f4d927a909ee5cd21"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1948-34eb95544bbd/llmux-macos-x86_64"
      sha256 "593b16b9ad2e90e50b9cf850782085e61bc517e55e78638abb159a8eda702cc0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1948-34eb95544bbd/llmux-linux-aarch64"
      sha256 "99615a61edeee7c9c14e7dba00515e2ca0b5cbbadde39585b69ee544296d6862"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1948-34eb95544bbd/llmux-linux-x86_64"
      sha256 "59646067d4ccab4416c14d46883e3a1e986edadfaba99d5295a2b0cdcb6b5b94"
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
