class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.13.0818"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0818-6043a888d2e8/teamagent-macos-aarch64"
      sha256 "0c317d789116598589c9d3e6cd98b5e6e167eb981c6253f5e2d2f32696847519"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0818-6043a888d2e8/teamagent-macos-x86_64"
      sha256 "e7802d82762fcd5c7dc7d2e652adbb4408f4fde28b336c859bb843057ee6440f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0818-6043a888d2e8/teamagent-linux-aarch64"
      sha256 "b43f97cac35cde0afe273c3a1833f668e2cd9ce5cd38f4b9ae1fb4ae664e1f26"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0818-6043a888d2e8/teamagent-linux-x86_64"
      sha256 "2ecc74c5e41a03c7e5c1a4cff278010dd56ff8e9c81326e3f8cbcff37a50ad1c"
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
