class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.28.0616"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-28-0616-31143d98a924/llmux-macos-aarch64"
      sha256 "78ff40822df9e301faff0ac11c8d3e760c480a371fbf3409e2c8893b7a3bf04d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-28-0616-31143d98a924/llmux-macos-x86_64"
      sha256 "60c4a274c7172a5b021979cb95f5ea5acbd5ac0bb4dedd0566ce03751642231a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-28-0616-31143d98a924/llmux-linux-aarch64"
      sha256 "9a923e3313722a85038c2171c8aa4beec43bb222faf31268384db1b1a2f5b389"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-28-0616-31143d98a924/llmux-linux-x86_64"
      sha256 "2cf2e7784e0b0ad2b88d50825eaa109040f0a607cf0b6cd412cbc351c81947d4"
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
