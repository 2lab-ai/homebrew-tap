class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.20"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.20/llmux-macos-aarch64"
      sha256 "0c9c55ab8ada9f6ef7c9146f592712ee9fffeba57f0c6b7227958fcccf563feb"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.20/llmux-macos-x86_64"
      sha256 "91d91fa3ccd29b1b066f79c30e5d0702e38f254c153f3afd89102b3b4082eadc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.20/llmux-linux-aarch64"
      sha256 "e4cd9cb405cf2b83f7015e77c6f889780e81286429c0407f6c63bc0e2b9e5d51"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.20/llmux-linux-x86_64"
      sha256 "5e909db7493f3762aa8a9d24c981c0c7c5dcc22a66adf3e2ea414a824c4b5c33"
    end
  end

  link_overwrite "bin/llmux"

  def install
    bin.install Dir["llmux-*"].first => "llmux"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmux --version")
  end
end
