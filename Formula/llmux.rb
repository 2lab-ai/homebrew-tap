class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.4/llmux-macos-aarch64"
      sha256 "da6c7d7d67ca40bfa46122d9f7996703ebd0ffede8540f7dd6499a655f6be67b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.4/llmux-macos-x86_64"
      sha256 "47c320d8e88dae8013efe98443015bce2adc3411dfa5781ac8d84cf8d69cb180"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.4/llmux-linux-aarch64"
      sha256 "d43e898f3fe6ecb1edee06836671ccdb9d920926cc4bc1dd114e8f7c9a23773b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.4/llmux-linux-x86_64"
      sha256 "66d5bea0c6bfdfceea7bc4e3eadf2b56ccfd9c330908e2b3782501a055f95e92"
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
