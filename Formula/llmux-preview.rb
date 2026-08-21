class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.08.21.0642"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-21-0642-79f66748656b/llmux-macos-aarch64"
      sha256 "ae00e5361355bb8a9eee943b5fbc4206a66721c4fa1ebe9e7cfe7bdfe128e8cf"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-21-0642-79f66748656b/llmux-macos-x86_64"
      sha256 "db9b67b11c388f54bdcb93d4236bd0077cc0d1ace5788133adc721b8de3e9dbe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-21-0642-79f66748656b/llmux-linux-aarch64"
      sha256 "697265d740fb76cb3cf1d57087109decd6ffd5f97433210575b6d12588e3009e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-21-0642-79f66748656b/llmux-linux-x86_64"
      sha256 "3e2ef2e31f2b5107781c46e55ebd66910060dc9a8da02da239dc584bdc5e3b47"
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
