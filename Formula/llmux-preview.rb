class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.21.0303"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0303-49b8609e1aee/llmux-macos-aarch64"
      sha256 "72602e4704cd7aea2f0fff41feec7f4ed84e94eae6c0f3a97fb7016a146f7bc8"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0303-49b8609e1aee/llmux-macos-x86_64"
      sha256 "27709b73cd6ebc1b7648d7ed85b0e77cb6a55b711210881bd232229e1600e56c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0303-49b8609e1aee/llmux-linux-aarch64"
      sha256 "cf03c39716b1704906bbee29f77136d7dbd1edc44fd29c5c9fad772b4bd50680"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0303-49b8609e1aee/llmux-linux-x86_64"
      sha256 "d290e78026d690f6a9bc8674319afe394d4bea5436699f7861aebbe0e6ab567f"
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
