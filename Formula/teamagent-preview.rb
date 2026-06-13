class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.13.0241"
  license "MIT"


  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0241-1e26a6e94aa5/teamagent-macos-aarch64"
      sha256 "834c949cb0d6ea759816488256fd9c1a8e4ca7524d60689eee989cac9312ee42"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0241-1e26a6e94aa5/teamagent-macos-x86_64"
      sha256 "81d6674b1311a6dfb18a21391ce6d447861d657e3ace4a30d3041b5a11a2ce3a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0241-1e26a6e94aa5/teamagent-linux-aarch64"
      sha256 "950de2cb284900dd548d262b1f10e96913f4fa88928f923122d1befea404eea4"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0241-1e26a6e94aa5/teamagent-linux-x86_64"
      sha256 "4e65432f798ffb180460c0b0de6828f9e0a0da4951521c39a3e49b08029823f9"
    end
  end

  def install
    bin.install Dir["teamagent-*"].first => "teamagent"
  end

  test do
    assert_match "preview", shell_output("#{bin}/teamagent --version")
  end
end
