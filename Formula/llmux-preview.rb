class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.08.1440"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-08-1440-31e3800fac9a/llmux-macos-aarch64"
      sha256 "6214cac4e37eb25c7fe85bac65df816c403c398be700a3b0766b014492d736d3"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-08-1440-31e3800fac9a/llmux-macos-x86_64"
      sha256 "c701ae1414ba95566e1546d3d2dcdb27efaf6cbab7be3093325f11c6d52ef766"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-08-1440-31e3800fac9a/llmux-linux-aarch64"
      sha256 "9192dbc49c2cae0ad36dd2866a37dee4e3ece2d9d26e0e7e7b60ba09fab1ec1e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-08-1440-31e3800fac9a/llmux-linux-x86_64"
      sha256 "5a94e3e943986080430e00afd7e0974f13db1f5768872fa7b95c7f469da39ce9"
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
