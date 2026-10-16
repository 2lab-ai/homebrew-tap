class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.16.0709"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-16-0709-a162822a9215/llmux-macos-aarch64"
      sha256 "eac9994fea47eb0f570910dbf6491eeea87e24bcc4f74a21018f6a6abeda8178"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-16-0709-a162822a9215/llmux-macos-x86_64"
      sha256 "c76be6b4f8aab75b51935f2055eb100c6d0ac3bc469a7ca3944a0f054730de14"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-16-0709-a162822a9215/llmux-linux-aarch64"
      sha256 "a0c12dbde4233e16f4b48701c51a549dbec56325f2b9734a4df99d16b397ab84"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-16-0709-a162822a9215/llmux-linux-x86_64"
      sha256 "c513977959210c3faf17b91e54abb71d7e9e2380aafdd745ad03419987c8adbf"
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
