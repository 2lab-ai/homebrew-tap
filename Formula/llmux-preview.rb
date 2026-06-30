class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.30.1001"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-1001-1029b7e048f9/llmux-macos-aarch64"
      sha256 "226805367d6477c55123f1065134c3074c378fcba3c13aacb2a02346413a499c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-1001-1029b7e048f9/llmux-macos-x86_64"
      sha256 "0a3f6937a842c8d4dec88cd190b9ed1cdb14f2e83ab92ab1b219d4d02e614156"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-1001-1029b7e048f9/llmux-linux-aarch64"
      sha256 "45e830abd7dfb87791acfb9f92dfd9a2671de93f5ac2bbd0ef1c3e8c40a3905e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-30-1001-1029b7e048f9/llmux-linux-x86_64"
      sha256 "2e938d564e2a6c4748b2604db6edcf3abe4c794d83936b82d73c707645c0df1c"
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
