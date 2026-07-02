class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.11/llmux-macos-aarch64"
      sha256 "fe8d213787bf289f4704157f4d68eb150940db5cbd63bc56c73ccc6756050716"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.11/llmux-macos-x86_64"
      sha256 "bfdb32c6adf0882a9ffd4898dd816faff77a8a3a71f47f640e01e5c99c876944"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.11/llmux-linux-aarch64"
      sha256 "2a4200c27d1eef2af5d23c1897e73315ca14fc09072ec949450f12d30a80ffd9"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.11/llmux-linux-x86_64"
      sha256 "9cc9bcff3ae329464710cb173c17077d93780ea96b96fd38cf24d303db5f14a6"
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
