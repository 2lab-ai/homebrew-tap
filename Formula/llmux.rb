class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.12/llmux-macos-aarch64"
      sha256 "4df42dd99101a544e02ffc3ca795847107f09156981b95d96867abb38b3ec3bb"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.12/llmux-macos-x86_64"
      sha256 "2ab659087269ac1ee6b1fb66954cee43c8ae0c013a6fc4018feb71654fc36f68"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.12/llmux-linux-aarch64"
      sha256 "c6ecc24eb9add69d16036b2c94762b81eaa4fa23f79dfbd078d6cf73aaf0011c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.12/llmux-linux-x86_64"
      sha256 "ea9ddf6cbdfa3d873f5f7710cfe8410bc97f5d3dac954917051cdf03d5311740"
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
