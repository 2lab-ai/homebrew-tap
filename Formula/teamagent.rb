class Teamagent < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/v0.1.0/teamagent-macos-aarch64"
      sha256 "25f192f7123c08108a95de1137f41b874d13f54d6141281a4adbe0de81a2f19a"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/v0.1.0/teamagent-macos-x86_64"
      sha256 "eb4c05cec454570c45fbc7d850557c2997af1fda96f6e63d831cf14c1e50809c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/v0.1.0/teamagent-linux-aarch64"
      sha256 "3eac0114af8d22570aa75c1d9a0ee6faa4ba3cea7def029ede23ad1a486e06cb"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/v0.1.0/teamagent-linux-x86_64"
      sha256 "6fd663c0c6a8349e037e4cc3d8ff1290e73ddfbf62dc216a101f8d8ff5d2c757"
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
