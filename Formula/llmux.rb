class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.16/llmux-macos-aarch64"
      sha256 "dab9aea6c692f0b419b3cb23658c0ee01d4b943c383cd960e3e7fd0c810775da"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.16/llmux-macos-x86_64"
      sha256 "4b05cc5339dc8ad5a158d3834f7ef79b64efaf040dda69e8f1fc5da9c55e266b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.16/llmux-linux-aarch64"
      sha256 "ec07553668a01f536932782c8ecf1c954e08e3182d9dc23526148ee1911a70f4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.16/llmux-linux-x86_64"
      sha256 "6015ac5c4071627d267dab64c1548bfe34e9fca86ec5b2fa11b2119e85db51f8"
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
