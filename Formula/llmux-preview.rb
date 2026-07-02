class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.02.1233"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-1233-07deb71f9fdf/llmux-macos-aarch64"
      sha256 "e414c19bc08ae1257c7f66b24f8858809836b36799b1fb93b44ab2cf8b11c461"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-1233-07deb71f9fdf/llmux-macos-x86_64"
      sha256 "fe2f2acc8de9f77f5471195f1daf8ba92851b33edb7908b942b077c56051b0f9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-1233-07deb71f9fdf/llmux-linux-aarch64"
      sha256 "45bdc7486c83bb2e407fe8ea94943f12b39f8e95e31402691b9afd0bec4812b4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-1233-07deb71f9fdf/llmux-linux-x86_64"
      sha256 "e35c1cb4ee5559029be0be42fa20cacb1e3cb89885db41fc693d5cb2f3cb4114"
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
