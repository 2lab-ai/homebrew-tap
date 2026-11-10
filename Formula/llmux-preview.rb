class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.10.1206"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-1206-91dabbc610a7/llmux-macos-aarch64"
      sha256 "11bc152220cdd1fd4b24b4aa2a052e8ae6bde7f8a2fcf5557e86218432cb491a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-1206-91dabbc610a7/llmux-macos-x86_64"
      sha256 "c57e6452b4413e48ec4cdf7da2aaa900008edbd10f66c63c7c380cf8df4dbba2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-1206-91dabbc610a7/llmux-linux-aarch64"
      sha256 "56345ca9327495393b88cc18b7f9e85d443bbeb68f8727fa5e1a8292e9a69fd4"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-1206-91dabbc610a7/llmux-linux-x86_64"
      sha256 "ee566aec1cedf87f2ae2defa917c2925ccd31caf7b64040251981e724ad9814e"
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
