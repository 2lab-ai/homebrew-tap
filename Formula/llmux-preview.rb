class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.01.0333"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-01-0333-4b3a9394d20b/llmux-macos-aarch64"
      sha256 "8f041be3cedbeb8fca7a8929a0f3c034d1b04b721feb813964b1d6156b4519fc"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-01-0333-4b3a9394d20b/llmux-macos-x86_64"
      sha256 "ae62eafe25cdb5398997019024e5ba2eb651362b47897d825f7cf7797c77b1c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-01-0333-4b3a9394d20b/llmux-linux-aarch64"
      sha256 "f2a0d87737a3b921cf3b0220f9970689576fc7ac3c323899590320ccf325c45a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-01-0333-4b3a9394d20b/llmux-linux-x86_64"
      sha256 "2c7cc5adaa07db19a8fc58a80f2f87050629110e1bcfd42da6ca1b910fbc445d"
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
