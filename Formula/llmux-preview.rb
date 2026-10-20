class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.20.1615"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-20-1615-7fddcc2b63b0/llmux-macos-aarch64"
      sha256 "cce55127f49a4201e7b84cfbb63bf0ee976580852e07cb38def29b4579daef49"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-20-1615-7fddcc2b63b0/llmux-macos-x86_64"
      sha256 "5654d7672cede7dcb31b4386cb77bcb830be338f74009e257ef04b3f8dab43f8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-20-1615-7fddcc2b63b0/llmux-linux-aarch64"
      sha256 "3e6632e9341a15343d9d83bfa70c87fc5f5311206788920733cd13cd15bac051"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-20-1615-7fddcc2b63b0/llmux-linux-x86_64"
      sha256 "ccd10100c9980924d803348d9654dfdd8dc94b68f465b1553a9bd16da4c01245"
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
