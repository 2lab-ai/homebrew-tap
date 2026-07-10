class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.10.0410"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0410-56f7dfa547a3/llmux-macos-aarch64"
      sha256 "e89d94279f24b7561d1ab2cde36389a01d2ad95aae86c14e4b31d69598de1d0e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0410-56f7dfa547a3/llmux-macos-x86_64"
      sha256 "f3abfda2a48d66894a870e95e5204cf2bae071e2e063c3c5e53fcecac749a3b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0410-56f7dfa547a3/llmux-linux-aarch64"
      sha256 "a59a462805a7b0b2593d303ae64d93ad29a16ee12acec137e84d25b4cae53aed"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0410-56f7dfa547a3/llmux-linux-x86_64"
      sha256 "57a89c9df89dbf0065925f73d8d78ef044036c3e677bdb4552d093345f7cb983"
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
