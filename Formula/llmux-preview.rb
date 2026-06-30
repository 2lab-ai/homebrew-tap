class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.30.0340"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-0340-d3de3388d945/llmux-macos-aarch64"
      sha256 "56d6d7daae4be853e82fb4bc7c375b5b7c096969befc178e5cda02e4c1c9d509"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-0340-d3de3388d945/llmux-macos-x86_64"
      sha256 "11fe156a326f8d186c1e55f3a6a41822eb7b2d2f1556b6d88543ac3a8d0a2cc3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-0340-d3de3388d945/llmux-linux-aarch64"
      sha256 "344930376affd271c2d21ef6c31caf65b72a5e9c0de4f5a2a405c7718a432386"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-0340-d3de3388d945/llmux-linux-x86_64"
      sha256 "26b54fbadbf0cebd048032b7535e5b928d685dd7bdc07d40e55597d9ae33f18c"
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
