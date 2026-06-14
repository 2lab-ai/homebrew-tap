class Teamagent < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "0.2.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/v0.2.1/teamagent-macos-aarch64"
      sha256 "04fa5e3a32e8de3b4704f34997c70b4c93980ccdfc5b1b7a862080857617e82d"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/v0.2.1/teamagent-macos-x86_64"
      sha256 "b9e0a4110586f4835566cbd38340332bdf1b43f95f219db0c5f8b8bcdc1483e3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/v0.2.1/teamagent-linux-aarch64"
      sha256 "ed1ba610b266c61d2ad330d66e7a673339299ea004332bfea0957d1369d98271"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/v0.2.1/teamagent-linux-x86_64"
      sha256 "063a5242761dda097bb5bbc6dfda78ae96afe533e52496e0c33a72200e1003b8"
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
