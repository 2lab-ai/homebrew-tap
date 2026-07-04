class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.07.04.1216"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-04-1216-0b5782170945/llmux-macos-aarch64"
      sha256 "05d6369619c8cdee929d6806b2bd84f0befb662fe9377c91510a878662acb384"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-04-1216-0b5782170945/llmux-macos-x86_64"
      sha256 "7945a715847e953d5e73c6f57c28a639480bfbbf13ac166366387e52a6b10862"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-04-1216-0b5782170945/llmux-linux-aarch64"
      sha256 "11ced754ce40c1e89ed4fbc8c9761005e057d3f17b8bef5098da8aba971f5115"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-04-1216-0b5782170945/llmux-linux-x86_64"
      sha256 "1cef881e780f931081a06d051b551857cf2e5dc8dd690ec11eb9c9695476c24d"
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
