class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.22.0514"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-22-0514-245db8048c5a/llmux-macos-aarch64"
      sha256 "80e704db4b613a42aa3f0b38d2b8c4c1098e8bd31f1a762518dec1d75d4e8aa4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-22-0514-245db8048c5a/llmux-macos-x86_64"
      sha256 "d2ac0866f4c3d15d2dfe8ee58813662c1f4b7f5411ad92379507acb37e4ae1b1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-22-0514-245db8048c5a/llmux-linux-aarch64"
      sha256 "cd07bd688756693659130269da155168fa8950de8d90b2b389cc8a2901adafd7"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-22-0514-245db8048c5a/llmux-linux-x86_64"
      sha256 "f0c336ce2ce2b5cc27e3d831fb39d9c5f199841b8a45b205a08b475c0b11f975"
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
