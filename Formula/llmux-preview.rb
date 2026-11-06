class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.06.1140"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-1140-9bc72a440ae1/llmux-macos-aarch64"
      sha256 "3721214bfa1a31f265cfedf10d084155775afda2d3639f56989c3caeda8bc3f6"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-1140-9bc72a440ae1/llmux-macos-x86_64"
      sha256 "b1ae6ce00290501aa97427d9c5f4139eb2f7d399e6cc5fd6df202e596ad0b452"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-1140-9bc72a440ae1/llmux-linux-aarch64"
      sha256 "ea44b997fcdff752768681f53c41732a8f7f48680655619f16623ced5d4573a4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-1140-9bc72a440ae1/llmux-linux-x86_64"
      sha256 "a2f08c25c78af4c5bef2e9c85b323f718484b3ca66185c8c93fb07852cb9ca25"
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
