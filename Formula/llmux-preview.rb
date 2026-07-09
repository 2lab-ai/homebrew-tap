class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.09.0648"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0648-e48f7939d5d0/llmux-macos-aarch64"
      sha256 "31466f74ed38fc3124e480aac54a41880b68ec985fbe4e041d021b85972b08bf"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0648-e48f7939d5d0/llmux-macos-x86_64"
      sha256 "af6622cf6bb1e9af2adfc354138790d4fd2ff3fce5613f40ae80f7db5750cb9c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0648-e48f7939d5d0/llmux-linux-aarch64"
      sha256 "c3191882e6de7f33ee37d4deeec25988c6e5202ea820ea0ebc579649b9979d11"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0648-e48f7939d5d0/llmux-linux-x86_64"
      sha256 "1be0e0eff8f6c310c59d8e10b6ba33a5f974bf523e9d9fcc9236bb99706927d1"
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
