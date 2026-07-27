class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.27.0302"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-27-0302-1de124c5be85/llmux-macos-aarch64"
      sha256 "c661009974e6b23289d565b9859e353d27d285d9ca3c1971581ea282d3f36f52"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-27-0302-1de124c5be85/llmux-macos-x86_64"
      sha256 "8c895e2be48f569074fba5099d1b6353c131c6e6037536ba3d82d95ccc1b8aa5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-27-0302-1de124c5be85/llmux-linux-aarch64"
      sha256 "451c489b01d793d0ed54e0e6679e1dd63868b159cec2d135ca4533822b7b035b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-27-0302-1de124c5be85/llmux-linux-x86_64"
      sha256 "639012ca916e9c4c38f6c4c852209267500564077e4f2ed87bdac9352de6f43a"
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
