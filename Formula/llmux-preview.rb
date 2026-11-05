class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.05.1227"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-05-1227-eec32c9e039d/llmux-macos-aarch64"
      sha256 "106bf812366c411826cf660c54883f831978eef583e53ec44650897afd605308"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-05-1227-eec32c9e039d/llmux-macos-x86_64"
      sha256 "e8f85fdaffd7e4108573fafe6a96965e7b9fd708e0e9fd7421004b42443e6473"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-05-1227-eec32c9e039d/llmux-linux-aarch64"
      sha256 "3f3c5394e4df2d9c3c2094af1dd68e52e63ea213d0817d79b544f725b2fb3d6c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-05-1227-eec32c9e039d/llmux-linux-x86_64"
      sha256 "b6e40afeb59cd43ca9cf98152769f50d72db2d0b542a11397d65a2e09764a744"
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
