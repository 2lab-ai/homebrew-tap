class Teamagent < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/v0.2.0/teamagent-macos-aarch64"
      sha256 "d5ccc05fbe0621c4b1d1b47a990509438cfa788d4b8e30d54e4e59a6df66ce0a"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/v0.2.0/teamagent-macos-x86_64"
      sha256 "4d926b88cfa9c7d1907d4b38345560f7f45601b515f703d5b55a23d25c323575"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/v0.2.0/teamagent-linux-aarch64"
      sha256 "a2ecd8b95b39029df5882f134c462790184d2f745c91be0a9eecd8b336b702e0"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/v0.2.0/teamagent-linux-x86_64"
      sha256 "02d139e82872ae1d8bee6d63a78a9e88764ab0ec203f07f4146145fcb253e621"
    end
  end

  link_overwrite "bin/teamagent"

  def install
    bin.install Dir["teamagent-*"].first => "teamagent"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teamagent --version")
  end
end
