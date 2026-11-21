class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.21.0725"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0725-633959b14ab5/llmux-macos-aarch64"
      sha256 "08ebc681d2539179122bd12c3f044d00d2d156126d03557c843a2d0f4e9eceae"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0725-633959b14ab5/llmux-macos-x86_64"
      sha256 "60482d0193e86e9e981cb9bda0b5301bf689ff2a1bbf28cd979c280901fc77c6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0725-633959b14ab5/llmux-linux-aarch64"
      sha256 "4bd389aa860e465cfea96f80fe34fa4ed2b5a62d457866ab18cd101fd2810bee"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-21-0725-633959b14ab5/llmux-linux-x86_64"
      sha256 "de86ec93ece42c5411b1db90d99e9e3b9bb21edb8e4869f9b38ab2f0391af27d"
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
