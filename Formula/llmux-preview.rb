class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.15.0424"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-15-0424-8be574b18290/llmux-macos-aarch64"
      sha256 "b839984ac9e53aec072c3291c59fc5459ae1221b91b88b919065fcb3932dbaf6"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-15-0424-8be574b18290/llmux-macos-x86_64"
      sha256 "493838bfeb69bd6d1f91afb497cb9a6475d6ebf0396d91ef27bcbe4bc2f2bc53"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-15-0424-8be574b18290/llmux-linux-aarch64"
      sha256 "80b2425a1fc8d8fcf381f608e9d3adab27c4a9a52471b5450336c49c34d6f638"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-15-0424-8be574b18290/llmux-linux-x86_64"
      sha256 "9e0ecc5a6ee0bce6d0c10a7fbc9c92773b193c04e0f620eeb1e21a2f21ace9c6"
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
