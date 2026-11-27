class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.27.0730"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0730-7e50c843e406/llmux-macos-aarch64"
      sha256 "3d7f2bea261f951e54d0eb2605906062491d85d540329161bc9f5a591f8e87c2"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0730-7e50c843e406/llmux-macos-x86_64"
      sha256 "e67cf195a30239019e8adb112844534a46acb1ad983cd03ea72ba87752316a75"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0730-7e50c843e406/llmux-linux-aarch64"
      sha256 "c51d4608b9adee2c7d371534a28b5847fe171bb26ba34e7d209c732eb5174f87"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0730-7e50c843e406/llmux-linux-x86_64"
      sha256 "f21ffb20a06eb25e4c82fc370173d5884fc9a4d7e9396d9c813422c54681c599"
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
