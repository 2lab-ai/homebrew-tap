class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.21.0113"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-21-0113-92572acbff68/llmux-macos-aarch64"
      sha256 "25255e066ca2fe5445006d51104aa29ac66c317a003f9e9f073d4f79cdafdd89"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-21-0113-92572acbff68/llmux-macos-x86_64"
      sha256 "a421f11a923c7b8f7c044f3b922f279c4527ebb9612880d61ce5e0599b93862d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-21-0113-92572acbff68/llmux-linux-aarch64"
      sha256 "3bbf5f99ae34fb9b1bcb53dc8553caec7d744cadb414479d231776a4562aeba8"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-21-0113-92572acbff68/llmux-linux-x86_64"
      sha256 "5cacb5c55f90699b1ffecd2c17d3cf60d1ca456d0c8e0f2da71f4bb37e3b1065"
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
