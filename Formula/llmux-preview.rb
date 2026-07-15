class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.15.0222"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0222-56af2123a536/llmux-macos-aarch64"
      sha256 "7eb10aa6f7a4fa2275fc6c04ce2e8f08fdc67c83b65ce554bcc508f7d51a95dc"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0222-56af2123a536/llmux-macos-x86_64"
      sha256 "d60a23e3d5647b50a7e614bd3cf19a1cc1315cc93a74e99b8dec8973f545fcd0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0222-56af2123a536/llmux-linux-aarch64"
      sha256 "c96dc000694149e3c484f519a8ebbde24067785a027eb7b0e115992124600eec"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0222-56af2123a536/llmux-linux-x86_64"
      sha256 "169b315a9f3ddb8d03d8af116ba0729a0721155f6515de9607b8875deece1517"
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
