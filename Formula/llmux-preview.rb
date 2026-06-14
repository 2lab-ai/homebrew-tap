class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.14.1416"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-14-1416-228bd35d366f/llmux-macos-aarch64"
      sha256 "8c9ff7bfaab3d2875cdf85f7985a01e6bc9b21aeeff7860c8ab65a7295439126"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-14-1416-228bd35d366f/llmux-macos-x86_64"
      sha256 "f8438199ab2caad8d9a4fd086fe47ea3d23408a8d71dc799d24b7c189c9cff98"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-14-1416-228bd35d366f/llmux-linux-aarch64"
      sha256 "c210414e5573511072ff2b5f7c1965ae9ac18e707dfc73aba544d29fb18b13ee"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-14-1416-228bd35d366f/llmux-linux-x86_64"
      sha256 "477939951db580ca7a16062c7d6b5166c1dd0170ea135086d5ff3c58cd90b1d9"
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
