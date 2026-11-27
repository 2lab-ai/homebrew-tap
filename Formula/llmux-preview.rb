class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.27.0538"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0538-e0309fd10659/llmux-macos-aarch64"
      sha256 "55d68ec632301d7fc5268f5caabe9a43954d4f1d63213137ca19cb8053f6a66d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0538-e0309fd10659/llmux-macos-x86_64"
      sha256 "6a37da66cbdbd716a2bead83a2cfec08577b0a455b49f57cf6c86029d9ccf528"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0538-e0309fd10659/llmux-linux-aarch64"
      sha256 "bc247c8a7f203926922fd3c369ffe4118ad85a7123aea98a01cfce4e6ffa3e1a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0538-e0309fd10659/llmux-linux-x86_64"
      sha256 "e78e993bc75adad10f51fa29954bea48f8badcee675e1b7e235e242280953039"
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
