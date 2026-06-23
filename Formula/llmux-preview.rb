class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.23.0355"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-23-0355-c2b9cab4be92/llmux-macos-aarch64"
      sha256 "4ea13da73f6704852a9fa551a1b81c028df3b2a0c0405e32ca112a6b59277365"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-23-0355-c2b9cab4be92/llmux-macos-x86_64"
      sha256 "d5e9856837240e8cd427d1779aec650141eb56fb8af4cbfd02932a65cf189d6c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-23-0355-c2b9cab4be92/llmux-linux-aarch64"
      sha256 "170659aa9df2713150e46a4704df68cf0e96a54743378c714a989558405ef1a2"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-23-0355-c2b9cab4be92/llmux-linux-x86_64"
      sha256 "f8dd10d34726c260d1c47f7fdae7c6d4b82f22946e05b9ce87d3e9e9348ad2ac"
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
