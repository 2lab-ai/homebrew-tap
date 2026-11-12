class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.12.0929"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0929-740bc0c3039b/llmux-macos-aarch64"
      sha256 "65a71dd8e1c6e4f8fcbb8e61d04e6ba7e63faa667eba3c74d4e73a5a005f645a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0929-740bc0c3039b/llmux-macos-x86_64"
      sha256 "ac0484a26067ac80e727f9f186196cc871b33b91cf416ab68975a5b46949b179"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0929-740bc0c3039b/llmux-linux-aarch64"
      sha256 "e6d3ef78d2a0e87325fa210f47397f2a98880fc75989f2943238d0b520376179"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0929-740bc0c3039b/llmux-linux-x86_64"
      sha256 "296bf0b57e79c7e7e836a417f48bc808c7a15d162d0e4471ed52cea38eccfca5"
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
