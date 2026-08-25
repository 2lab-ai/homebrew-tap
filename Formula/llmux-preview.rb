class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.08.25.0742"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-25-0742-75055b0ce8a8/llmux-macos-aarch64"
      sha256 "b07efae347c126ee70bb60b5906f2dd7c001e08b8403f80bf44a391e807d97fe"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-25-0742-75055b0ce8a8/llmux-macos-x86_64"
      sha256 "907bcc9449599f784986cd4169b8f821220e45961b26271d5e666f4a6158439a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-25-0742-75055b0ce8a8/llmux-linux-aarch64"
      sha256 "368aff31324e547f303749150422d3fcfd5dac92f49c84af740e270550156f78"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-25-0742-75055b0ce8a8/llmux-linux-x86_64"
      sha256 "2263e854dd83334c177ff64673b47ae0504247c0c8eeadf95f6d9a2aabf00415"
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
