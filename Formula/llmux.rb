class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.18"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.18/llmux-macos-aarch64"
      sha256 "3109fd3822e09539ffe90800c9beadccbabdae011d243ac38fa899161003878c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.18/llmux-macos-x86_64"
      sha256 "a33dbea7b6c792ca4e19a323df2f4035eeeb98b7e08bd2285d73e3dbd2bc14ef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.18/llmux-linux-aarch64"
      sha256 "df2bb13ab035c4a41c41de7c3a1f4143a05b35a74a33ed6479ecf039b936bdc6"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.18/llmux-linux-x86_64"
      sha256 "435d30637906f4cb1261993c049c30cecea10a03cfb0c96efcde7ad0d2339e75"
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
