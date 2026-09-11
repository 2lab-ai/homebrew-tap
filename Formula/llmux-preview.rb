class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.11.0404"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-11-0404-8df8b1b1ade5/llmux-macos-aarch64"
      sha256 "d2d0e8022e49ab9e2c945b07a1c3077e1b4b33ddbacc0d3cd852e7ef226fa8d6"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-11-0404-8df8b1b1ade5/llmux-macos-x86_64"
      sha256 "83dfd95f96b3c757e23b3b8c9ccd8109fb2cc527a151fbfa7ba9cb65cc9f3e3c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-11-0404-8df8b1b1ade5/llmux-linux-aarch64"
      sha256 "473993f5356aa3751e8904672569465c0b68fcd62a07f55bb397dbd0ddd217d1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-11-0404-8df8b1b1ade5/llmux-linux-x86_64"
      sha256 "4203ff6dc62e2d34cb4218f3d759860f48c6658f58fc12e7525b2ac103f2c366"
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
