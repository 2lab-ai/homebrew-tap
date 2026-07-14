class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.14.0842"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0842-d2804ada477a/llmux-macos-aarch64"
      sha256 "4ae55ff80a34eb55049c99802a2fc489b4fb76367675cec4b69dc0fbaef34293"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0842-d2804ada477a/llmux-macos-x86_64"
      sha256 "322d04363b27998c229cb90c6c21ee882a0072a0987af66de9fcdc5f17f81244"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0842-d2804ada477a/llmux-linux-aarch64"
      sha256 "8cb9198c696b0e0f6efb47258fd74b4668a183689d5934e7350e42a6ecaa57cf"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0842-d2804ada477a/llmux-linux-x86_64"
      sha256 "8a8c25842b7dee3d80717b6627944d3c278949db67c994c7e7972b426b67bb37"
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
