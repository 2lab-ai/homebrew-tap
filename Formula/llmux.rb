class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.8/llmux-macos-aarch64"
      sha256 "b9f853b174f3f3ff6fc4b3fa8136a149c5688ed0f3953a28ddb14dc7bc3537e4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.8/llmux-macos-x86_64"
      sha256 "1b8cad034493b0ba1e089b3e0ba31516a040f5a589bee291ef755df57754f52f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.8/llmux-linux-aarch64"
      sha256 "5a007d7e8dcb7bb4d9843db9758ea8fcf65dc5e66d9eb99c67bbca7fca270f7d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.8/llmux-linux-x86_64"
      sha256 "4069425bfd1c0a34d7fe520175eb27ff6a8945f78c91d6efbc6daa2981190480"
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
