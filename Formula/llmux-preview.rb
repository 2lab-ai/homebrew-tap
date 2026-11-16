class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.16.1816"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-1816-1c6a3bbeecd8/llmux-macos-aarch64"
      sha256 "72fec2e857971d9fd2bec0905e408c633a908778d780accd46197cc1e1e03927"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-1816-1c6a3bbeecd8/llmux-macos-x86_64"
      sha256 "89d4206516db24dc254c0d05b4c4b18884e92ca24e898a65997f66c6ce855927"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-1816-1c6a3bbeecd8/llmux-linux-aarch64"
      sha256 "53bdc6a45e22a6b9acb47ab811787579286490695a5486951ba528b71de76a68"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-16-1816-1c6a3bbeecd8/llmux-linux-x86_64"
      sha256 "2892e08537215f3d03ca80a278ce7f3966b66a8eda30f567d1664f09af08068b"
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
