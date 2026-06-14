class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.14.1135"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-14-1135-c883c7218837/llmux-macos-aarch64"
      sha256 "3d33e0d51cf6ef7d989e9d7c0315bdffa58bd99f0416186b1ad43732b805fcec"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-14-1135-c883c7218837/llmux-macos-x86_64"
      sha256 "aa2d8ff2abca9d6fc5ef9f5d089219e02ea70e9ea4b925c3d5a56b31ff21ddef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-14-1135-c883c7218837/llmux-linux-aarch64"
      sha256 "30db5955466fc42b2ecb2b516ccf0b401dc1fcf4375eed666774b44baff36335"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-14-1135-c883c7218837/llmux-linux-x86_64"
      sha256 "7ed78f3e42eb5cda4ebcc669c2d2085ecacd938d7e99fe4ebd286f8642add631"
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
