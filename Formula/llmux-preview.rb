class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.11.1015"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-1015-6fa1147ca2b7/llmux-macos-aarch64"
      sha256 "49d334f13c8b68b0da91395fb458fc44dc78e869d8b5c8446b5cae1f80d8babd"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-1015-6fa1147ca2b7/llmux-macos-x86_64"
      sha256 "2d17668120378e04fabab1c5ef7334a01e6750ab9370e8581432e1c18674ce60"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-1015-6fa1147ca2b7/llmux-linux-aarch64"
      sha256 "c09c9fb5ab58f0a8dc9b3708a2f35522d15984848f1128f135f0bb50ec7f4c3b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-1015-6fa1147ca2b7/llmux-linux-x86_64"
      sha256 "b77fdc87bb9465dee9d5a94d68d8d288adbec311cf42e6a78a5467bb19f3ff78"
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
