class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.10/llmux-macos-aarch64"
      sha256 "bc9a5f223dcb713aefd231a67ca0a45fd8bd377ef2c8a4c5c16284d3eb6d8390"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.10/llmux-macos-x86_64"
      sha256 "dce9ae91e1b7a7420b948bc8ab8cf65a4c59150ae9211eec5c4e8ee04d3dc89d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.10/llmux-linux-aarch64"
      sha256 "1cb39b3e6e6cb9b423f3e03881f0f1145cd3d0497490db9d060b9f69f58b2b9b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.10/llmux-linux-x86_64"
      sha256 "5efdbff0afd957f9a141bb91556f1220dcb60b95df36740b5e1abf44fc24254d"
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
