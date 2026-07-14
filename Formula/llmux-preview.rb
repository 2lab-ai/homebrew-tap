class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.14.0529"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0529-874a165a8545/llmux-macos-aarch64"
      sha256 "383f7632f774cb23aaaa602e1ca47d226b36b7a8a1ca37d06efed96c81c8c3f2"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0529-874a165a8545/llmux-macos-x86_64"
      sha256 "a4a19d9423a4fdbb8c4c90654deb70530060bb8b9eb67fdbb2d134da05c67b85"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0529-874a165a8545/llmux-linux-aarch64"
      sha256 "811ba92d809e003b3046b42d251072e887104d6068f5f010d13bd6fd214e9549"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0529-874a165a8545/llmux-linux-x86_64"
      sha256 "7f431000da4f93446454d30fe548176eb034b7c1158b0447289e310c869b396d"
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
