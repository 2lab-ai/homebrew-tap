class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.07.1305"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1305-8029d956d9b4/llmux-macos-aarch64"
      sha256 "3058c21485b9596adb4c944d5cebfb52dd161bd9430fd0c4fc6c3e891f1f9da9"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1305-8029d956d9b4/llmux-macos-x86_64"
      sha256 "41cf19dce86a5543cf11c03999674c64db99ae5723af895248f7ed8b5db1941b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1305-8029d956d9b4/llmux-linux-aarch64"
      sha256 "367de1d472f36d656d317eb6831d3196fe9166d100fb7c276f8697141ca705d4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-07-1305-8029d956d9b4/llmux-linux-x86_64"
      sha256 "de090424919545e41bfbf3460324d5ed9c04210f2e86814abe895bdc0b702512"
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
