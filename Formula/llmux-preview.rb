class LlmuxPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/llmux"
  version "2026.09.18.0301"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0301-fcd78ce40043/llmux-macos-aarch64"
      sha256 "746110311d4eddd25d42d08b2f7afc29760bed02f1ea508538d7e9c06c54257f"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0301-fcd78ce40043/llmux-macos-x86_64"
      sha256 "ef3c7c2587bbbb4da841e20305330c55e504ddc40f277004be7b31509ce83242"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0301-fcd78ce40043/llmux-linux-aarch64"
      sha256 "5e621c47e8dbde65ad0207d47184b479ef5947e5b7211b18dbdcdea2bb3c78f7"
    end
    on_intel do
      url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0301-fcd78ce40043/llmux-linux-x86_64"
      sha256 "2e6e9d71c82b09d3c72f5f2afd7a77b835d35fb76dbbbcc66e926ecab8e32fb9"
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
