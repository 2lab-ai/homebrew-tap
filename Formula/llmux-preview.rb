class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.07.1452"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1452-a0b3b71087da/llmux-macos-aarch64"
      sha256 "e54f772ad1adcfaa5d3c2bcf3a16d1f678ffcdafc4f0e592d560005b86cc5075"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1452-a0b3b71087da/llmux-macos-x86_64"
      sha256 "25f261dde08a299d4d45ffbeff78e1e4f3913f87a3401c46ab9f8f37f76b1fcf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1452-a0b3b71087da/llmux-linux-aarch64"
      sha256 "c304449ecae3ae87db80907aeab082a01b0d207ce3e4216bed927230e392e3a8"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1452-a0b3b71087da/llmux-linux-x86_64"
      sha256 "0208975e76c1d8034c90c99f6926dea008b5a4e7a06eb4829c66721cd0839655"
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
