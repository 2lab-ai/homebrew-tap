class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.03.0442"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-03-0442-633bf5cbee8f/llmux-macos-aarch64"
      sha256 "e91d22b57d427ecb2ad7bbc64de0ae2dc26e866bfa20fa4d4e8e09e11914ca98"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-03-0442-633bf5cbee8f/llmux-macos-x86_64"
      sha256 "e5d0e21ac0a3c8b08a519305c04486e624402e2715c54e86fac908d4a1db9393"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-03-0442-633bf5cbee8f/llmux-linux-aarch64"
      sha256 "5e3d2ba3ae5846c20a78cbcd1c2ec749cb67424122db8d31a2cdd79d6309ae6f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-03-0442-633bf5cbee8f/llmux-linux-x86_64"
      sha256 "0304497cff5a4b6e34a00fdca3df58bc53298553ee00389fe6a713e555deda04"
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
