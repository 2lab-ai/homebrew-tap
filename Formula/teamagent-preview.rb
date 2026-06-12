class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.12.1522"
  license "MIT"


  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-12-1522-03579791ffae/teamagent-macos-aarch64"
      sha256 "43015372087f0c8108316f5ad5b8d90d98416bebec1d40e6b3373999624c2adf"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-12-1522-03579791ffae/teamagent-macos-x86_64"
      sha256 "722a0d74dbb9467a30f6f8aec49b993f69f831b2c309921989dce656cdbf0799"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-12-1522-03579791ffae/teamagent-linux-aarch64"
      sha256 "35e302945889e96175c1b944ae4f718f41afdd407495b3a15f1e4b57f993ba6c"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-12-1522-03579791ffae/teamagent-linux-x86_64"
      sha256 "4adcf38d0fb0e8e153c1bb5baea0a46c07b557be75e00e7cf07498eff070a320"
    end
  end

  def install
    bin.install Dir["teamagent-*"].first => "teamagent"
  end

  test do
    assert_match "preview", shell_output("#{bin}/teamagent --version")
  end
end
