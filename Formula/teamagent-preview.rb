class TeamagentPreview < Formula
  desc "Multi-account multi-provider LLM proxy for Claude Code with quota-maximizing scheduling"
  homepage "https://github.com/2lab-ai/teamagent"
  version "2026.06.13.0440"
  license "MIT"


  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0440-e499c2334540/teamagent-macos-aarch64"
      sha256 "8ba85b2b258794826d9089f9a3259936984c0a73a40c06defa08e4a50f02b408"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0440-e499c2334540/teamagent-macos-x86_64"
      sha256 "88b317301f64db958a7758bf45777ae8ea2457a29f1094691670ad4180b7c07f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0440-e499c2334540/teamagent-linux-aarch64"
      sha256 "7629a439799b9c62802c8ec5acf7a79720620925e448476e23bdfd8ecf2f479f"
    end
    on_intel do
      url "https://github.com/2lab-ai/teamagent/releases/download/preview-2026-06-13-0440-e499c2334540/teamagent-linux-x86_64"
      sha256 "d13fc71e98dde9cbe7540b4d77afa4efdfc2ca31f56c5f0f7164a49ce5ee3f1e"
    end
  end

  def install
    bin.install Dir["teamagent-*"].first => "teamagent"
  end

  test do
    assert_match "preview", shell_output("#{bin}/teamagent --version")
  end
end
