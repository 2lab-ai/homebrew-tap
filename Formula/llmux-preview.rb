class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.10.30.1320"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-1320-6f4d60db4abb/llmux-macos-aarch64"
      sha256 "27397137d67737769e10849152290fb134f1b0dae1d639b00da3fb501ef911a0"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-1320-6f4d60db4abb/llmux-macos-x86_64"
      sha256 "2f59ed1c21a6eb3121bb1d4e06de200750929fbbb78cdf921720f2badf0e3236"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-1320-6f4d60db4abb/llmux-linux-aarch64"
      sha256 "9de7a6b2824f7b8ef6fe14fc1448ae4342d4e56fd016aab0362722aacb523813"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-30-1320-6f4d60db4abb/llmux-linux-x86_64"
      sha256 "f3c329e07486361ca2424924e57f54a4da2d9efdcde84e2a7196884e10e82c18"
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
