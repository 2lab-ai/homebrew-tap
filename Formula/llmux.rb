class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.7/llmux-macos-aarch64"
      sha256 "0c42a4e809cc778faf5b99dae9067f646be894987e7742197a33793a76137754"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.7/llmux-macos-x86_64"
      sha256 "cedfb2f6353c0b945827bd8315f8b2f22452d09107bfb0a8c316a97397d53cf8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.7/llmux-linux-aarch64"
      sha256 "7ff56b7eff0f99e432b9ef8ddf6c19ee5d4545da83124c21ecbb8a846e7cd83d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.7/llmux-linux-x86_64"
      sha256 "0b6b085c5fccedd99984c1b1daf327ad3c213d8b8171bb2d05dc708d3df3e49f"
    end
  end

  link_overwrite "bin/llmux"

  def install
    bin.install Dir["llmux-*"].first => "llmux"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmux --version")
  end
end
