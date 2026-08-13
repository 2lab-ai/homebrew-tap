class HerdrMx < Formula
  desc "herdr, multiplexed further - multi-remote distribution of herdr"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "0.8.0-mx.1"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.8.0-mx.1/herdr-macos-aarch64"
      sha256 "d2f8790a214dbf5bb45533aedae5122e04b6afe046cf5c5983ab953b5a3b0982"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.8.0-mx.1/herdr-macos-x86_64"
      sha256 "9c6653885fcaa8a84cb012015831af7d9ddace4d260900c72952767007e77abb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.8.0-mx.1/herdr-linux-aarch64"
      sha256 "2679093c94f5dd37466b84c1e7389270db889909222149ae28d032040f775daa"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/v0.8.0-mx.1/herdr-linux-x86_64"
      sha256 "5fe2bebe2a2546810ed915c1f8da9f4057c289dea1113b45059806856940021f"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.", shell_output("#{bin}/herdr --version")
  end
end
