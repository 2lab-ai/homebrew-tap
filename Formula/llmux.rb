class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.5/llmux-macos-aarch64"
      sha256 "b3a3ca2ede13734ad85b13548b4eb2f96d79c43ec7bbf5e85bdd7b54f5550eef"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.5/llmux-macos-x86_64"
      sha256 "86a5ab721e2ea0a8a0becdfcc169ef7474a67c7131a6bc44ccab4087c2f5ac3f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.5/llmux-linux-aarch64"
      sha256 "48b4c4445e8a5f98f20799b617f615a0bb93f365fc26bd0e5cb7474c0c2c37d7"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.5/llmux-linux-x86_64"
      sha256 "b64bf564ae48c2e164a717a3e1139bee33af0795a4377b78b831d63a0673ea37"
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
