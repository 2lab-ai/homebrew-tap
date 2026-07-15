class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.15.1438"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-1438-a12639774ad6/llmux-macos-aarch64"
      sha256 "0654cc52db75895572ae4eadbbc3903bddf4cb51c68d50169a57ed2401fab72e"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-1438-a12639774ad6/llmux-macos-x86_64"
      sha256 "51709454ad6cb0e0fd46c7e8397eeaefd6ff1624ee39f21fc4afe2d2a2b8e97f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-1438-a12639774ad6/llmux-linux-aarch64"
      sha256 "1044deb155046bae1bb5ced948c2e689ec04de96e4d5124ea65b1cafca89d82a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-1438-a12639774ad6/llmux-linux-x86_64"
      sha256 "160f7232011588a78733d0da4fd59c41abe4569a3aaefd92b7fac16fc97b808e"
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
