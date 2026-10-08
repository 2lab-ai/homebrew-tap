class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.08.0724"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-08-0724-2f4312a5e1af/llmux-macos-aarch64"
      sha256 "43a261500394cf12d99fd2234f2df47ec913d2af25ee1e4913fc74d2c87a809d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-08-0724-2f4312a5e1af/llmux-macos-x86_64"
      sha256 "b3504231f8a874d6fcb35f1152dd0cad6631a065ff825764f6ca5a2cd394dbce"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-08-0724-2f4312a5e1af/llmux-linux-aarch64"
      sha256 "13cdfe696ea9f77efdef37ee332251450fa339fbb277dcfeb777cbd91c768113"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-08-0724-2f4312a5e1af/llmux-linux-x86_64"
      sha256 "046f0ce0bed9ff487d6d8613daecb82f0182879f897a6ca225497c6134fe812c"
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
