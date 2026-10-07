class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.24"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.24/llmux-macos-aarch64"
      sha256 "ba73e008acd73daadeb7ff412b19a29a75bc51c026b8ce39b58b0a8f03e0f8d5"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.24/llmux-macos-x86_64"
      sha256 "08de1a409d3d3d4a6a88c23bbd6a8706eb66bd4207d752c30f4a3bdd840ac73b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.24/llmux-linux-aarch64"
      sha256 "e53632f32421341a871549948d747a9839637c978ec697ab351ee9b997e03dd3"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.24/llmux-linux-x86_64"
      sha256 "f1bdf8e1efb8f9a065cfa486a42738fe5238a3336756d7e4a8418607ec16f8aa"
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
