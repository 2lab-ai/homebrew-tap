class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.15.0215"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-15-0215-cb647d31da57/llmux-macos-aarch64"
      sha256 "18ea28a278131581d15d6401ef30f6a3f7bd76f4b12c90f17dcaea78d9b4e5e0"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-15-0215-cb647d31da57/llmux-macos-x86_64"
      sha256 "cab684af7c3e1dcae70539fce23222029131547aa0dea726d30150436d1033a9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-15-0215-cb647d31da57/llmux-linux-aarch64"
      sha256 "457c4b42dee30d28485afca83277ea9d693c0e59bc5ebe8f0a9b8d82d2a3248b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-15-0215-cb647d31da57/llmux-linux-x86_64"
      sha256 "9c00b3a1c308700440e14253664c1ad3045f332d3f08367cfc90355585985a14"
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
