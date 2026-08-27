class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.21"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.21/llmux-macos-aarch64"
      sha256 "a0c09372c9c6c8758fff4409e2e93b4e007ad5978e7a607132e90ada98d6e039"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.21/llmux-macos-x86_64"
      sha256 "03028cb164a4212860a767f5069866ebce2edc7ffc882c14c8469d4153d50a9c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.21/llmux-linux-aarch64"
      sha256 "f2e592fb71f9c90072f550ed3c7c0cfe7fae3b007961b157eff39c72e50eb31b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.21/llmux-linux-x86_64"
      sha256 "fac91e8395d12859e87f098ba29c3e2de75f64442e12e65c23c5ce33433d235a"
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
