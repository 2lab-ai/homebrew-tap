class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.12.0803"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0803-3c2b27a9a5f5/llmux-macos-aarch64"
      sha256 "6062a293d6dc8f3313c2cb4dac424bf0838bd785319191addb960931197bc618"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0803-3c2b27a9a5f5/llmux-macos-x86_64"
      sha256 "c0482864d015bdbea81be530558cc9b1175b2cf0cdfe9c20dcc4f1491826679c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0803-3c2b27a9a5f5/llmux-linux-aarch64"
      sha256 "075d421411ca2b2709f2ad5c65ea602674ca25fe4c4b2794473425db1ae4bcbc"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0803-3c2b27a9a5f5/llmux-linux-x86_64"
      sha256 "34455128c7351c6feaa848d8eb798d6a9fb8ff82fee209e9b45c3e8ba904a58a"
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
