class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.21.0800"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0800-40caa5920275/llmux-macos-aarch64"
      sha256 "e73b8b81f6da1c96ce8600e3947b97cc2bb05dd6d23d67175c4dfacf8ea1917a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0800-40caa5920275/llmux-macos-x86_64"
      sha256 "77bdc4d58c8a48610a9c70b1f14a2a0203e45ec1b5062b5967a3b8bab45c4b7c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0800-40caa5920275/llmux-linux-aarch64"
      sha256 "c69c195fc8aedc9e270456943e1ca8a8262fa691faac02c4e9594bc97bcdc78e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0800-40caa5920275/llmux-linux-x86_64"
      sha256 "197e4061e2bce8bf9a4cf467016393fae4b93eadb33bb98030fa321ee8fdb847"
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
