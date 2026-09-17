class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.17.0944"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-17-0944-464f5bb7ab85/llmux-macos-aarch64"
      sha256 "1fd904c39bc40492e2407319a4bc836330a227695277f75edccc0df2c04dd298"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-17-0944-464f5bb7ab85/llmux-macos-x86_64"
      sha256 "f0a5bb7cebdf14443405cc542a863dbaffad992847e2f102e2d344dec6544fe9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-17-0944-464f5bb7ab85/llmux-linux-aarch64"
      sha256 "7f4e523e4c0ec67c4edaecf49a2c40ff04765a646ceb7b33d1d4d2d7d52fde5e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-17-0944-464f5bb7ab85/llmux-linux-x86_64"
      sha256 "c4e4f74c57a8a4ee62358e4db469645219a42e4b380bf869535b01b788041822"
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
