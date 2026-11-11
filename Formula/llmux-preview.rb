class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.11.1130"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-1130-39465ca90547/llmux-macos-aarch64"
      sha256 "acba398ceeda02260bc63f5d203f714f4752f50e6bb32b824efbfe8366697f8e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-1130-39465ca90547/llmux-macos-x86_64"
      sha256 "4559a41fb238f24044cf1eacbca4161da2bc488ea43aab7d1429ef6bb8204a74"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-1130-39465ca90547/llmux-linux-aarch64"
      sha256 "33c05b17fdcb4d1e0ee4a61a911e31e83e4a71a1cdaf9611d3105f0ec5db85a8"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-1130-39465ca90547/llmux-linux-x86_64"
      sha256 "6131a1a87679c0a7b42a450702b9fdb67f9823ffbf144fd2e4350c239af3e0c0"
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
