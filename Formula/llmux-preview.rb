class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.11.11.1154"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-1154-bc4db85614e4/llmux-macos-aarch64"
      sha256 "a6064a4ec4139f2ee2ef55833dbee51aad3d19a6ed1151dd82ace869077a4648"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-1154-bc4db85614e4/llmux-macos-x86_64"
      sha256 "5d95f24d36788e1afc0944fefb48560494fe49695cb5de84db505e822a3b70fd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-1154-bc4db85614e4/llmux-linux-aarch64"
      sha256 "6dad9790e0141f1267e7cf211dfdd4ef999f9e37e197eacaec9229bda1c8b284"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-11-1154-bc4db85614e4/llmux-linux-x86_64"
      sha256 "f346260e481d0b3bc2c584269b8451f1c5df3df4286505bd27935380054915b0"
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
