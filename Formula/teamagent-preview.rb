class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.13.0138"
  license "MIT"


  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0138-25df4bf5b442/teamagent-macos-aarch64"
      sha256 "fa39e9c1db6c1a253f64f9f8f7a0676eb44bda24e254d93bee724034bf8bc8be"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0138-25df4bf5b442/teamagent-macos-x86_64"
      sha256 "fe9836e2bd3ab73e6e575351bf69104e373159d4f19e3643311835f5a30a307a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0138-25df4bf5b442/teamagent-linux-aarch64"
      sha256 "d8e145b73a65639849cba3f1f0bfe346fe947ba0bcef6c250e36168193840f02"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0138-25df4bf5b442/teamagent-linux-x86_64"
      sha256 "2cd5086e66b5157cb758aa8569157c044ce8d2112206c5c6b0f65384be11c132"
    end
  end

  def install
    bin.install Dir["teamagent-*"].first => "teamagent"
  end

  test do
    assert_match "preview", shell_output("#{bin}/teamagent --version")
  end
end
