class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.14.0506"
  license "MIT"

  # teamagent was renamed to llmux (https://github.com/2lab-ai/llmux).
  disable! date: "2026-06-14", because: "it was renamed; install 2lab-ai/tap/llmux-preview instead"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0506-322b1ed08dbf/teamagent-macos-aarch64"
      sha256 "c338e8d14c8670f95027b3988d69e2f272401c1dcfcba1f68a44a3a979acd2b3"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0506-322b1ed08dbf/teamagent-macos-x86_64"
      sha256 "08190808e0eab565690f01553df8dbb315d8f77b88f2513c0df4fa6f83e545a8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0506-322b1ed08dbf/teamagent-linux-aarch64"
      sha256 "b994ba82920311fe171192694cb985454731c2da672db3c6c3d2b32e80f60dac"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0506-322b1ed08dbf/teamagent-linux-x86_64"
      sha256 "f0d229862715a34130c74b30b75713648e4e3ffd6ceccf9c20e27b34e2680941"
    end
  end

  link_overwrite "bin/teamagent"

  def install
    bin.install Dir["teamagent-*"].first => "teamagent"
  end

  test do
    assert_match "preview", shell_output("#{bin}/teamagent --version")
  end
end
