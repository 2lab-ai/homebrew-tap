class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.12.1007"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1007-59a1b055d0d5/llmux-macos-aarch64"
      sha256 "cbd6cb865053f16ee80e792eca1ba603195208add8c15bc1ab5b06813b9e61a1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1007-59a1b055d0d5/llmux-macos-x86_64"
      sha256 "456216ccd9e33e67fe00a3ec882c8361a28d106320538b2fa673e03a53cb8aa2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1007-59a1b055d0d5/llmux-linux-aarch64"
      sha256 "8c69489c7906105108a6620dbe4b26f104894370b9d82761626af2aa7eabfe77"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1007-59a1b055d0d5/llmux-linux-x86_64"
      sha256 "79e0b5d69cc2f01f1ed5d18cd05c94034b8052bda07a7f5dfcab36bd73fda69e"
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
