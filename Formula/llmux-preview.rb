class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.27.0748"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0748-334e9f74c91c/llmux-macos-aarch64"
      sha256 "289bcb8615aa7772c42d651514dc7700b3b92ef486f686627acfe2f254c875ba"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0748-334e9f74c91c/llmux-macos-x86_64"
      sha256 "5353b966843999b9e9d5d787f8ac2da659549bf21764a7208943ff61ba3adb67"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0748-334e9f74c91c/llmux-linux-aarch64"
      sha256 "2192815959bdcc72d8eeeb945fdc3b99c0d4718a6b57f586161f81b0dea7a755"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0748-334e9f74c91c/llmux-linux-x86_64"
      sha256 "7e5c4a3a7bef83cf07784eb7c1ae3f66b093551a8f722def26c975143fef0178"
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
