class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.15.2343"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-2343-23630fa922be/llmux-macos-aarch64"
      sha256 "7367dac9dd9116f339acbaee27c35b7005944d2c34367c98456727a62ff2916f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-2343-23630fa922be/llmux-macos-x86_64"
      sha256 "b57020053cce070717ebd9c7966dfdc4a4908331706a41528f5e90ea560d651e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-2343-23630fa922be/llmux-linux-aarch64"
      sha256 "f819c9d482480e04534a4b791023459204740eec35f4cb441fed5079a6d07e42"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-2343-23630fa922be/llmux-linux-x86_64"
      sha256 "130a0a5991aff78dd5fb78a3e3a18494bc188d16f8c36de2e3274b10c9df2349"
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
