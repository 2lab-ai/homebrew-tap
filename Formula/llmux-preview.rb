class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.15.0928"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0928-10bc07ff636e/llmux-macos-aarch64"
      sha256 "86de39735a142c2e45403254026962b7f2eeb0b9461b0b757fca78b6a3e91b0c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0928-10bc07ff636e/llmux-macos-x86_64"
      sha256 "9203ba2726940cf2e2271c2eeb0382ede0354c7a1ec31339b8df2ebf9b08d2cf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0928-10bc07ff636e/llmux-linux-aarch64"
      sha256 "0e48fef0e149979e9ebabab28833fca689be6db215f2f3d144311a9682ed3a04"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0928-10bc07ff636e/llmux-linux-x86_64"
      sha256 "3beb9ad89ae0471dba3aa59891fd189c0ff844d8a6c4c147a699a17d279a316d"
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
