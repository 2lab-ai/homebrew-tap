class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.12.1131"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1131-33559a49b176/llmux-macos-aarch64"
      sha256 "f84f1f5979d8a9db541994f8e61a9ea6bec4ebbabac382c169f5e552969eaabc"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1131-33559a49b176/llmux-macos-x86_64"
      sha256 "783be4430bb3dd35faee7585a39eb75fc7d72974d0e20debce4b965040f2143e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1131-33559a49b176/llmux-linux-aarch64"
      sha256 "8db86b4322f2c9ba6c8aac1cc880f585ff986054ab85b3339ac93e7716e597b3"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1131-33559a49b176/llmux-linux-x86_64"
      sha256 "da53747c6dd8820b20ec04b3b7e3fe4506040ce9db30656cccfc12d8fea5edf4"
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
