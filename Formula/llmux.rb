class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.23"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.23/llmux-macos-aarch64"
      sha256 "ca0d2caa95ce1b2957412739fddc130d6d06889a1b65b13dcc8934112ac5b10a"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.23/llmux-macos-x86_64"
      sha256 "22c4753b58a2124eb95128fb7dcf4cb6299426633a065198b0c7a01c28d6f401"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.23/llmux-linux-aarch64"
      sha256 "f13495f689238e147ec5617b24b94b3c27dd591e87b863d88400d0dc632cfc94"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.23/llmux-linux-x86_64"
      sha256 "f535c6ffdd9191609bc67918574a5fbe4545ef49861abec0732ac790cbcc28f3"
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
