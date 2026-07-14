class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.14.0806"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0806-fcad7a1ff5e6/llmux-macos-aarch64"
      sha256 "29740ffa19a3013141298b0ecdc985bc4292b7c190042cc5b966cf92b8ec2975"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0806-fcad7a1ff5e6/llmux-macos-x86_64"
      sha256 "6df828783da75ad4cc5d6e6f0d9ad0ddc4e5555d5e5afedf00aa3c71d21b3b3c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0806-fcad7a1ff5e6/llmux-linux-aarch64"
      sha256 "a269247555bf1f36c10cdfa65eaab85d05f45fecb70ed77e955dfdb3e385e430"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0806-fcad7a1ff5e6/llmux-linux-x86_64"
      sha256 "4de23c394e2af998e4c1953512e2837153285affef8e65c15fea3e94fcf39027"
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
