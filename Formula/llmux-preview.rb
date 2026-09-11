class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.11.0839"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-11-0839-92e636d79ac2/llmux-macos-aarch64"
      sha256 "7e0e58187f96d2f1922db464fc462ec5cef6d28f50cb03bb1e8d852e8cfbc42f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-11-0839-92e636d79ac2/llmux-macos-x86_64"
      sha256 "c844de6f1abda318281c5104ee2d01ed806a53af2143d60eda873d074bbd29cc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-11-0839-92e636d79ac2/llmux-linux-aarch64"
      sha256 "544d7be43c3f55a03713a1389a91d596d7c07701eb3d927faf13a9bd121d8ff6"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-11-0839-92e636d79ac2/llmux-linux-x86_64"
      sha256 "125082a9ff23c489cf4d38a5e3d39c5957c5045aa5052a512a158b1b4596a9ca"
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
