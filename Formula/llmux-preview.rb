class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.06.0353"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-06-0353-bc720a90de96/llmux-macos-aarch64"
      sha256 "12219103c90673d5caea59d03ca9b4c13843d003cba8c5c07d6b9e06777b9f9c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-06-0353-bc720a90de96/llmux-macos-x86_64"
      sha256 "26b94a9b159dc40e7aaa76d7620b5fae7385cf7e9129e4d4e153852c02538892"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-06-0353-bc720a90de96/llmux-linux-aarch64"
      sha256 "937b80b9d1c44cd8a3786ca5e043ab60a3fd4dbc1592e25357f02465a4631b31"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-06-0353-bc720a90de96/llmux-linux-x86_64"
      sha256 "593e2b4dd797a04f0e5af4f57ac1ab8d47c50e0404dcbb7de516686cac5479a9"
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
