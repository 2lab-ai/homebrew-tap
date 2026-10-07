class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.07.2040"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-2040-7fe64d172929/llmux-macos-aarch64"
      sha256 "6b4e9f8d5b9baf779ad576414b54aaacb8122ae34a1822e60acec5cdc083b53f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-2040-7fe64d172929/llmux-macos-x86_64"
      sha256 "c404008bf33a6243c8fdb3c7d1a496e54ce5add52817b13080142a41533b2807"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-2040-7fe64d172929/llmux-linux-aarch64"
      sha256 "8895fba8a02323d50fb613e7227ddbcfe79935508c1bbb9c7e691e2a11a52c83"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-2040-7fe64d172929/llmux-linux-x86_64"
      sha256 "91a9e2366ab8e768960ef8ff906bb13b5f2f7967b0b7deb2adf16e6cac7f0595"
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
