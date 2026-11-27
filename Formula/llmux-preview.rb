class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.27.0447"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0447-c2b526b76d0f/llmux-macos-aarch64"
      sha256 "ba342a227cf54712cdadff303ea14ae6f539c651c6685897672d490c3a916333"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0447-c2b526b76d0f/llmux-macos-x86_64"
      sha256 "3b40863cc605dedc9d104ea9bc6ed6dd3bee3231ba13861c945439cc0eaa8b4b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0447-c2b526b76d0f/llmux-linux-aarch64"
      sha256 "6641c079cb9c05a8cc5df96f987c31ac2ecf5b290a909d85559602637e87a128"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0447-c2b526b76d0f/llmux-linux-x86_64"
      sha256 "983a1e1b179d87f794fb810d17ec72f8fbb2bc1fc88c20993a52f47f8fbb27ea"
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
