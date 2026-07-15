class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.15.1850"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-1850-1e1ad6b39e4f/llmux-macos-aarch64"
      sha256 "ef077a5c3970eed223849172b487b341a0fca5abef65ba35d2393f69f25d2a2b"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-1850-1e1ad6b39e4f/llmux-macos-x86_64"
      sha256 "cd40c3416c68c9adcac4bd34a0243d48513edd71aecf3cd01b9cb9b996be929d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-1850-1e1ad6b39e4f/llmux-linux-aarch64"
      sha256 "819fac90edb3bfe1d321b36e6022b793a9466dc4288248f0c2e0e9c3cfcaac21"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-1850-1e1ad6b39e4f/llmux-linux-x86_64"
      sha256 "9ba367463e2c746fb787640fa13fe0eec6c3102083208f641f99e1f26429d2ef"
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
