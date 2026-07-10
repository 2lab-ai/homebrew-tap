class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.10.0622"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0622-e027df6526fc/llmux-macos-aarch64"
      sha256 "6ca34b6a1463c34f9683e4f1290e3ac4b3bc10fddd5523c736d1dfbadc94fbd5"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0622-e027df6526fc/llmux-macos-x86_64"
      sha256 "6956de39834b7d96dfeeb693aa6c9483e84f1638204798634092b2be6bf52731"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0622-e027df6526fc/llmux-linux-aarch64"
      sha256 "038a812cf717f9b86fff004f99063ca1ec347d19b09c8f43e942eee0e72fcbea"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0622-e027df6526fc/llmux-linux-x86_64"
      sha256 "d289f79db47ff3799764ea8120f98895c41de6ec8f559507903ad24d9fb31711"
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
