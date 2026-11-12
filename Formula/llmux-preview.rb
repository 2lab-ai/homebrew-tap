class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.12.1147"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1147-92e7fc5fa98e/llmux-macos-aarch64"
      sha256 "5af347ad596395c760003840cd6cdf4bc3228b0cbe8af907bf2c9a5dd67f59d4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1147-92e7fc5fa98e/llmux-macos-x86_64"
      sha256 "185ffbf90ea57c78f9b703c4d8644c78dcb34c2fc0de54af2e7ef64176fd231c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1147-92e7fc5fa98e/llmux-linux-aarch64"
      sha256 "82a6ead89769e521a3590b6e3d4b14fc1fdbdf5185a30dc969e630c34177d4a0"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1147-92e7fc5fa98e/llmux-linux-x86_64"
      sha256 "7d32229fb4c91a94cf25af43063d054d8c239c24ccc791cd616ff92fda059dd3"
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
