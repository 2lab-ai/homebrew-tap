class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.08.0306"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-08-0306-f95dcb75dd51/llmux-macos-aarch64"
      sha256 "70712d740390beec87f56f830a44c45640d0dc7725798567d27209b74683a381"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-08-0306-f95dcb75dd51/llmux-macos-x86_64"
      sha256 "f24f3f6dd1bd990bab5cf6479c3fd1cacf9edd362120c7bb616345bbb3cc7413"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-08-0306-f95dcb75dd51/llmux-linux-aarch64"
      sha256 "17c205bfbda65cda2038fd924dc5e0d9139299bb8e421565d22e7fcb78f9884a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-08-0306-f95dcb75dd51/llmux-linux-x86_64"
      sha256 "edc9c4111326d54f0e6734c011dab2cc2a7129bc1076806397bab75d1c8b96b5"
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
