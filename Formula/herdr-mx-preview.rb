class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.07.20.0422"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-20-0422-b54583efa97c/herdr-macos-aarch64"
      sha256 "2391f736a35af6b4c1f0f1c506c599bcae2af0074c27a26c5a03e02ca5ebd0a8"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-20-0422-b54583efa97c/herdr-macos-x86_64"
      sha256 "ef822aaf2833625601dfcc413e7f44df40ceaf6c72ff1979abfb21034449dd1b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-20-0422-b54583efa97c/herdr-linux-aarch64"
      sha256 "2e30bca2bb713a5d5fba6681e70c4bdbd1c6d2425c092926c3ac137c1a18395f"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-07-20-0422-b54583efa97c/herdr-linux-x86_64"
      sha256 "68ed85d426eeecd74a5a068cfc4099f82d7dde224c0ce5aae9553c1fd2f75f7f"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
