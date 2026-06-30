class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.30.1112"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-1112-84a044184257/llmux-macos-aarch64"
      sha256 "d03f0c5c1c4c7f8de8d04372151db0552b2b512ee99cb485577ffff75f6b649e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-1112-84a044184257/llmux-macos-x86_64"
      sha256 "c4db993f9acbce607bbcf1a4ecd526bfbcea627a02508cf6acadbce51469b756"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-1112-84a044184257/llmux-linux-aarch64"
      sha256 "62b45b0cc56f3b67e19e740019e157fbf82a675bb7db80b2422ec8133aecd4e8"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-1112-84a044184257/llmux-linux-x86_64"
      sha256 "4642f426e3236d81342e7224f14c6c0380a22ef7b2b22575df8035638a263629"
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
