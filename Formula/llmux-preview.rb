class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.18.0815"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0815-8e40982577f9/llmux-macos-aarch64"
      sha256 "2d3c72df40b0852919f0545bf5950870bdb4ed65b101f1d467077f531816a65e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0815-8e40982577f9/llmux-macos-x86_64"
      sha256 "94f6d7b274d9d71bbe610304c51a74660cfec446fa788101342540dca6f60e57"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0815-8e40982577f9/llmux-linux-aarch64"
      sha256 "3af4e85d38f42e35b5df367487157aa931b73e6009ebb1f2ffbc6114514a0f25"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0815-8e40982577f9/llmux-linux-x86_64"
      sha256 "58be45d578288819ecdf3d611acc06f77b1e285772adc3c70c88dd503ec705e0"
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
