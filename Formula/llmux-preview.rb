class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.05.0556"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-05-0556-09821312f222/llmux-macos-aarch64"
      sha256 "a50f21e01aeeec489e0d0595d35c38c0f7e0f4471001467ba58765f8843aff6f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-05-0556-09821312f222/llmux-macos-x86_64"
      sha256 "aa08c5809e7629b11df37aba2cb59d167e7cffcda8f930257fd809d622469ae0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-05-0556-09821312f222/llmux-linux-aarch64"
      sha256 "067027376f6c491de494f210a1b4025d48c3370ded8d2a687c96f0c036a31576"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-05-0556-09821312f222/llmux-linux-x86_64"
      sha256 "4115e5d703d60f9b21dca4e1946ca865bcd28510042821ae296b7d4523d0825c"
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
