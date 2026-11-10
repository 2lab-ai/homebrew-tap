class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.10.1014"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-1014-92d95224e7b2/llmux-macos-aarch64"
      sha256 "ff66e7d17127a9b92175dbd338201832c633c94205b5c7bec6f3bf2e5522938a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-1014-92d95224e7b2/llmux-macos-x86_64"
      sha256 "d28c63d395a2f922659297edad956734e59760360fdac82e01cc7d224337b609"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-1014-92d95224e7b2/llmux-linux-aarch64"
      sha256 "dfd1fcce46d8bb91b2fbd0ecce372f000011fcc82c4e691a0429785b189d4fe6"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-1014-92d95224e7b2/llmux-linux-x86_64"
      sha256 "1f50e60ef0d85dbc85dee1f10af582e2a656889771df58f61247c299dd2c61d7"
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
