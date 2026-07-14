class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.17"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.17/llmux-macos-aarch64"
      sha256 "75556b34c46af696cf1e0ac288f67e38454caa1b41d871e96f0597d7b938faa3"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.17/llmux-macos-x86_64"
      sha256 "10dbe54a856ba7c19279e634fc53645fa70ff56ce10663a18d8f026083bff928"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.17/llmux-linux-aarch64"
      sha256 "617f98aad7b831d107b9065744a7593e913ddd5b78d21b7729b8c545d48b6937"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.17/llmux-linux-x86_64"
      sha256 "24ac1bbd21b66d3491149de84932ed3a941a30fc7ee274b95e4b98679f28ccf9"
    end
  end

  link_overwrite "bin/llmux"

  def install
    bin.install Dir["llmux-*"].first => "llmux"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmux --version")
  end
end
