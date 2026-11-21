class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.21.0516"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0516-e12be45732e3/llmux-macos-aarch64"
      sha256 "de35eb55caa4d4da19cd92bf7dee2b37b9b7ff13a676383f62fe33467501c494"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0516-e12be45732e3/llmux-macos-x86_64"
      sha256 "9cfc81aa21ac0150edd27b0b492bd1f65b6cd18631a4765033f358e3882a64fa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0516-e12be45732e3/llmux-linux-aarch64"
      sha256 "61997a218a986bccaccb8ae9bf7981e6760985e2677f4b09bdd11db2554dba75"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0516-e12be45732e3/llmux-linux-x86_64"
      sha256 "b9242e6d2bf1080de12ab7d5fb51db4863555868d20dab8c44619fa7ddb29434"
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
