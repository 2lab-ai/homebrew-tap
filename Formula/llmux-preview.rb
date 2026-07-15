class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.15.0025"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0025-0c47985758da/llmux-macos-aarch64"
      sha256 "2247c76f449dc241181e12283b1ac9fbe926efbd837f4c9e13dbf5d3b1729595"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0025-0c47985758da/llmux-macos-x86_64"
      sha256 "860d086d7809b4aff404de43076b57aad210dc7a7b49b02900c22332f9a8e874"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0025-0c47985758da/llmux-linux-aarch64"
      sha256 "e5f5d9b3fd29656f26ad68a4d612b6f5ff53930d92b7331e014a42ad4e7f4d6e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0025-0c47985758da/llmux-linux-x86_64"
      sha256 "7d20cc4f5b99531d634eef5d1c7b4727fe544eec2b89eccdfc97d7acbc7fbe4e"
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
