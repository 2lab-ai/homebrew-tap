class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.09.0941"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-09-0941-d4850ec27ebb/llmux-macos-aarch64"
      sha256 "6090cdc7960fd313dce0a67c501691655ddd9bdaeeeac0f6d27e484daa6ab443"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-09-0941-d4850ec27ebb/llmux-macos-x86_64"
      sha256 "69e2228c59ac62ccedfdec8e71b2a667591aeadd3fed9ea14fa249c6f7eab99a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-09-0941-d4850ec27ebb/llmux-linux-aarch64"
      sha256 "508c1f4a069a02e1346e0006f7b57e6830f8605625707eaa7606f3e5b1cb527b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-09-0941-d4850ec27ebb/llmux-linux-x86_64"
      sha256 "456178fddd7e3d567c987299eb82ec8016c64df542522d84b7555b91199e47a9"
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
