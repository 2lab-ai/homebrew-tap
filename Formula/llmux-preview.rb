class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.10.0910"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-0910-626e22204a8c/llmux-macos-aarch64"
      sha256 "42f98c0fb7f6ae218dc6fadfc62fc03b0c0c22216d7b48848057613b3ae7c0a7"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-0910-626e22204a8c/llmux-macos-x86_64"
      sha256 "d4fc5680a62fd342f38da28b2c554ce640d6bc74fbc6ab379fd99917828aad1f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-0910-626e22204a8c/llmux-linux-aarch64"
      sha256 "957647685d22ce2d747f6ca8e025486b811710dd985b2e2c618eb51007a2bd36"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-0910-626e22204a8c/llmux-linux-x86_64"
      sha256 "027958cbe5d0354c87a1f0a8528a47f63c3217308e8998702766d7108d51f6a5"
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
