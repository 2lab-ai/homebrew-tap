class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.06.16.0936"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-16-0936-6c0b43eeede2/llmux-macos-aarch64"
      sha256 "19f640d7783e5d96a8e964bc4fff8db5dd72a40bdb025501336d4b90e90e3d3e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-16-0936-6c0b43eeede2/llmux-macos-x86_64"
      sha256 "271babe046ff2329499b6a5b8e6e961f4089c30cb28073dad3ce9be2450cc606"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-16-0936-6c0b43eeede2/llmux-linux-aarch64"
      sha256 "df24e93556f2e911de1fd30843dd4a3a36c438cf65de0d3babc1177829bebaa9"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-06-16-0936-6c0b43eeede2/llmux-linux-x86_64"
      sha256 "fe5672dd2925d401e5d7e1d856ded41356ad9e695d4855be2f0b2f08754ccfdb"
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
