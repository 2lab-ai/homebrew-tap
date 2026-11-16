class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.16.0553"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-0553-1599f2a97e48/llmux-macos-aarch64"
      sha256 "e6ab99e932ff7091374afd4d7f4387446a839794531493344f566b46f5519d8d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-0553-1599f2a97e48/llmux-macos-x86_64"
      sha256 "28a6ebdbbe4c07208627b7a9edac1bf093593cb41fdf9f427125d3199df29305"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-0553-1599f2a97e48/llmux-linux-aarch64"
      sha256 "e5089720224267b22ab5ec6e1982d973ab92377e91e6007408a535b27ffdcc25"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-0553-1599f2a97e48/llmux-linux-x86_64"
      sha256 "bea8df2e807f6320b4e71c5b337c759e2a936f8596f0f8b532e646a629cca108"
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
