class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.23.0823"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-23-0823-4f131e261a0a/llmux-macos-aarch64"
      sha256 "c236b781379b16b0a9ad4ff3ca68f8d3be3d37e037cedf310ce7716119ba1bfa"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-23-0823-4f131e261a0a/llmux-macos-x86_64"
      sha256 "2d4dfc9d2c1702acd31267682fca1095f3ab5400036362dd1e31b0982263a81b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-23-0823-4f131e261a0a/llmux-linux-aarch64"
      sha256 "6e107fd0e4770f61446d5f61d5c89b7b2a4e0a57ea5563ba974962753f1d51db"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-23-0823-4f131e261a0a/llmux-linux-x86_64"
      sha256 "08a86676dca1ee5ddafd4e92a399ed062358637505a8448916c4eceefcb53340"
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
