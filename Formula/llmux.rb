class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.19"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.19/llmux-macos-aarch64"
      sha256 "f975fdf50f9499ffaa57d70a7f3b8a8c1e6caa9f500ad550c8a0b36fe8717ec1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.19/llmux-macos-x86_64"
      sha256 "b242c613ceb061a3e46a3c6e3bb1086a8af7072f67a600d51ba575a34420a649"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.19/llmux-linux-aarch64"
      sha256 "333189d580cdc07102502b39dd4195259b257045bda7df1ffe5954ffc926fd20"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.19/llmux-linux-x86_64"
      sha256 "afe4dc9cf258c5d5b4db297a28ef064466e73684485cbd9ffc367e5ee1e61b95"
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
