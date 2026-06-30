class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.30.1009"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-1009-5b8ef33aad49/llmux-macos-aarch64"
      sha256 "d7a9e37ecf72bfd400c095663b4df8c5e9b6d969eaf4fc3c07a9b5b7f5ceb8fd"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-1009-5b8ef33aad49/llmux-macos-x86_64"
      sha256 "64d39c315e2f2baa015c033941f0004bacea40dd2999de611115b2b97603c248"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-1009-5b8ef33aad49/llmux-linux-aarch64"
      sha256 "bfdc5a63ad806cffea8f17aa77e335abe2aa20de7272de5ea010fd652100cd80"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-1009-5b8ef33aad49/llmux-linux-x86_64"
      sha256 "2b77f858ca97e68289632c02be30c29e156a0d59bad253caf4edebbd8f7e63b1"
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
