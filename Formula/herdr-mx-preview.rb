class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.06.12.0100"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-12-0100-589f634496dc/herdr-macos-aarch64"
      sha256 "d70d516f2e183bd70af4ab4fb4110ff1102eb6ecf7169defda9bc3b6074904e4"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-12-0100-589f634496dc/herdr-macos-x86_64"
      sha256 "48069a6474a24a59bf7da10c6e62aacd0ce999d437418fbf6a5daa920e3b0750"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-12-0100-589f634496dc/herdr-linux-aarch64"
      sha256 "ef43c747cbff24b01cdb5186603b1ef80b4ce34b4e2abe4885676ea4f90440be"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-12-0100-589f634496dc/herdr-linux-x86_64"
      sha256 "550ad7de2358840f7f79d5d990bda5f649c00b9e01489e1de886934afc6ecf37"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
