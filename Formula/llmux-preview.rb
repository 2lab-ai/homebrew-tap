class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.17.1405"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-17-1405-aab485ff55e8/llmux-macos-aarch64"
      sha256 "ab2caccd1a386a858413cac495d89092da44cdd1b34e3c4d72d63011925f54bb"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-17-1405-aab485ff55e8/llmux-macos-x86_64"
      sha256 "18dd380a8c6cdfbad28799049aef1123336434b25b127ec0606e63b527cd15f9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-17-1405-aab485ff55e8/llmux-linux-aarch64"
      sha256 "bc6f1b6f4cd8a74832f262caf5503cc04041f40a9662235667e4a2cfc95b58d8"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-17-1405-aab485ff55e8/llmux-linux-x86_64"
      sha256 "a9a106b944cdc712f5231fbeac2aaa908134ddf25144b473df684fc6e54fb502"
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
