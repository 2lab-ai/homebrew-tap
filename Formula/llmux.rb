class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.15/llmux-macos-aarch64"
      sha256 "dff9fd481c1eb1a22cf007b267351f0c8627cc087b3952d4437480b78dd0d28c"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.15/llmux-macos-x86_64"
      sha256 "df27634e6a41605ab8b4b10839af0ea4f84740a37dde0cfc06a5648100514bec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.15/llmux-linux-aarch64"
      sha256 "144d9f1f2900c4af5744e3d1107f24d0f68bb67465230f38f9d0fd34d358cc56"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.15/llmux-linux-x86_64"
      sha256 "12c86032af7cefea399acf3b59a376fd3086512524553d2115eb0e6baa4d8e82"
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
