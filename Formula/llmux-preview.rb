class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.10.0734"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0734-5ef8f9f9298e/llmux-macos-aarch64"
      sha256 "d29f53c10392ed8bfbe0a19987fcc01df20d5b6b4d44580f30dee8cf5d0a073a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0734-5ef8f9f9298e/llmux-macos-x86_64"
      sha256 "9045949ea07f7b973d6cf36b001bcb9974b65f6705be510e5d4293b59584855a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0734-5ef8f9f9298e/llmux-linux-aarch64"
      sha256 "7ce733f543ab363f78637c2d8f068f9be49bf3467b43d7bc819504c3ef8c6c21"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-10-0734-5ef8f9f9298e/llmux-linux-x86_64"
      sha256 "c4cfb1778821a3c90e360a7103d09332665d4c4464b5c8858aa6eb62dbd9e19e"
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
