class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.26.1213"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-26-1213-4ff9823f14e8/llmux-macos-aarch64"
      sha256 "d20082552e1d644da9515e1d35a7eb4e2cf07b6d4e2a8159dc2b2b47435d72a6"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-26-1213-4ff9823f14e8/llmux-macos-x86_64"
      sha256 "c166938171ca68037ee78b7d6476554182301ab24cd3de2cc9b8154fea7a8a6e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-26-1213-4ff9823f14e8/llmux-linux-aarch64"
      sha256 "2f5eecde64dfeeade0032cf3cb41a3b766bb24266935b513ba79a5211a7cb564"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-26-1213-4ff9823f14e8/llmux-linux-x86_64"
      sha256 "b6bfa00ef4cb121b2b3818157c8c1596556eaadac79f7ee715bde981991b1719"
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
