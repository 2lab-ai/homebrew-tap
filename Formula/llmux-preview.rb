class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.12.0656"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0656-e254be641b4d/llmux-macos-aarch64"
      sha256 "43b763e1d9cfe63c83c80c87f4bc47cea477347a3d3c7af487b4d76639ec3e3a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0656-e254be641b4d/llmux-macos-x86_64"
      sha256 "35fe872a963f8c8ba63807a45fda1b07cbb02d21a0789ac6b7b6d24ad2797f15"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0656-e254be641b4d/llmux-linux-aarch64"
      sha256 "907fa513a10a22192d0081a591dc5ec40348ef2fc01a0d3eda85910868402988"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-0656-e254be641b4d/llmux-linux-x86_64"
      sha256 "50c1345b3775ccee5ec486ccbb930ae352ead9db3a3f7a5ed4f16c3d48a1c5e3"
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
