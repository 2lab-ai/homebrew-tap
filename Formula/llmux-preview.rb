class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.12.1115"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1115-f7598c284197/llmux-macos-aarch64"
      sha256 "e80b10f9d7ce67601ca6f90d6bded77d4ea773ff10d3344847cb61ecc295429c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1115-f7598c284197/llmux-macos-x86_64"
      sha256 "d5a7aaa228327525a7c777f232f942ed6892222e6cbe2d8e486591dc26e54e37"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1115-f7598c284197/llmux-linux-aarch64"
      sha256 "f165b380f3c61856da558b3679c045d23fedd7a7f2ea6bc20fda218b93f48cdb"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-12-1115-f7598c284197/llmux-linux-x86_64"
      sha256 "aea31de93d09387d0c2268496a0a8f0be766814f3d3f3db1d6346cc2baa6a299"
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
