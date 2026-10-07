class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.07.1540"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1540-7af801805396/llmux-macos-aarch64"
      sha256 "7a98ec530f12ef825ffc3271f1a2fb94bd7f92aa48b4eccf83ca7bdafb2bb67a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1540-7af801805396/llmux-macos-x86_64"
      sha256 "74d54602daf7a4d3efcc1224e517039e46309763c9e941d0326ba66aa72c66f2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1540-7af801805396/llmux-linux-aarch64"
      sha256 "f19ea65a10c0ce354541a2cbf2e6c86821b277420d1732f906002a6d67dc0eb2"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1540-7af801805396/llmux-linux-x86_64"
      sha256 "c8192aa455110e42d44b68dcdd4e99dd4b524f01fe7cc6cc9d41e03dbeec62d6"
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
