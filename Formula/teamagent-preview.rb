class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.13.0059"
  license "MIT"


  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0059-7218f2dc5937/teamagent-macos-aarch64"
      sha256 "18ece1f5791c674820e9ac02025093b73cca0ebf8d73d85321753cfbcb9fdcca"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0059-7218f2dc5937/teamagent-macos-x86_64"
      sha256 "353b3c41b813e5eaa72197d4c8efe019bccad6a40912e9bbdf2459bb23badbfa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0059-7218f2dc5937/teamagent-linux-aarch64"
      sha256 "3cb4e15c420a01ce58a44b714258c0b027753b37e99da0f983e1435e186cf39a"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0059-7218f2dc5937/teamagent-linux-x86_64"
      sha256 "dbc3957119c794d77ad78370860a671c256a37d2e026870b858c5703ca0fc23d"
    end
  end

  def install
    bin.install Dir["teamagent-*"].first => "teamagent"
  end

  test do
    assert_match "preview", shell_output("#{bin}/teamagent --version")
  end
end
