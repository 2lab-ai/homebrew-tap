class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.10.0019"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-0019-ec40c7ad2e50/llmux-macos-aarch64"
      sha256 "43dc732e13ce87e824244edf5ab6a39baad4fd217d456550664d271a3c920f21"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-0019-ec40c7ad2e50/llmux-macos-x86_64"
      sha256 "388e7463c0f3893e0e0dade278e368ca5b862e26516282acd725623144ce4112"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-0019-ec40c7ad2e50/llmux-linux-aarch64"
      sha256 "ae29f08357d9719da0553fecd5c0eb535860d700cf541d3482e69af2d56379e5"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-10-0019-ec40c7ad2e50/llmux-linux-x86_64"
      sha256 "5bbd11bf72d946ff6385f6210c7cf9191e7bd998bb069f22dc1fe907645e1181"
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
