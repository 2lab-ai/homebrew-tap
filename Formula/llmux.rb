class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.6/llmux-macos-aarch64"
      sha256 "c2edc8913d44684436546db664619279fb0dacc62aeb97fb1b71525ba5536d5e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.6/llmux-macos-x86_64"
      sha256 "4e707097e99606f2375c215c616512f16dfdf102be7f6e2a90deb5405be60d71"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.6/llmux-linux-aarch64"
      sha256 "26e78027c821e1a0192721c7a3e8463d15ca634fc7ed8ef71bf495fc8f4ebbdd"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.6/llmux-linux-x86_64"
      sha256 "c83e2e3e657d091133f114182f59139b025dd2291b6fbf0b2c5fe9a2de5514c5"
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
