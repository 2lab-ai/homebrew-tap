class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.06.0111"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-06-0111-ce179e5e7498/llmux-macos-aarch64"
      sha256 "9c86bba3e91fceae554fbc3bdf8b427cc0f5528415685239bb520fd1ea6145ac"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-06-0111-ce179e5e7498/llmux-macos-x86_64"
      sha256 "220b5d31ac1c42aec7e812f32ce51573eb0be562ad88c77f789fd5523842bae6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-06-0111-ce179e5e7498/llmux-linux-aarch64"
      sha256 "be02f62839643a7c4e3239b9c758a4882a883d1ecdf5afbd2cd2ed8f0cbafc91"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-06-0111-ce179e5e7498/llmux-linux-x86_64"
      sha256 "7a728dfdbdbaa6039f78c46c24918518248435d060336bbf788241c5008bca1c"
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
