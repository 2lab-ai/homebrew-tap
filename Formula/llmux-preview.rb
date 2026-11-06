class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.06.1304"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-1304-98bc3f74010b/llmux-macos-aarch64"
      sha256 "3bd86c0a6ad054cdf4476362709b2dde3d70799b06a0d30fdb59464fa10f2300"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-1304-98bc3f74010b/llmux-macos-x86_64"
      sha256 "5a4199d968599f4d9c27197a06dbc62663f95857d8f3c44f0ec3e7955c693d04"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-1304-98bc3f74010b/llmux-linux-aarch64"
      sha256 "af6d04faa7e61dd65274d8fd39196ac1b598a7aa01de8fb9b28193714b3d3cf3"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-06-1304-98bc3f74010b/llmux-linux-x86_64"
      sha256 "f4ef53f01caff2de336954f206978b4680eec7e4dd58b0d3e647c12f0968b4a5"
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
