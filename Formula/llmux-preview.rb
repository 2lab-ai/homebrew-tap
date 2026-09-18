class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.18.0609"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0609-850db8b80519/llmux-macos-aarch64"
      sha256 "f47271fdcbe3b405f7f2e6080809e4015373030c07c189c542fbd469830d2606"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0609-850db8b80519/llmux-macos-x86_64"
      sha256 "eecebc9cf07efcb7aeb1ca5d664079b315a4587575e1c7d8bf394eb0e090b6a0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0609-850db8b80519/llmux-linux-aarch64"
      sha256 "487cd925b63096e03f2f6d44e06201e7d420811e73202d09a79741f28d2f08d7"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0609-850db8b80519/llmux-linux-x86_64"
      sha256 "eff86b5d12ff877aa337e1751d03eaad53c28e8b28204b24df5994d5c47beece"
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
