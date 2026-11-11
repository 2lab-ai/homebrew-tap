class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.11.0758"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-0758-e07bf5057b15/llmux-macos-aarch64"
      sha256 "528f7bf76afd5129bfbfcf17b2cfac240ee3d49179bdf61d6270b2d53fd40346"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-0758-e07bf5057b15/llmux-macos-x86_64"
      sha256 "9107686d1e8ad0e5f5cf712b9c8aa6a69b6c11962ebaa1424a2238c80052f695"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-0758-e07bf5057b15/llmux-linux-aarch64"
      sha256 "9cfd18e8bdcbbe999468bf8e1fc1b2db05f28f7d9daa3c96ccc8ce85d81d10e6"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-0758-e07bf5057b15/llmux-linux-x86_64"
      sha256 "f9f929fdacee7d29097b7fca69a4026817cdc8789a197eb8863553dd665846f3"
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
