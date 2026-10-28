class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.28.0521"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-28-0521-1734ab000341/llmux-macos-aarch64"
      sha256 "268b1d78a659fe560a4d1fabdc4192b4f2f42baa946d4f5bb6b2f925548b5d13"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-28-0521-1734ab000341/llmux-macos-x86_64"
      sha256 "3175560b29554ce0d3a59500de41671c16d632e983198cddaa0aa2339827ac3d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-28-0521-1734ab000341/llmux-linux-aarch64"
      sha256 "23bec0328ca8f746d3b0be5df4388cc73769978a16ba433dc53cde3feeb671c4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-28-0521-1734ab000341/llmux-linux-x86_64"
      sha256 "1e2d4a483ec713d35041cb86fa444e5140de5dbb7d804bde7fe4878b16f42d75"
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
