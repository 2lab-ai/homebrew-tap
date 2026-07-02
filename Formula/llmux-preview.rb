class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.02.1142"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-1142-bf5e30182755/llmux-macos-aarch64"
      sha256 "81e7505d8e72146285da087896e2aee0eee1b9dabbf16a1f0fe4dfd74be5a705"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-1142-bf5e30182755/llmux-macos-x86_64"
      sha256 "387d9c4fe6e56a2915bb0fb45e1ff5c75d6422bdc6c2b1ff315217021374ee48"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-1142-bf5e30182755/llmux-linux-aarch64"
      sha256 "e1f0158c656610263c5f9871002e81a2e25b72bb97902000d43c5c5e6a708180"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-02-1142-bf5e30182755/llmux-linux-x86_64"
      sha256 "0b25c8e7442d51fe94f29c00b3318ecca1ad303ae47fcb1ab9d6b813901f2de9"
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
