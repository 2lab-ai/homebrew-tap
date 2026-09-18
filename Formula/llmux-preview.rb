class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.18.0311"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0311-7ef84b1c5d56/llmux-macos-aarch64"
      sha256 "2cf53ec265141baf86749180913f274ba11175f03db42b52fbe86d7c9b412012"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0311-7ef84b1c5d56/llmux-macos-x86_64"
      sha256 "3481b7a4c6c65a2ddf78347b8f1750a8286842efea2f41250695809abeffb95e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0311-7ef84b1c5d56/llmux-linux-aarch64"
      sha256 "0124a4eb43df690b2ee30de1977fe4e3f511d624b61e0fcddbccdd62968d0ce8"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0311-7ef84b1c5d56/llmux-linux-x86_64"
      sha256 "90448e521516b699fb4702f6ef21bb38a1eaf414db0958e22ff6e041edb83a46"
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
