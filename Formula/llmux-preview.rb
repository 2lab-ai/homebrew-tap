class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.08.27.0343"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-27-0343-c427ac580c89/llmux-macos-aarch64"
      sha256 "f97c9db0c8e8307d6fb11df1d2202406c067b4b5751d13db6682b59708ffed81"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-27-0343-c427ac580c89/llmux-macos-x86_64"
      sha256 "5e22bf5f9a77c63e93c42ca6d0180935a5b6d74824d727f18c1c14d57952ee20"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-27-0343-c427ac580c89/llmux-linux-aarch64"
      sha256 "ff6ee353267fc6dcc93b94323ab12193e483f001835f93ed39c466f91ae8183d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-08-27-0343-c427ac580c89/llmux-linux-x86_64"
      sha256 "db12ff7fd2d29ee0eae7e21c886cd3d9414197955127136a0e9cd777535a22fb"
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
