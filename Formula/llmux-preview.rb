class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.25.0602"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-25-0602-550dd10d6aa6/llmux-macos-aarch64"
      sha256 "08a9a603df3a12cdb15430c4bda249b49ba59f967cec49b971a8b2856e46ece4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-25-0602-550dd10d6aa6/llmux-macos-x86_64"
      sha256 "f923a84dcf48df23633c63c8634cdd83d7e2391e19980d2d360ebaa433ef5a51"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-25-0602-550dd10d6aa6/llmux-linux-aarch64"
      sha256 "7a1b9d8bef207e073e8968aff5945747773d37123c324e76a2d799c7c54b0e80"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-25-0602-550dd10d6aa6/llmux-linux-x86_64"
      sha256 "c59f681eade5e6ffe3ad1159235793c83f4ba66618f706daeef93cc837d98aac"
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
