class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.15.0502"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0502-abd68fb671b5/llmux-macos-aarch64"
      sha256 "906c3e56f3ec0e8b04c36295cab1706b85dbc07a29112ee31ab2482deb62f503"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0502-abd68fb671b5/llmux-macos-x86_64"
      sha256 "5d1fee0f9cd738bd9302c2963585389fa6f79241153fe1d9f9230dda9a29d107"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0502-abd68fb671b5/llmux-linux-aarch64"
      sha256 "9999264cafb95c496c46f2ac17f3ad4b0eda3b3c8e1e9dc11324df4972e455ac"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0502-abd68fb671b5/llmux-linux-x86_64"
      sha256 "59911bde7db544351ead603008c79979b6d2e02e14507bd52d01062b36af4676"
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
