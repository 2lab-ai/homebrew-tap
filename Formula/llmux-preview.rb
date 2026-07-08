class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.08.0756"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-08-0756-c5cbeb9d0036/llmux-macos-aarch64"
      sha256 "046ba6e2deeb636ef9648099cd950165df54d03ed65d341252627cafd4eb7afb"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-08-0756-c5cbeb9d0036/llmux-macos-x86_64"
      sha256 "7a06fc40baa7463f9fb199d6b245866ab2b95ee81a1561863bdff73ea433a34d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-08-0756-c5cbeb9d0036/llmux-linux-aarch64"
      sha256 "c840d80694f62cf1cf49bd05053510a9ba6b7461c39f12feb8fb661bba0a6122"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-08-0756-c5cbeb9d0036/llmux-linux-x86_64"
      sha256 "8bc34fc3fdbb1cb63cec0430cb508f44ac27a1f6dc9b7795ced61b591d67abc6"
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
