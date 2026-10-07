class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.07.1519"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1519-99cb09ce7c88/llmux-macos-aarch64"
      sha256 "c7e3019718e4bcf4fac1b26b4068e5694940ac57a8cd9c30dfadbe1e27804930"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1519-99cb09ce7c88/llmux-macos-x86_64"
      sha256 "cdba7e35977cde8d3498d5c60ae4fc5d85eb3b992509b422eb0233776cad438c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1519-99cb09ce7c88/llmux-linux-aarch64"
      sha256 "30214d70dac1cce501f61c6a56b1f6ea514a7f6253537bb4934024851d169c90"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1519-99cb09ce7c88/llmux-linux-x86_64"
      sha256 "25fca08f5681b4fa03d514533aac2f321677ca6fb5f2e7c2a0a9538d753b6ed8"
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
