class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.14.1138"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1138-39503887cb1d/llmux-macos-aarch64"
      sha256 "997eb881e4f5266c945d7a0b102ee497d64de5c181f9f6110c89eaeb5e256268"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1138-39503887cb1d/llmux-macos-x86_64"
      sha256 "9e641926d67456622559e02e6f7846f219226ece1b52ef3601ac4d7c9b8d6481"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1138-39503887cb1d/llmux-linux-aarch64"
      sha256 "4c0369d898e204a06bed2d3a972feca9095bf9ee65d28b252937de5985927beb"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-1138-39503887cb1d/llmux-linux-x86_64"
      sha256 "01dd101e73419e87d062dad73d17c5e9f534578877cb299b24d8de1d979d4125"
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
