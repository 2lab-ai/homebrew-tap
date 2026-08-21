class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.08.21.0458"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-21-0458-833f3374291e/llmux-macos-aarch64"
      sha256 "61210e7734bdb3f455b7b32b5f54d956da06a3e201f696e96e6a0af3e0bf481c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-21-0458-833f3374291e/llmux-macos-x86_64"
      sha256 "c33197fadc4b87cef24fe9a8b084980aeadc8cd02783a25038dccd3afc6be255"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-21-0458-833f3374291e/llmux-linux-aarch64"
      sha256 "066fb8998b9d8ee5429c71a38ef5cbc51af34e185fe81160f5218ab7bf56341a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-21-0458-833f3374291e/llmux-linux-x86_64"
      sha256 "6aba752acf843a6b9f63de1d6e8290ec66653298b4ce0971ccc11c1fe89bf2b4"
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
