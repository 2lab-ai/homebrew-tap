class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.27"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.27/llmux-macos-aarch64"
      sha256 "71b9efec9f6c7b6307f3a68971e0caa70f93b34c884aeba0a64d33c200667a3a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.27/llmux-macos-x86_64"
      sha256 "4ee107b7741ad98d52b9242241ed7dc2843d8b22f36834a9b97754b32832fc06"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.27/llmux-linux-aarch64"
      sha256 "db69ba9d2509a94e418b3bafbfc0a7df3a5871319efcf1c4fdd7cfc7cb5f8d88"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.27/llmux-linux-x86_64"
      sha256 "3f81d2d9feb67f439180abce58c1445b1bbb97e3a85e9659f3ebbbea338571c7"
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
