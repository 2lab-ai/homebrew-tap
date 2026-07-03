class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.13/llmux-macos-aarch64"
      sha256 "c50ee0265a39ecb41ce2fd61bba7232ed3a2676cdef170c9975e105c5fa84d76"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.13/llmux-macos-x86_64"
      sha256 "e893a9db220c73c85bd815e2f3eb54de7828bfc6428a210637623751bdde8088"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.13/llmux-linux-aarch64"
      sha256 "7517529191516cba4fa7da6e648176745b1b4cde5995f567515c94e041a9ddd1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.13/llmux-linux-x86_64"
      sha256 "beac01bee96c0037f5a1836619fff7e327866f02126da52cff6866fc2b2b4300"
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
