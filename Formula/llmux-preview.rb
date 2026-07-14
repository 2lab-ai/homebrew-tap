class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.14.0409"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0409-35b20a9dc01a/llmux-macos-aarch64"
      sha256 "88bfd54bfe6fbd07720a51a68ad86dae127fcf84c456e78bc96cd11e495ebec7"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0409-35b20a9dc01a/llmux-macos-x86_64"
      sha256 "2b81f1aa9201ed4a3b77bd1f38890f5682230099f0c850558928d03d5a179b57"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0409-35b20a9dc01a/llmux-linux-aarch64"
      sha256 "fa4910a3100a2d41e05ef311d6fe43d40de02dbce68469f8c90fe8feabbe4e59"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0409-35b20a9dc01a/llmux-linux-x86_64"
      sha256 "57c1d406155cbcdd4007ae0b93192f401f303af0e2bb3e90c834856e8dec5706"
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
