class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.02.0857"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-0857-6d3c15ea5d11/llmux-macos-aarch64"
      sha256 "5cc4d71b7b6c638517957248039e23051139afff54333ab4c34ecee19067f98c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-0857-6d3c15ea5d11/llmux-macos-x86_64"
      sha256 "45b813fddd0aca9f2d3aa1b3aebc9a9785ffa19a802bbc01ce83990c0cc7c040"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-0857-6d3c15ea5d11/llmux-linux-aarch64"
      sha256 "d9ed75077abf56bdafae3e4ec4491e15eb916d3a5c7bb8f4d9abd6f4c9db94e4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-0857-6d3c15ea5d11/llmux-linux-x86_64"
      sha256 "dc0b6ba003fe8341652f462c88f3b400a9c8500fd74044963f0445869fd1cf79"
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
