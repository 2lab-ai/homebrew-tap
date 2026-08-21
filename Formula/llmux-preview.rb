class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.08.21.0609"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-21-0609-de4489ae8276/llmux-macos-aarch64"
      sha256 "8fce7e424bde7fd1554cd3688da148c467c008df900272ff92d7ac2d8ada5298"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-21-0609-de4489ae8276/llmux-macos-x86_64"
      sha256 "fd5ef272a4dab3dc1781e9654afd85525823e4d0dd09e17a2c930199e47ce73b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-21-0609-de4489ae8276/llmux-linux-aarch64"
      sha256 "bc1273d01c49c7077786b144a82a34f5daf92e8379bf598a0942d0e5baba0b57"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-21-0609-de4489ae8276/llmux-linux-x86_64"
      sha256 "b6d48d9a923b9532c48839c915bb0813747165d4966064ad52cd118e3f0da163"
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
