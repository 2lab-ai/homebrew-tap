class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.04.0952"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-04-0952-524b6e437fd9/llmux-macos-aarch64"
      sha256 "0faa2df335f901e72997aafedb9072776596a1a117d93c45de5f76af8db074b4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-04-0952-524b6e437fd9/llmux-macos-x86_64"
      sha256 "9e68fe4334a08d8b62824b329758447331eab006f6ff9f24eb982cb1e735f4ea"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-04-0952-524b6e437fd9/llmux-linux-aarch64"
      sha256 "46b6290b89ca67a96250d46e373b29166e15dc003973a0f8ed26e348bc124bd1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-04-0952-524b6e437fd9/llmux-linux-x86_64"
      sha256 "f838cab0f2032de0ee011670a4f8b64f33db00bad676ca634208790f2799fddf"
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
