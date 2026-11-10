class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.10.0928"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-0928-c96b38bfda54/llmux-macos-aarch64"
      sha256 "e521a82473daeaa790f83bcd68f3cbb51fa9040f8ae54737ce2bee577c1a10b1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-0928-c96b38bfda54/llmux-macos-x86_64"
      sha256 "075a6042651a5c5af316e86ab95f2e26c0d2cffca31ad40fb7bfde145a4a81a5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-0928-c96b38bfda54/llmux-linux-aarch64"
      sha256 "a073aa1a3295b6d5784f8bb8e7d392c32cf7fdbef312f7e649da98b3d89bbcb2"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-0928-c96b38bfda54/llmux-linux-x86_64"
      sha256 "ab9e632668e6a50194e5226638667edf9a197502a0d203377d832b09b2a830e8"
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
