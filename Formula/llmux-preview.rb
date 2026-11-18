class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.18.1243"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-18-1243-36ac773cb5a3/llmux-macos-aarch64"
      sha256 "43c5a9edd8a9cb7aaf589a92be846bbee27fa9ea4baa27414413798d0a916c2a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-18-1243-36ac773cb5a3/llmux-macos-x86_64"
      sha256 "abee118339122fe9b0891b039903f76dc68b8ffde901c2d00a700cc85d9d0045"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-18-1243-36ac773cb5a3/llmux-linux-aarch64"
      sha256 "dd8f8df96038a0ac4a8cee12a21716708a1be97751c5f392ca164e7ac2277e91"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-18-1243-36ac773cb5a3/llmux-linux-x86_64"
      sha256 "5491d72afaa826ffe6342b458c00674d9f3e697bc056b5d9c31ca8476f84f8b6"
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
