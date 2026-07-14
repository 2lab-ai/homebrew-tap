class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.14.0142"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0142-7f1dbeceb44c/llmux-macos-aarch64"
      sha256 "d9ac69e8438c4498e61ea032228fde621ac20c7857161658d48db8d1280cd560"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0142-7f1dbeceb44c/llmux-macos-x86_64"
      sha256 "1ee80f048507580ac7ebd54b2a296c6d223313b558a1058e1cf300530dc8cf4a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0142-7f1dbeceb44c/llmux-linux-aarch64"
      sha256 "6ca79e1ddf0cc435d403ba53012f001f9d51121cfbc8e30616bb796bfe5303c0"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-14-0142-7f1dbeceb44c/llmux-linux-x86_64"
      sha256 "34da0b1b6a4f89d00b2e6b0b31ef7616da2228a11bf1cda2bd6921afce92e6c0"
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
