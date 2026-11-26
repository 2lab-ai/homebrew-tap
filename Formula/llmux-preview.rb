class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.26.1311"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-26-1311-eaa6ea93176b/llmux-macos-aarch64"
      sha256 "026b576f8139756def1ecef01640c8403c3a7f23d03af9175deee9e05151a941"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-26-1311-eaa6ea93176b/llmux-macos-x86_64"
      sha256 "2752a49f195f76c32b029f3435d405a9124e4de783b07734caf6e4e943fff12b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-26-1311-eaa6ea93176b/llmux-linux-aarch64"
      sha256 "bd2541cbc015332488ae1f8c08eaed64403a41c737b92da3491e949aa08509c8"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-26-1311-eaa6ea93176b/llmux-linux-x86_64"
      sha256 "120d1fe8e967201387a46bee2733f95f9a41fcdbfbb1b9fc93ae06866bab23bc"
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
