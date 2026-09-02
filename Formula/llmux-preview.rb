class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.01.2349"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-01-2349-2a0319af3b59/llmux-macos-aarch64"
      sha256 "126fa1574e158f733b7cacaee926ab3d20b8f058c45e1502f00ac35bf954e82f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-01-2349-2a0319af3b59/llmux-macos-x86_64"
      sha256 "f8aad6e2dc35c4fe8316e010b26b8fc1938b8fb06b1b7c8d9abe33b30cccfde1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-01-2349-2a0319af3b59/llmux-linux-aarch64"
      sha256 "cbd1205d6df70e6fff32603cf5be36b345fec1b4b1fb19e0a95d338c70f88a54"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-01-2349-2a0319af3b59/llmux-linux-x86_64"
      sha256 "75338a9a35ee9821e5ff490bdc54efcdfa2f9cb23545959c72318d2b5c964bae"
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
