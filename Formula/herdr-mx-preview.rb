class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.08.22.1600"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-22-1600-be4d15051d3f/herdr-macos-aarch64"
      sha256 "6dd8e54c65def36ff847faa49e8fd7f323bf46cd703580c512be5969b753b517"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-22-1600-be4d15051d3f/herdr-macos-x86_64"
      sha256 "4889301b556c6d6f585104aa7c98e716e461642409e4780b50c7108a75c9b24f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-22-1600-be4d15051d3f/herdr-linux-aarch64"
      sha256 "f42c4932445b3a873b51c213060a0744640d9a93e85a9bd585dc3fa92fa96bfb"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-22-1600-be4d15051d3f/herdr-linux-x86_64"
      sha256 "f1497510c3c53e0a791cee27d3b6e26bcde7b66e73d668f96fbc2210f8fee045"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
