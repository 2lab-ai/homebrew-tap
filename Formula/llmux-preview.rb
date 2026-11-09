class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.09.1007"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-09-1007-32c646050e10/llmux-macos-aarch64"
      sha256 "039aaf077d77265002e160cf7c6a41ca76cd0ab5c06f5cbe1751cf4e9795d012"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-09-1007-32c646050e10/llmux-macos-x86_64"
      sha256 "1aa8cd30248ee7d8deabf015ce851805418c0157a7bfac0f636fd20bce1e983c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-09-1007-32c646050e10/llmux-linux-aarch64"
      sha256 "6ad8f15d6b343c509bf2180c0313ae64d07d3261d56908e4f7687ec0a0a65ca6"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-09-1007-32c646050e10/llmux-linux-x86_64"
      sha256 "ad6d5524023e8a535765f7622ce2311dabc2ec8c2a787bf2e925020242d460f4"
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
