class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.09.0839"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0839-17a531eb1ae0/llmux-macos-aarch64"
      sha256 "60bbee806d8170204e329c29b4c188e85b2d735e53fef872729fd31b4f308256"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0839-17a531eb1ae0/llmux-macos-x86_64"
      sha256 "1a4d5e44d8f74819ac00d7de121aabe6bd1bf9016bbc149388e3376d1e6e51a2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0839-17a531eb1ae0/llmux-linux-aarch64"
      sha256 "67096d0e5258ad65be40f5602b4bebb3a6825d820bd7dfa9775c7daba18904ed"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0839-17a531eb1ae0/llmux-linux-x86_64"
      sha256 "f63600aef562534411444d4ba3ba86df9f35d81214bb3aad021fa533dac162c2"
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
