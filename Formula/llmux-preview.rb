class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.16.0531"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-0531-f79543b7d3f6/llmux-macos-aarch64"
      sha256 "edc6490d2205c255b361351dc7587c972463f99887cf065f5c8c8cfcd74b3939"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-0531-f79543b7d3f6/llmux-macos-x86_64"
      sha256 "bc1eca4119b6b042622172c28ea470bcd88eba236838f5564e335c072f08536a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-0531-f79543b7d3f6/llmux-linux-aarch64"
      sha256 "78fb9db75f1cc51f008f5502908b08720e0c455646becb11543404c3880f36fd"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-0531-f79543b7d3f6/llmux-linux-x86_64"
      sha256 "2cb03a06e0bd0fe61cecf4a2d220106d6310f7c647bf3e9a82bea4ce80f5cdba"
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
