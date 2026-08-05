class HerdrMx < Formula
  desc "herdr, multiplexed further - multi-remote distribution of herdr"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "0.7.5-mx.1"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.7.5-mx.1/herdr-macos-aarch64"
      sha256 "b6a58348ccce59c7aac31b79da0c8fb2802b28616fb2b68c0a2557860f6535ce"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.7.5-mx.1/herdr-macos-x86_64"
      sha256 "82b72b32a29fe0902485035a06e10a15e07e628ade2bec0a772c2891af0e9add"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.7.5-mx.1/herdr-linux-aarch64"
      sha256 "04b1488dd4d245c9eea12833b3de16be58ec712d2abe3517710f8d3d9c435eba"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.7.5-mx.1/herdr-linux-x86_64"
      sha256 "ea2251430b42d4dcd6581ebd75610c76bb73b907f5424284361db350be90c75a"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.", shell_output("#{bin}/herdr --version")
  end
end
