class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.02.1553"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-1553-8eaa2bf1dd95/llmux-macos-aarch64"
      sha256 "0b4f9223aae45842798ac945c92ec19d627b49d0ae81ce88f1c4708e9befc5a0"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-1553-8eaa2bf1dd95/llmux-macos-x86_64"
      sha256 "641c12f1ff0ec45b994ec7baaaece008d69d84719fd7b4e42bc248b1701612d6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-1553-8eaa2bf1dd95/llmux-linux-aarch64"
      sha256 "e1973e65c50cb6268a1e35c5cd3afcdbfec032c821f42cc8a0d79155652bb76d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-1553-8eaa2bf1dd95/llmux-linux-x86_64"
      sha256 "562bf094a0ed2d7090df82dc5c23922433a3d47914b26d566459892b955ba071"
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
