class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.09.0534"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0534-0fd3c56a331b/llmux-macos-aarch64"
      sha256 "3f88b3d54a0d11ae16aad5f0b0e5c29f76d2f654be1c53992e93fd2a3545997a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0534-0fd3c56a331b/llmux-macos-x86_64"
      sha256 "b99dffae89e0ba210c9c98820598a416ad7faec0a4cd830beecbdee90f9fa6ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0534-0fd3c56a331b/llmux-linux-aarch64"
      sha256 "13a07068298e43d4a395636285224d0194e1f8d47568b7f91f1e3f4846a076b9"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0534-0fd3c56a331b/llmux-linux-x86_64"
      sha256 "bf64e6f08065984b51402cce96c62878594f4724410f5a28e23a039375412140"
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
