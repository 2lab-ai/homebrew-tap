class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.22"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.22/llmux-macos-aarch64"
      sha256 "f5c705cc94be9f8a9d944bc4d585ef864517831a5c537a4bdbfafcbdb0eb76e5"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.22/llmux-macos-x86_64"
      sha256 "4774fe7475e40f4d419a9944bb281bf9298975899621c87b25f9a26b68d0d5a4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.22/llmux-linux-aarch64"
      sha256 "0892e76676ced19ba4cb29364ee921e3ec5eaafb56b5ff0736850a8ee532324b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.22/llmux-linux-x86_64"
      sha256 "0563e0cff73b797714f0f13e2c7ab33af775cd3cb9ff94ced64dc18898a01495"
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
