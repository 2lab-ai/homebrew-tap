class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.14.0303"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0303-3d393b0376cc/teamagent-macos-aarch64"
      sha256 "7479042354b10799b9962e30586d425b158570359c81bfd3f6cc32e73e28fee3"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0303-3d393b0376cc/teamagent-macos-x86_64"
      sha256 "11833f1388bfa4b564a5ac6030401ac0200d4e9c5786478660353727d1c8e59d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0303-3d393b0376cc/teamagent-linux-aarch64"
      sha256 "a0bb8790921e793d8675208b774e4b5184937eab23436fa90ebd4959d8d87c16"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0303-3d393b0376cc/teamagent-linux-x86_64"
      sha256 "25a1d1beeeec3bec97a8309e1c47aa7184629e1aa18fcd9ae0674f1f4eb125c5"
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
