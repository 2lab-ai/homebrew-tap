class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.15.0251"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-15-0251-e5a60ecd8618/llmux-macos-aarch64"
      sha256 "36c8e8c7fab58a40d5cc60faf85f2bcf8bb8808d98ecd05e73b82c43431923ca"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-15-0251-e5a60ecd8618/llmux-macos-x86_64"
      sha256 "8ddcf2e5df87a6be1d433042cf12aa777155dbf19da4a7e4102fbed81a179708"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-15-0251-e5a60ecd8618/llmux-linux-aarch64"
      sha256 "33911436f544ef0999a4cceb3d75febc519a5e7ebbc05da9096243a00d32ffc4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-15-0251-e5a60ecd8618/llmux-linux-x86_64"
      sha256 "bef120a901b715d836227059c849e428cb98306f2ca2b2ede776dc4dda8a51eb"
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
