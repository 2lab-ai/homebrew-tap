class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.14.0442"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0442-73a4ee9ddf4c/teamagent-macos-aarch64"
      sha256 "cf4473ce4d03197ed4b0489877e5e6ae7b2d3250644c7566840e76569b55cfe0"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0442-73a4ee9ddf4c/teamagent-macos-x86_64"
      sha256 "58e3ecefcba6a4885468f2dc50478295602e35c8bb3fc4c2b1c71f1084f06207"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0442-73a4ee9ddf4c/teamagent-linux-aarch64"
      sha256 "0ec651c2a6cea1d51a3ffba3cd971ddbd44eeb08810c512b0076263c2abfa8b4"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-14-0442-73a4ee9ddf4c/teamagent-linux-x86_64"
      sha256 "1d1e64de98b43618a5e4ffcf01a7bd02b945d6a0392bcb15d5f4b956729b3cd8"
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
