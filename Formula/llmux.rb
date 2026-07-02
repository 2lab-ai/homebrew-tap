class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.9/llmux-macos-aarch64"
      sha256 "8d008d6c89a1188ddbc7881966410440a6dc9a0c5d8d2bd906cc6bac35618ad1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.9/llmux-macos-x86_64"
      sha256 "5f2acd4dde0320850bc4694656711948ec8d78dd2782d7638c16f23a888189a1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.9/llmux-linux-aarch64"
      sha256 "fb98133b778d8b37071c00f5e374599d32e840908eccbf1d92415fa5c75a4f15"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.9/llmux-linux-x86_64"
      sha256 "7101e40e93744f38e5727db945e0fc346a8775ed82fb39b4fb35042a8be8a7fc"
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
