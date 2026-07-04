class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.14/llmux-macos-aarch64"
      sha256 "7e1b5a886b5020b7d8b6ffcb4eb65a09bf7c216ef031009ca1751e23c4980000"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.14/llmux-macos-x86_64"
      sha256 "3cf3479bd90a0bf4b8db93fe50c27a3ebcc03aa81f204d181f18894dfee3e0aa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.14/llmux-linux-aarch64"
      sha256 "58be5f3c760c95bb8ef7e4f899db90ebadcad1cc8cd9f59779d9e962a8c94803"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.14/llmux-linux-x86_64"
      sha256 "7fabbcc94e087be86d8d5d13177035d8375d07b99dc7820350214f3872209054"
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
