class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.14.1115"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1115-00f79ad7cb35/llmux-macos-aarch64"
      sha256 "927ac519d2d37db677ad9bfd5c56c9496d4a1de0c0c81ef9cae1a9aec23bd4b9"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1115-00f79ad7cb35/llmux-macos-x86_64"
      sha256 "e473010665c9c5ce1518905775d3f729249385016ab5ef2bbeb2019630836f63"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1115-00f79ad7cb35/llmux-linux-aarch64"
      sha256 "c90b5363b338d54b82a634c42c6b2e3982de6b38d3e2c118c10b1e216ecf75e1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1115-00f79ad7cb35/llmux-linux-x86_64"
      sha256 "d60b3b14c137c491e4a0c88a0cbd19a099b09d43f3a6ba4bd7c5fca05f97c668"
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
