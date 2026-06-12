class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.12.1403"
  license "MIT"


  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-12-1403-8af17a3983a2/teamagent-macos-aarch64"
      sha256 "65db42067fbf83c9dcc81889ae844e2088b93a830e5acaafa77ff021def7c5ef"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-12-1403-8af17a3983a2/teamagent-macos-x86_64"
      sha256 "672847072511d64eeef9579f239a72eed4b0e5bd379269daee2955a5dd82bb55"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-12-1403-8af17a3983a2/teamagent-linux-aarch64"
      sha256 "e56f06f1e5f40b3c1db1401570ba1ae3fe660c4b42e7b962a5ed415d9863855a"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-12-1403-8af17a3983a2/teamagent-linux-x86_64"
      sha256 "8ae3493fc4f1e6ea68a590cdc278dabfbea56b691d3b341a805d7fd2091aa5ed"
    end
  end

  def install
    bin.install Dir["teamagent-*"].first => "teamagent"
  end

  test do
    assert_match "preview", shell_output("#{bin}/teamagent --version")
  end
end
