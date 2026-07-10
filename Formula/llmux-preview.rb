class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.10.0647"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0647-61b869691714/llmux-macos-aarch64"
      sha256 "5c6b316dc4efe633838d90ea5fdaa9b57acce9d9e332b68b2bd4aa6d6ff4311c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0647-61b869691714/llmux-macos-x86_64"
      sha256 "0d2be668ed16bea6a4fc72065261284bc529dca8a853f99fffd5d6f97150514d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0647-61b869691714/llmux-linux-aarch64"
      sha256 "f8ccca7ea022c428f7d3e3c95dbfdcf961b827ca268286e33a7302d4e313f866"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0647-61b869691714/llmux-linux-x86_64"
      sha256 "cd0b00f188b6d824c771ad9a4ce3e13dbe898b2a01f758a8344fc579cf798925"
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
