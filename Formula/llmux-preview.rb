class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.18.0708"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-18-0708-7cc4d3d417bc/llmux-macos-aarch64"
      sha256 "ac5359e3aba1776cf386184278d7a0710ae60cb3550753db5e3108ebd8fb7ea5"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-18-0708-7cc4d3d417bc/llmux-macos-x86_64"
      sha256 "ea256e6a0f6164a21e4afceb3a289224baa2db4a225ffd7f1dcc29f81b22107c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-18-0708-7cc4d3d417bc/llmux-linux-aarch64"
      sha256 "753b1354be35015c7b104ca48c106c65d9860a3d8f7015264848df2ba97f9b98"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-18-0708-7cc4d3d417bc/llmux-linux-x86_64"
      sha256 "8c8128f2dc1270e7da4a6707681986a5ec373fc9af6a8b4ff48a3a9a267dcdf1"
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
