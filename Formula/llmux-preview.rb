class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.16.0729"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-16-0729-814640b65472/llmux-macos-aarch64"
      sha256 "646c5848063f7bce18e4a36482034684bafc7578bc428fb2a463626994b6546c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-16-0729-814640b65472/llmux-macos-x86_64"
      sha256 "a1a558c6ef2b342fc6ab3ddad98a9d65eb7b5c8aa1df34a69a5d26eddf5e112f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-16-0729-814640b65472/llmux-linux-aarch64"
      sha256 "81ff5c469805c95ebf810cfc62d9aed015c60af4f49826aaa70d4574a2d4d6a8"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-16-0729-814640b65472/llmux-linux-x86_64"
      sha256 "fdec4bafe8998fb68accd9b3074d53c7c1968e58c4f2af42e3bcea57db71b818"
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
