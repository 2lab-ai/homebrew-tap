class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.16.0720"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-16-0720-dd0dcc5a02ea/llmux-macos-aarch64"
      sha256 "8ebbe63139593c87cecd65cf04dcb0f172614eed82990dd6751af7f485879859"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-16-0720-dd0dcc5a02ea/llmux-macos-x86_64"
      sha256 "82398bc747f8d49c9ac6bc1dbaa71c0bef5006df3b1c3c1423150ad68ae67e8a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-16-0720-dd0dcc5a02ea/llmux-linux-aarch64"
      sha256 "9b37f91c0dd792ec7d2454adeabecf4169bb3783baa56ca2e897612a21803e35"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-16-0720-dd0dcc5a02ea/llmux-linux-x86_64"
      sha256 "e25b447fa273bbd5a71b9acdcf6874ea8b6768e6bce8ec59615ce8ea498e114d"
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
