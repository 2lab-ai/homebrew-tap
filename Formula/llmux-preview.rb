class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.07.1429"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-07-1429-372e579c5b61/llmux-macos-aarch64"
      sha256 "1ec5c5262fd348b3e679958fe77e12299d8caf265d5eee1ee8911954127bfb4f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-07-1429-372e579c5b61/llmux-macos-x86_64"
      sha256 "9b49391a1f1fd72490dd1d343c2517822c2c412ead13052e62bf86295e549338"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-07-1429-372e579c5b61/llmux-linux-aarch64"
      sha256 "52feb90c48f662696102142b70918462770c6a5d2f4444a508ebcda25ff66c22"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-07-1429-372e579c5b61/llmux-linux-x86_64"
      sha256 "be57890948e116c30116d2a5e02724106f66d96c27bf7da9e1c1297b73e52085"
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
