class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.26.1105"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-26-1105-b8e490ffdfd3/llmux-macos-aarch64"
      sha256 "114b5bc68779dc92a37ea69398038bbc57f239bda402e8dd164ecb3dbdc19213"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-26-1105-b8e490ffdfd3/llmux-macos-x86_64"
      sha256 "e1cf6a85ac6f74507663e77191b0a7c7287610ab4de5536290ecca3959cb5fe8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-26-1105-b8e490ffdfd3/llmux-linux-aarch64"
      sha256 "7dcd0ee6c3620a498174b843b07e5ee3b8dca54ba1e2424bcda2b1a19397162f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-26-1105-b8e490ffdfd3/llmux-linux-x86_64"
      sha256 "29950dff72e5d984846c2e7406830601234f5ca81842b4639fa5f1bca6405fd0"
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
