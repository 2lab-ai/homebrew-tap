class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.15.0648"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0648-e023b2197d52/llmux-macos-aarch64"
      sha256 "ea404f1da5775c46063366063e9cbbf82febc93085212887f3cef7b77fa9b255"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0648-e023b2197d52/llmux-macos-x86_64"
      sha256 "155e573afa39e35cec881c742ff21c516a5383d33273f74122ef37678706a5e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0648-e023b2197d52/llmux-linux-aarch64"
      sha256 "8c2d111fbc4886e9a4f43924d1017b2d827be543e3345b91f8f599935c2de19c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0648-e023b2197d52/llmux-linux-x86_64"
      sha256 "4b2249ab15238068f911092e20f6d2498131a729d5c972c6f6d069629b90dae8"
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
