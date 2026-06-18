class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.3/llmux-macos-aarch64"
      sha256 "1821af407454158c9c351d45bfa4d8ceb85766f8adb73649294259ecdf8eec6e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.3/llmux-macos-x86_64"
      sha256 "41382ef77ec12e62f1870c3560d40a127816e23576dbc19a467fea98ecb02034"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.3/llmux-linux-aarch64"
      sha256 "c111854b3675abd8a20e55d3aa923f0ab2b0c85fcfd55c89eaa8cda539fc3319"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.3/llmux-linux-x86_64"
      sha256 "3b5d01525e10c3a20dea4083ce4b86a51a5afd3fb356860a8e1067d06a35e6db"
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
