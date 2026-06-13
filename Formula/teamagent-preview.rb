class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.13.2347"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-2347-8ad107e67366/teamagent-macos-aarch64"
      sha256 "0b02a276f724ed7e769c97e02249e0fa9f03091dd0b61bd548f58722dd54c49c"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-2347-8ad107e67366/teamagent-macos-x86_64"
      sha256 "7d1aea873b4541d28e9a85619c2e66dc296ddae7bc4548499c94dfcb939a4f93"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-2347-8ad107e67366/teamagent-linux-aarch64"
      sha256 "1e72bd988af2a436182423bc473e90cf32025f05dffc29ba9042937d1e3dcb2c"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-2347-8ad107e67366/teamagent-linux-x86_64"
      sha256 "fa22881ce3bc573cfb75a0ee94a7beb52b960d18772cdfcf4ec8f0e9b9daaecb"
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
