class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.10.0657"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0657-209731b5c7df/llmux-macos-aarch64"
      sha256 "178586b4cc6f737d47a00152fcfbd6a8c1715dd3ce620a1feaed0c2a411f1a25"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0657-209731b5c7df/llmux-macos-x86_64"
      sha256 "b533155f7e5d07a247e8d1f33f685865e71910202bacb9b9868de09d6f451606"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0657-209731b5c7df/llmux-linux-aarch64"
      sha256 "eaad521261c8f12adabb2a0f2456b4cdb5d5ea13a07c95c8a3c4f49304e655b5"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0657-209731b5c7df/llmux-linux-x86_64"
      sha256 "0adc943bed49c9d5775801de07592812bf91931e683dbcae18a3e750637037e3"
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
