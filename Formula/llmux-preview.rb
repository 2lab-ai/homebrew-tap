class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.02.0933"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-02-0933-e9c2bb6c68a0/llmux-macos-aarch64"
      sha256 "3e07016d730b06d0ffbb6121be0a1edd1c95d5d1e7fb062cb826844e0935e5a1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-02-0933-e9c2bb6c68a0/llmux-macos-x86_64"
      sha256 "d7d49a71762c9fe63ab9d1630ab569ba2cffc9807e9d6cb353740ab763d2c868"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-02-0933-e9c2bb6c68a0/llmux-linux-aarch64"
      sha256 "d17a0a84893379a7b1bf048387d0865de0c24e5b9aa3ad4dedf66b15585a89a5"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-02-0933-e9c2bb6c68a0/llmux-linux-x86_64"
      sha256 "4fa27a3f453ef410c3943370e3a9ee273507429088a000ab9b06f9aab59b39c5"
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
