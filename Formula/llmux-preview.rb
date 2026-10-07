class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.07.1404"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1404-f85b26bb2b81/llmux-macos-aarch64"
      sha256 "dd4663d1c3a1416df73b3995638b89b0447e18967827ea8faf8cfa7c6cd1e320"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1404-f85b26bb2b81/llmux-macos-x86_64"
      sha256 "964f0dfe47c3512462b39e932e5cf9a221613267e782ca617272116a027509eb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1404-f85b26bb2b81/llmux-linux-aarch64"
      sha256 "573ea3e0216ccd26c08bab577373e9dbad554d23c3033304d766ebef68f7ab4b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1404-f85b26bb2b81/llmux-linux-x86_64"
      sha256 "13c661506420a3229b1fd2fbf05ee6bf52eb3216ece0b571ec6a6666add844d9"
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
