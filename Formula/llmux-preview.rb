class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.18.0624"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0624-bcb6e5b1bdbc/llmux-macos-aarch64"
      sha256 "546ba091a1b5c96f8abbf141faa7617b5c5136e1728bf92da1e2e5a381dbc779"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0624-bcb6e5b1bdbc/llmux-macos-x86_64"
      sha256 "1e5690aa9221b63028d4f1e2caa4d247fba5b577898eaad96597c40daabf1505"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0624-bcb6e5b1bdbc/llmux-linux-aarch64"
      sha256 "695066178351b5ebdcb148513d041efee05b93b1941f3cf770dd3b3c4dd93a4a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0624-bcb6e5b1bdbc/llmux-linux-x86_64"
      sha256 "8b85493d3747cd4d70344217dab8700325d00fed299e107fe90e0abd2497f314"
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
