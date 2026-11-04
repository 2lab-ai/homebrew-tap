class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.04.0759"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-04-0759-051abe182b90/llmux-macos-aarch64"
      sha256 "36010c1ecb775a52e2a404f524708a075941ad5ba45a76c00d8326a343fa0a22"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-04-0759-051abe182b90/llmux-macos-x86_64"
      sha256 "83954ea1c9f16017d1bcbe83fbb73adb71bdcba890d93bd75e7887ed533592e8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-04-0759-051abe182b90/llmux-linux-aarch64"
      sha256 "7e3f0d6738a995ae0b4c0d1760260fa8e706edcf6cc4940a79b5a979d152903c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-04-0759-051abe182b90/llmux-linux-x86_64"
      sha256 "bcd73e1ecec583fb8fa4687c8bf7cc287c7a095d49dcd60d6f871971e8dc8c14"
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
