class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.14.1135"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1135-d9cf0de4ce15/llmux-macos-aarch64"
      sha256 "3e7da0d5a35c2933b987f9131014726d91ecf910f9e8c3139aedfd0721612f67"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1135-d9cf0de4ce15/llmux-macos-x86_64"
      sha256 "0861e6457e3cd4701eef3a10748424d13cf6b0d29bf0d9da62d31e7814149791"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1135-d9cf0de4ce15/llmux-linux-aarch64"
      sha256 "34936f9a4737fd5123a0f82329ecf8a9b04c3a255e096b853ad3667ee04bffc7"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1135-d9cf0de4ce15/llmux-linux-x86_64"
      sha256 "e614b1d289853df61bae8ed4fb4c195ed7b6d92e3dfcbd751bd9ea2f5c54b716"
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
