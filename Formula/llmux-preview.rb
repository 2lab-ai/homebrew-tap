class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.23.0757"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-23-0757-f4d2853c24ec/llmux-macos-aarch64"
      sha256 "82dd818605cd00dc1bf3216e02a181e91edd2b5686f40b4b5f8cacd026a2a147"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-23-0757-f4d2853c24ec/llmux-macos-x86_64"
      sha256 "eefa8986d9e1d1c6f0544dc6eda1f8d599e0501e6b20d56314fd0a8ac6852532"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-23-0757-f4d2853c24ec/llmux-linux-aarch64"
      sha256 "acbbaf8f115ce971e5ed89100ad5d7756ad02ea5f458ba6a1cc1a3622ae37a92"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-23-0757-f4d2853c24ec/llmux-linux-x86_64"
      sha256 "7e25f12843d3562ec826aaff6894c133ca422a9f69ab04f414bfa44003445c9b"
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
