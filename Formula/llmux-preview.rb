class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.14.0902"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0902-5f85af4b8cb5/llmux-macos-aarch64"
      sha256 "556e53b7fa436c4b82278f7f0965a69808e837a1ea235537fad1fe0ef849da2b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0902-5f85af4b8cb5/llmux-macos-x86_64"
      sha256 "6980ae5655201a46850bb776f1b71331b67abef62ecf20ec2b9f9be4271933c8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0902-5f85af4b8cb5/llmux-linux-aarch64"
      sha256 "923e0d9896b6e7f86021a48be261e1266e2f677d18f97ec5828fc60b97985390"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0902-5f85af4b8cb5/llmux-linux-x86_64"
      sha256 "3fd13af8823b7d8911875715abd8c6941362da5e8bd12999917f609ff8b39134"
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
