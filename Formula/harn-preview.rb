class HarnPreview < Formula
  desc "Lists the harness an AI coding agent loads for a directory, reversibly"
  homepage "https://github.com/2lab-ai/harn"
  version "2026.10.14.1129"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-1129-0f33045b857f/harn-macos-aarch64"
      sha256 "5008537adc2087a2ae459a4f9301021520df24f4f6289eb055feb90d9d810a70"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-1129-0f33045b857f/harn-macos-x86_64"
      sha256 "cb3e0aa4b1a6cfff0af882a4fbf51c3483043912fec8a772149d5c9637ec29a3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-1129-0f33045b857f/harn-linux-aarch64"
      sha256 "3d4ec812e1b95ec0092e649e8b6e42d0b2a78497542b5b5189f2ffb74101f70e"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-1129-0f33045b857f/harn-linux-x86_64"
      sha256 "7fe66b25405ffe1f06cba3ffeeeefecd7d79ef21f1287fd99e2d8c6764021f07"
    end
  end

  link_overwrite "bin/harn"

  def install
    bin.install Dir["harn-*"].first => "harn"
  end

  test do
    assert_match "preview", shell_output("#{bin}/harn --version")
  end
end
