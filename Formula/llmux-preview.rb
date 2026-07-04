class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.04.0127"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-04-0127-8992a354873a/llmux-macos-aarch64"
      sha256 "0ad7f16e0cbfbbc53a5c1cd225683e001d1c7798e4244e34a0cbac52833ad24b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-04-0127-8992a354873a/llmux-macos-x86_64"
      sha256 "bfd59552ba5dd052aabe1edaac44963c64efcd17ca821b7e4b5bb63a8a355c10"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-04-0127-8992a354873a/llmux-linux-aarch64"
      sha256 "c0400b246a674f54d402b299039bc70716539e75ee5c350111ffbd010935d10f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-04-0127-8992a354873a/llmux-linux-x86_64"
      sha256 "b10be9be510bb74a547c4d045f3ab8e4a11e52699faf69315fe55007082102af"
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
