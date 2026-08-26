class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.08.26.0731"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-26-0731-494068f8401e/llmux-macos-aarch64"
      sha256 "45570ba46b51a473b1ff6de921b8ee5c051a13cab36f37faaddd2cb42fad319f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-26-0731-494068f8401e/llmux-macos-x86_64"
      sha256 "c51f8ef6d255008ec08c2cdc02bf199df4d86d9aa64ea86d7a639e2df54e3a3d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-26-0731-494068f8401e/llmux-linux-aarch64"
      sha256 "b9458a86927779311be81c14575824492b26cfcd5ff80db91fd26f7334b55a66"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-26-0731-494068f8401e/llmux-linux-x86_64"
      sha256 "948e91a08bfb8b24e5009b5a6d704d9f3a3254e5bf9a0fcae3f6dcdbf25eccc9"
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
