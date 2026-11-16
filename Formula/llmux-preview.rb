class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.16.1430"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-1430-6ac7c4652990/llmux-macos-aarch64"
      sha256 "4e1b81ea9b26031961a45deb96c69d7d2f375e00118f9bc9c29a87121e261ffc"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-1430-6ac7c4652990/llmux-macos-x86_64"
      sha256 "58dbf0070a3892a64e67ab47df78feab21c033285f0e95dfeb806bc700d81897"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-1430-6ac7c4652990/llmux-linux-aarch64"
      sha256 "3a8f4e8366fe77d37cd98685550b2d93654d5fda06cc5e89ca87eba7f4d48749"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-1430-6ac7c4652990/llmux-linux-x86_64"
      sha256 "7336df811f8a7e2bbc2f8c3773531e1a734026bd13f7bedb38707ba76f785a44"
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
