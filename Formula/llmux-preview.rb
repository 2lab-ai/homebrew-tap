class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.13.0831"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-0831-3bed30be283c/llmux-macos-aarch64"
      sha256 "6a46bcf4099fa355396cc04bd0083f803bc6a66be0b2261892f7b7d503315590"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-0831-3bed30be283c/llmux-macos-x86_64"
      sha256 "a34531318319ed8bb5b7571be8bc54e1252e6edb9691ad7dae232db32271981c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-0831-3bed30be283c/llmux-linux-aarch64"
      sha256 "b4df86a3bfcbf553fff8d55feef9983d6c455362735c8f26af5ac30780685f44"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-0831-3bed30be283c/llmux-linux-x86_64"
      sha256 "36b8c2f7dc790dd94bd452fac252b270ccf49af68208fc2ebac8bc4162c38d24"
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
