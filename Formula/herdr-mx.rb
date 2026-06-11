class HerdrMx < Formula
  desc "herdr, multiplexed further - multi-remote distribution of herdr"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "0.6.10-mx.1"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.6.10-mx.1/herdr-macos-aarch64"
      sha256 "c0f6b669aa0787fb6d36421dc057a5f0f2ccd2b86acc4b3f9e9de135b34aea70"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.6.10-mx.1/herdr-macos-x86_64"
      sha256 "b90cd6675b98e06e70c7c03eee8ff4856833f40c307534193eb025cac3e07052"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.6.10-mx.1/herdr-linux-aarch64"
      sha256 "f8e80eafa76ceb03efc29c99940c0f743d52623f7f591b31e7b7cf64a5177e2b"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.6.10-mx.1/herdr-linux-x86_64"
      sha256 "44618e8bb8963cb6def1b020da45d574ded0c3bc977b3796fdee1039120f1483"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.", shell_output("#{bin}/herdr --version")
  end
end
