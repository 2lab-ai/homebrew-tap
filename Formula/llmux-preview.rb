class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.13.2226"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-2226-90860396997f/llmux-macos-aarch64"
      sha256 "d98d80a40f9bc32ecb1a919e9f54bb0a7a8fb26fd4c9c6bab303a82bd8874b6e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-2226-90860396997f/llmux-macos-x86_64"
      sha256 "197f44a0bcab5ef73ff2c6b3ef1c81a6c9d1875e02b050264936c574e9a83364"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-2226-90860396997f/llmux-linux-aarch64"
      sha256 "44ff82ff65110317edfeb0f31131df10b0f7ab587146e204e3ad7e69b873e6ba"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-2226-90860396997f/llmux-linux-x86_64"
      sha256 "38ca24d25156b1e31c0ee33b30c24e990c9d659264db20c4bfe976d19b20e8f5"
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
