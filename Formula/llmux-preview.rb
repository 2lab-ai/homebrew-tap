class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.27.0712"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0712-454b32ab5ba7/llmux-macos-aarch64"
      sha256 "be164e3d73dd83e2abbeff78d89e711a882870e7099b1a7a1ef99b5404d9256c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0712-454b32ab5ba7/llmux-macos-x86_64"
      sha256 "d59968e6166c7c0e509fcdbd25cd0996b55f80cbf30cd5f8a417d543c2a2ea9d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0712-454b32ab5ba7/llmux-linux-aarch64"
      sha256 "b283454f4bc8ab2f2ceab02ced5de5af9bca8334e174683347e835eb81406fc1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-27-0712-454b32ab5ba7/llmux-linux-x86_64"
      sha256 "ab9e5c6b61101a5e688f6049d0c97a7629f1481499ed6dcf6fb80fd4891d6820"
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
