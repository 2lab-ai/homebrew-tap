class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.13.0028"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-0028-dd326aa50bc5/llmux-macos-aarch64"
      sha256 "43929b78d911831f15b7385ca13a45ef7aa613636b2a665506d37ba3b7cc760b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-0028-dd326aa50bc5/llmux-macos-x86_64"
      sha256 "cbfa243f0ffa189116f7c9e3111d01501626a351bb3fc4c0b85a1cbeeea8604d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-0028-dd326aa50bc5/llmux-linux-aarch64"
      sha256 "336e7f5e28ad9c502c6d48be783e483168cba3e5f65b1f89a5a9b30a04ebc683"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-13-0028-dd326aa50bc5/llmux-linux-x86_64"
      sha256 "014c094bc0efcca68256bfe32f3094b9f981805882c6dee8b160a13780d3399d"
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
