class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.02.0610"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-0610-d0b0a0145cad/llmux-macos-aarch64"
      sha256 "376ed7dc3681eb0ac197e23150a74281da81a95e2a277ad9a7865ba01e3fcf80"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-0610-d0b0a0145cad/llmux-macos-x86_64"
      sha256 "b9083abb33b6356a01ecbbbe0c0c95ba1a182cf61ee62889a57251427961c808"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-0610-d0b0a0145cad/llmux-linux-aarch64"
      sha256 "f9f115e4db298db71d4714366760a68cc5f94a099695d415b93136429fd808d7"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-0610-d0b0a0145cad/llmux-linux-x86_64"
      sha256 "66836d2f5094305d3193877ed7f80ee3b4cb64ab72ba5c18f9c5eb464e7712b9"
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
