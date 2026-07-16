class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.16.0918"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-16-0918-f64067115c2b/llmux-macos-aarch64"
      sha256 "141eedc475e8894a71c80ee1ba04e35bda9a7d335db0f44aea8bd8063ec748ab"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-16-0918-f64067115c2b/llmux-macos-x86_64"
      sha256 "e597d711fbf623c88b908b6fad1a33b0213f618a8efdfaaed3190a4500ff9566"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-16-0918-f64067115c2b/llmux-linux-aarch64"
      sha256 "1c8cf55827fbc397c2afd1b65a56773582c61fdfea255d9d72669f24a24046b1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-16-0918-f64067115c2b/llmux-linux-x86_64"
      sha256 "d359c31f695cd8b9659bf3639d3f91a85535623732463dcc0439fd511ca3c020"
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
