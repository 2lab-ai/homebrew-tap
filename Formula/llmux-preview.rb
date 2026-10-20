class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.20.0950"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-20-0950-2582217e22e7/llmux-macos-aarch64"
      sha256 "b0a02034011c7a0a7536a7ac536e801222532a1b9640c916d4b15ae2b995a915"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-20-0950-2582217e22e7/llmux-macos-x86_64"
      sha256 "095cbb13e496da9642d6effd0fdb1e711d038bc2e5179c54b2ba1c10e72d9b22"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-20-0950-2582217e22e7/llmux-linux-aarch64"
      sha256 "b83247ef0b98cb147b4abb56262282ed82cac438d31d9b5a68a99e4663503c4c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-20-0950-2582217e22e7/llmux-linux-x86_64"
      sha256 "2b1f2bdf53c9de4421c63107a4911276989aa6ab4b00d7afaa2dba4f9975a132"
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
