class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.13.2311"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-2311-bb286e628918/llmux-macos-aarch64"
      sha256 "2c6410abe9777b61e8151e202aecf991966c526bf7b6aed8bb481665d375a4ce"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-2311-bb286e628918/llmux-macos-x86_64"
      sha256 "5f9e3e95e2a4f0112e58b978ed16cc63760e40dc7cd277a1afb2f1e8a5693f57"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-2311-bb286e628918/llmux-linux-aarch64"
      sha256 "3685d931931bc945a0fe75d15406bd518946dee54d19d1d60cf60175bae64bfe"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-2311-bb286e628918/llmux-linux-x86_64"
      sha256 "c279f6136391521d879c7e56431664c51dd21ad68e4f760a2150bdbc6e12ecb1"
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
