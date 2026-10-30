class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.30.1854"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-1854-c8b92ad40f78/llmux-macos-aarch64"
      sha256 "34d6b17b3a272c600de8594ebd28e2360b1412b46361fce4ee9b682b4fa35d2f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-1854-c8b92ad40f78/llmux-macos-x86_64"
      sha256 "7452962089e7dbd5cf931604313990e6868938be446e61cac057859ae4f8f06e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-1854-c8b92ad40f78/llmux-linux-aarch64"
      sha256 "2f7394ef586e50eb1027595fdacf50fc9f8e3a1c814cafccbdb06363674712e7"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-1854-c8b92ad40f78/llmux-linux-x86_64"
      sha256 "2c15378502e43e353807081795815436bb748cc4bb4a30d473b66c91984c1965"
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
