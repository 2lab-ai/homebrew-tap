class Llmux < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "0.2.26"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.26/llmux-macos-aarch64"
      sha256 "88ec12459fade5ca9848d7060b1248301272e1b20b684fde359d53d9ee129c4d"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.26/llmux-macos-x86_64"
      sha256 "60d7600cde259a497dffbfbd1439fb6331d980064c2694cc95c500e46d3bfb8c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.26/llmux-linux-aarch64"
      sha256 "653c81e137738ecd1cdd356653034488839ea08c1d1be9c57a136554291de5d1"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/v0.2.26/llmux-linux-x86_64"
      sha256 "2bdbba37606a1948ab19726997cacdaac0e086eca0800841cd08a554ddb1ac68"
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
