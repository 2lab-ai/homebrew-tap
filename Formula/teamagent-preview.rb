class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.14.0345"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0345-19b5fbf41820/teamagent-macos-aarch64"
      sha256 "c7a73eb5527df0bcc13e044d68697eda471787441d3a830612f5ece87e9a7dd1"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0345-19b5fbf41820/teamagent-macos-x86_64"
      sha256 "0df08ce27f2ed386ff84c65f5b99642e72fd10f9b567ab3617c892e3c7dbe44f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0345-19b5fbf41820/teamagent-linux-aarch64"
      sha256 "b8bb0f43ed74a52b43fc7b289844544c042251c14d351b8e16365c7487a43119"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0345-19b5fbf41820/teamagent-linux-x86_64"
      sha256 "3c640b51f27e827aa356d6fd956b74eef88db5c7d058bef73045fe6d800edd27"
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
