class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.27.0403"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0403-835d667e6c3d/llmux-macos-aarch64"
      sha256 "291505f98b7a2d91a5f03e7f9980c06e8c06aa04da3967a12b6b2a70362df2da"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0403-835d667e6c3d/llmux-macos-x86_64"
      sha256 "b541e659fcb1169c63ecdfbc770c92a6efc51eabc1fee8384282cd5e294a2c52"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0403-835d667e6c3d/llmux-linux-aarch64"
      sha256 "d2e2cb2824bd6b0f9c825c328953a0c5da043995dc85b62457271a008c99c1dd"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0403-835d667e6c3d/llmux-linux-x86_64"
      sha256 "a8612c1eba8eb16dd6028c19988183b3d304295f7d6201ae2a8284a6012bf6e7"
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
