class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.03.0755"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-03-0755-bcc931f1ebbb/llmux-macos-aarch64"
      sha256 "2cc5d7ce44a4dc5335ae43c70156ab7af8521d5764da3b34627d8443a83c661c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-03-0755-bcc931f1ebbb/llmux-macos-x86_64"
      sha256 "f39d257cc802e02c885770d8801bc3af010dc438e21359332f29c38aa28baab6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-03-0755-bcc931f1ebbb/llmux-linux-aarch64"
      sha256 "f686da1cfd99b6a3b01005eb9d19572129b363ce1869938bc9ff1e6042c63c78"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-03-0755-bcc931f1ebbb/llmux-linux-x86_64"
      sha256 "f29b798971f7ddec52e8c9f4beaaa698f8e97c9a7180d29a92ac661ec49e1d12"
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
