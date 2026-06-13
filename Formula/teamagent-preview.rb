class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.13.1120"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-1120-909bc6e0f1ac/teamagent-macos-aarch64"
      sha256 "4e05e9ace7e2c09673045f171fb70d920cbda80406d1f88506d1c50577181fb4"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-1120-909bc6e0f1ac/teamagent-macos-x86_64"
      sha256 "bbb45f539ed610c454d7f15e97e1443b2df7d94094be7fb5e3a58d728e83da05"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-1120-909bc6e0f1ac/teamagent-linux-aarch64"
      sha256 "d7134babf7ee22e1e1f1906b9492625a9d41e60860cb6bf08fe5cd8b14241b33"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-1120-909bc6e0f1ac/teamagent-linux-x86_64"
      sha256 "5cc63a14cf011197e7252d3f1fb83763e6939f101ef218c1026915171ff84ace"
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
