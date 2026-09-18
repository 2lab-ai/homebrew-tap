class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.18.0327"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0327-eccf1aca27bd/llmux-macos-aarch64"
      sha256 "676e25a0787c0944b695c926b6bdf850bbc35ce69e9c073813ce6e56382575b1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0327-eccf1aca27bd/llmux-macos-x86_64"
      sha256 "790cb39cb5421f0d1b3ba5226bdc6f59d605145c637199602c24f3fc5ffac171"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0327-eccf1aca27bd/llmux-linux-aarch64"
      sha256 "2e2bfa8d0f8c2a025631dce134d5b6abc5ad15ee8c9316506ea85bfdd3a6a9bc"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0327-eccf1aca27bd/llmux-linux-x86_64"
      sha256 "b410e4188f1c08fc5b617abb45da9d3bedfef7a4142a1806213fddc1e29d8a76"
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
