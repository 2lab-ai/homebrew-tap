class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.14.1820"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1820-2d6d8de04d89/llmux-macos-aarch64"
      sha256 "7b88e409322ac8c3ed3c20abf9064cb5aa17ced3bfe6cd04ab89f958b792ce56"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1820-2d6d8de04d89/llmux-macos-x86_64"
      sha256 "1dad8086a77d91b1906ae92adf29cc6ec89babcfec77273579580d0f8420e277"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1820-2d6d8de04d89/llmux-linux-aarch64"
      sha256 "223e524c8a568d2245a14099c04d7c5ff8fb978bac7a72d6d753b197fce9e4ed"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1820-2d6d8de04d89/llmux-linux-x86_64"
      sha256 "05270aed008352d6db39bd0466a82056d7f3eec3c34450d60a233e44eb47f7d7"
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
