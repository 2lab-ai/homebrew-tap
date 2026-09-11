class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.11.0912"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-11-0912-848e5c428b1f/llmux-macos-aarch64"
      sha256 "07a1d1104e6fc87778c902fb4076769bc31b36fdef29ae7f7fe14491e2a569ba"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-11-0912-848e5c428b1f/llmux-macos-x86_64"
      sha256 "0defa1e0894f16103e978c856a1152e7502be7707785ea0e7cb567bac018d892"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-11-0912-848e5c428b1f/llmux-linux-aarch64"
      sha256 "48740b56a9853157ed6e4b4166ca651ca2742d15f2da918cb82a2b365fc78f38"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-11-0912-848e5c428b1f/llmux-linux-x86_64"
      sha256 "d893af7112812fa04cb94377abc3fcdfbfc4663f2044f356796370a52c1c0ce6"
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
