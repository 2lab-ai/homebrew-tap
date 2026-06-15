class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.15.0244"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-15-0244-e0eec83bf1d0/llmux-macos-aarch64"
      sha256 "d5ba9468aec0976774fdb69ac7957f46bd8317b0ab9e29a0ef2faa004a62e7f0"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-15-0244-e0eec83bf1d0/llmux-macos-x86_64"
      sha256 "2aa5455af40db1c4751c32993c8fcf1117575831a35ff51bdcfb951f07f2d890"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-15-0244-e0eec83bf1d0/llmux-linux-aarch64"
      sha256 "e5388c330ed73f1c1340012e5067729dfc53704cd434f92dc517fe8ee6c3c61d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-15-0244-e0eec83bf1d0/llmux-linux-x86_64"
      sha256 "00cfa8fdff9d888eb2ebe9c0dd9b47b4eb2def1aad5020095b5137399d3eb679"
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
