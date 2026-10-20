class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.20.1052"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-20-1052-f5974038045e/llmux-macos-aarch64"
      sha256 "08fe88053d02e70f7b09778f41753d6bf01e318195688d5af8dd63e842318100"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-20-1052-f5974038045e/llmux-macos-x86_64"
      sha256 "6bb9cb2459fc497840aa71093551dd2fbca562fde73dea7e6433655ec1ce512e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-20-1052-f5974038045e/llmux-linux-aarch64"
      sha256 "f92978f986c5557a004e497b771dcb11929368772fa747d56f4ccb33e8df4a7b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-20-1052-f5974038045e/llmux-linux-x86_64"
      sha256 "8733f07812875ac51c45298f326595bba3e29444540a18de0dd0389eca46c15b"
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
