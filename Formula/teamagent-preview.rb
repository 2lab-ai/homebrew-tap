class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.13.0319"
  license "MIT"


  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0319-f99573f12134/teamagent-macos-aarch64"
      sha256 "6401a39bc4a5d48bc1f62174aab5f2fe8e67ee2b52c75960a86a22ae1215877a"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0319-f99573f12134/teamagent-macos-x86_64"
      sha256 "df24252ff82abac1f570d08fe92bf023a5f01e966fa2719625d7008b56ca2438"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0319-f99573f12134/teamagent-linux-aarch64"
      sha256 "bab4b3dfae2d8989b719ed3700276e14ee6a7655e052367bcfcaed1dcaf58042"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0319-f99573f12134/teamagent-linux-x86_64"
      sha256 "b700323a19bf333d7148422e4852ade27d76862cdce4dd833255097bfb472724"
    end
  end

  def install
    bin.install Dir["teamagent-*"].first => "teamagent"
  end

  test do
    assert_match "preview", shell_output("#{bin}/teamagent --version")
  end
end
