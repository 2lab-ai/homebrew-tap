class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.14.1700"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1700-3e883ea919c7/llmux-macos-aarch64"
      sha256 "32e9153b42a05e49a87a31b4f90b0bee696c5d46486270cdc573e61bf4be8577"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1700-3e883ea919c7/llmux-macos-x86_64"
      sha256 "77ce88cb547ce328d8eff2320ac16640996e313158034fed798fc060366505b4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1700-3e883ea919c7/llmux-linux-aarch64"
      sha256 "0decbee20877d40e990e6c9d293b85825e1df0258156e756b6fb9e4850d455e8"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1700-3e883ea919c7/llmux-linux-x86_64"
      sha256 "d06dbb936f4e12bc38663e733a8ebc9449071f2aba63f374082640680598702d"
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
