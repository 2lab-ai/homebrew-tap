class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.16.0843"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-16-0843-5adec910de04/llmux-macos-aarch64"
      sha256 "41459afdf17575a3c7f0282bde308a3abe451efc4da20e1a79d5d156290077e4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-16-0843-5adec910de04/llmux-macos-x86_64"
      sha256 "09b41b7f86d6cff0624db459ff354c58065b8c63c9cd7bd3c7e461173c791d80"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-16-0843-5adec910de04/llmux-linux-aarch64"
      sha256 "005f88d695cdca0b9eea5aa48f53b618b57aa39ddab7d3597bb9f8969747cfec"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-16-0843-5adec910de04/llmux-linux-x86_64"
      sha256 "ad8a147dddb0c73a283e8b34f5533740a40bb5d23c9ba16682054d99d49c34a5"
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
