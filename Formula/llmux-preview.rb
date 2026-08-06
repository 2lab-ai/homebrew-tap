class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.08.06.0324"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-06-0324-f7049a506eb4/llmux-macos-aarch64"
      sha256 "81482cce30658b6b237ea8e9f2294b78f8c78e903325e23497867f4a8589f2aa"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-06-0324-f7049a506eb4/llmux-macos-x86_64"
      sha256 "d3bb9e77123671dc25217d01b6071751ef1dbf3b6bc47fb0d45ea540d0fb9c3c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-06-0324-f7049a506eb4/llmux-linux-aarch64"
      sha256 "26b42fab945ebbb23731b0ed90da878b23e2da0b7ff1c36528e12d34912f3c66"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-06-0324-f7049a506eb4/llmux-linux-x86_64"
      sha256 "11a27a0ec72310d5505b70b41aa387ff59d1979a41981703e66cce3e5b4bbbbd"
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
