class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.17.0329"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-17-0329-1a37680c7ee0/llmux-macos-aarch64"
      sha256 "a51c5adfa32286bb7d0f3cf027181da05f8e5ff21dc3d4582a713b992eaad21c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-17-0329-1a37680c7ee0/llmux-macos-x86_64"
      sha256 "66e05fe20a36b64b7f36699d7d47195d533fefc61e96bce8b5b217f557fee9d9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-17-0329-1a37680c7ee0/llmux-linux-aarch64"
      sha256 "051bebf6a2b199cd3a53a050c463df2cd69c452081bd113789210bfacf1873ef"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-17-0329-1a37680c7ee0/llmux-linux-x86_64"
      sha256 "0cca7e33f6b256deecd617449e638ca780cfca23bd37fc9774f7c5d112d32f47"
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
