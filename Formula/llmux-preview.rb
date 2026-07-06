class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.06.0227"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-06-0227-dd24a5f15f17/llmux-macos-aarch64"
      sha256 "2039e7309ba7374ce0bcaa31beb7c56a9dfa4e938e4604111ebafefb1d2aee30"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-06-0227-dd24a5f15f17/llmux-macos-x86_64"
      sha256 "dda7d5de44fc8ae41b4223f86b6feb5840d64dc3f7999dc22e6218f8ad8dceb2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-06-0227-dd24a5f15f17/llmux-linux-aarch64"
      sha256 "95dfd234451202c107ef78b9d645ac811f5232ba08453f1bbd83569f10538b54"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-06-0227-dd24a5f15f17/llmux-linux-x86_64"
      sha256 "661a0d7207b004dba934e228613f507abf4fe6ef76db6c3ea7d36b037dc62018"
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
