class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.14.0505"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-14-0505-7c5405bccd45/llmux-macos-aarch64"
      sha256 "327fe6c8d4ee99f30f18b27942842c463ea36d367de5fbdadc84cdab09b0e65b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-14-0505-7c5405bccd45/llmux-macos-x86_64"
      sha256 "0c3873cc30fa3488a13f6a8817a8646748d8c255de4941dd8abf0ede94e70322"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-14-0505-7c5405bccd45/llmux-linux-aarch64"
      sha256 "56c45d46490f4a8c63490b25deda8ef65842d6fec1d31efe039ea340de092ff2"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-14-0505-7c5405bccd45/llmux-linux-x86_64"
      sha256 "ceca4e16c9940441528a96712ef92f48c5abae83a7e2f4230f8d51b361d94665"
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
