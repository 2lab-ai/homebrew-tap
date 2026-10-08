class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.25"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.25/llmux-macos-aarch64"
      sha256 "a9718d960455b8e004f2618a765a9026d5685ada8a2b5cda183c784b76a73ff0"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.25/llmux-macos-x86_64"
      sha256 "5336b98f35f6884a4634a36bb7ef8a4802b64f2eba31374210715b1a4f3edad9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.25/llmux-linux-aarch64"
      sha256 "34ba567ddcd35f9acefbd6a0aca5f41ca2de5c59dbc63c9ac6570af71a442739"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.25/llmux-linux-x86_64"
      sha256 "5ef4c925289898d6ea5c5f0d277cca0fce704f97f61c62c6f889576339fa9655"
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
