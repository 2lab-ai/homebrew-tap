class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.08.1401"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-08-1401-f072597edb13/llmux-macos-aarch64"
      sha256 "5051eed1395c257798d5a1f01bf8c2e1902173e386d0c93f9ba6f0a14598e5c1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-08-1401-f072597edb13/llmux-macos-x86_64"
      sha256 "f1109206139e1b2306ea99a829667bd58248c96ff68d38f6217a54536d1f1f33"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-08-1401-f072597edb13/llmux-linux-aarch64"
      sha256 "82ac229a2062d92a21a5eb6d29af8b5355bb9dcf8948ec09512959a2e2aebcd3"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-08-1401-f072597edb13/llmux-linux-x86_64"
      sha256 "88ee52bd4bd6c83ba4f05f209df14aa1a31f7e4ee4f1ce4239d659967243808e"
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
