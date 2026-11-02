class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.02.0422"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-02-0422-36334a2985f8/llmux-macos-aarch64"
      sha256 "ff27f6d30b55ac656e5161f6370d6759491a8e5efe6223fae7e14363d1119ab5"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-02-0422-36334a2985f8/llmux-macos-x86_64"
      sha256 "0bf00813229becbbc0174c2bfa0da4bcba0253f6bc9a98da2a41f15a21782265"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-02-0422-36334a2985f8/llmux-linux-aarch64"
      sha256 "5a3cb0a57ca8f4a6d0fbcc30edc4cc09fe9f3bfa6724ff8e66d679e9c2dcb500"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-02-0422-36334a2985f8/llmux-linux-x86_64"
      sha256 "944f4eff493b36e75b539c5fa21d6be06990eed0538c5e14102107469deade7b"
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
