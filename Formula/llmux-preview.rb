class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.08.13.0557"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-13-0557-41828c673527/llmux-macos-aarch64"
      sha256 "ba63c3cee2b822d2809caf33012bce6e3c8d0a584cffcb3cb6d8c5a4b31fd69d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-13-0557-41828c673527/llmux-macos-x86_64"
      sha256 "190afc4e0831454bd170a5fe97999d958b04474e46b33960291aa061306bc115"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-13-0557-41828c673527/llmux-linux-aarch64"
      sha256 "817f9c91bc736e80dc518696711111e70c6cc2d74f9785072823d3a6da82225c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-13-0557-41828c673527/llmux-linux-x86_64"
      sha256 "ed35c3294369d9b303cadb2773970585ca9b8ed419459385ec68d74da734266b"
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
