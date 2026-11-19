class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.19.0042"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-19-0042-f88660a82346/llmux-macos-aarch64"
      sha256 "107d34fb7808db2d7cd8992cdb6364db408adb7123083ee995dcd4e4075ceb46"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-19-0042-f88660a82346/llmux-macos-x86_64"
      sha256 "12d4ae32a28424e42eec67742b68661572e9becaac6840695330b22f72bc2f56"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-19-0042-f88660a82346/llmux-linux-aarch64"
      sha256 "17322bbb537fc9d79c6f5bd7e802cba5d34bee3281cfc8db297d056f29a14029"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-19-0042-f88660a82346/llmux-linux-x86_64"
      sha256 "b0d5a861a9d674d9efc59c9f30a513644758b875e37aba75565ac2d106a443cb"
    end
  end

  link_overwrite "bin/llmux"

  def install
    bin.install Dir["llmux-*"].first => "llmux"
  end

  test do
    assert_match "preview", shell_output("#{bin}/llmux --version")
  end
end
