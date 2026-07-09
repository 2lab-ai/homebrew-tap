class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.09.0501"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0501-d24a0ddbf01c/llmux-macos-aarch64"
      sha256 "ac742742f9b3ecf82681c571b2343e0c73e9f315a9de5f34c7e360fe60302f02"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0501-d24a0ddbf01c/llmux-macos-x86_64"
      sha256 "b22a9ecc94afb75a6ceaa544c93a54ffa9743e4fc5c35f0300585a0ca22c1045"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0501-d24a0ddbf01c/llmux-linux-aarch64"
      sha256 "57f3bf79440e5abe45f40e079c32783fd843b0fadbaeeb56119a6870d958a09c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-09-0501-d24a0ddbf01c/llmux-linux-x86_64"
      sha256 "1ae30c684e1227872ef6c5163140d2a80cea7b24aa30aa182878acef9e813db0"
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
