class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.12.0902"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0902-b7615bb47834/llmux-macos-aarch64"
      sha256 "c6cf7b6300ff922e254c53830b266570f73d481f2ecd5aa3307c1ae0715a0eba"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0902-b7615bb47834/llmux-macos-x86_64"
      sha256 "ab550013040adf1e694659e05420db4a0813b2527cbf43e35834e096a517a219"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0902-b7615bb47834/llmux-linux-aarch64"
      sha256 "5965a82d7396f3c3bf794cae4fc1a73f2655f3ee597853af65581fb6f265e8fe"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0902-b7615bb47834/llmux-linux-x86_64"
      sha256 "5b0a66463743f935da32cb54d598e68ae0f782cbfaf8e56e2ec925e8733def01"
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
