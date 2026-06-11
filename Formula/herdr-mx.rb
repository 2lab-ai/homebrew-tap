class HerdrMx < Formula
  desc "herdr, multiplexed further - multi-remote distribution of herdr"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "0.6.10-mx.3"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.6.10-mx.3/herdr-macos-aarch64"
      sha256 "3a414311d654d0be0470bd9d61056387b96637a1e8cd92fd233310026124dcea"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.6.10-mx.3/herdr-macos-x86_64"
      sha256 "25c22bb7245da09924332310e6177752a3b2a57d27b11c017456642adfd0b315"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.6.10-mx.3/herdr-linux-aarch64"
      sha256 "e878568e7d66f4d765154428fb7828e197c34a8da2fc6d2cc887993fc97bbd89"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.6.10-mx.3/herdr-linux-x86_64"
      sha256 "f0f30977e4045df406bfff87645e7033b20f8cd4456513b73ae2f5f8e32c653c"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.", shell_output("#{bin}/herdr --version")
  end
end
