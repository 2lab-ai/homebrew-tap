class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.09.0655"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0655-f5dfb0388610/llmux-macos-aarch64"
      sha256 "74184923e13fec837883077085b2b4cc438ba67e732bc164a42232d47cc44f11"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0655-f5dfb0388610/llmux-macos-x86_64"
      sha256 "137368e564e8b74ba720c7f2566955df4dbe86bda184d3dc0341163eb7584c6f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0655-f5dfb0388610/llmux-linux-aarch64"
      sha256 "b4ae272a8100f0b566f46ee9795fe7e2852eab3234d71f5768d28ad779e4d23a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0655-f5dfb0388610/llmux-linux-x86_64"
      sha256 "4614d39c8eead862d4af9aa6717a7285afcf226928487a14862022bcd92a8503"
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
