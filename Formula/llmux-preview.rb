class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.07.0108"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-07-0108-a87c63f22e1b/llmux-macos-aarch64"
      sha256 "c372dadf7ab8fcd7ca43b73ba4925d6b32271146d75ef580667ec2fcdd527f75"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-07-0108-a87c63f22e1b/llmux-macos-x86_64"
      sha256 "596a9b017aebf91afee2110298976a1c22344cdb8f9f7b6619c2da8a76df0788"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-07-0108-a87c63f22e1b/llmux-linux-aarch64"
      sha256 "57e29beca0564c196f038a36b7700cd50f2f36096ab52f2d6d8cbc28f95801fc"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-07-0108-a87c63f22e1b/llmux-linux-x86_64"
      sha256 "64546ca9259d3bd9a498496a0e6d50b1c41cf4226396af9a54838af314132073"
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
