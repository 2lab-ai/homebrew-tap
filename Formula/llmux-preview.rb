class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.08.13.0413"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-13-0413-9f9afaf4d092/llmux-macos-aarch64"
      sha256 "a2a388b1d0bc2b8f7c9e745d92da23a56a1fd46435618ec4fef7ff3225fc2b8c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-13-0413-9f9afaf4d092/llmux-macos-x86_64"
      sha256 "7c195f1b748774d250027dbbe9dd3798bf0efe0d4e36a2e476605926eb2fb1f6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-13-0413-9f9afaf4d092/llmux-linux-aarch64"
      sha256 "d48c166390b725b886c13319d2499987e234dbd0c93df69e6af52a47a472cdf0"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-13-0413-9f9afaf4d092/llmux-linux-x86_64"
      sha256 "5cbc6992d33ecd7ccddec0d6ed3c21d8987eea438cf662a64026be3ea6e1cb7c"
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
