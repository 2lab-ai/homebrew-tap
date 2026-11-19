class SopenPreview < Formula
  desc "Opens a file or folder on another machine as if it were local (preview channel)"
  homepage "https://github.com/2lab-ai/sopen"
  version "2026.11.19.0852"
  license "MIT"

  # `sopen cut` and the media window run ffmpeg/ffprobe at runtime.
  depends_on "ffmpeg"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-0852-a27244c670f8/sopen-macos-aarch64"
      sha256 "3a499923f1982b1fb8b2f1204059edaaf10c2a4fd354be96d59d84aa3ec94b2b"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-0852-a27244c670f8/sopen-macos-x86_64"
      sha256 "8c3e2c03d36ddea2fe5b60454b4becfcdf39c4e4a0dac58ad298631c03ff19ae"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-0852-a27244c670f8/sopen-linux-aarch64"
      sha256 "d0afc8f6c0d4a28fd04216f9b3ddf48947f39d290e68a8dc32dfc3f3f1bc6ea0"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-0852-a27244c670f8/sopen-linux-x86_64"
      sha256 "8a9e97260f769b8b92a037cc00928e24dd8edcae4f4979d1f3a9afc98f770cfb"
    end
  end

  link_overwrite "bin/sopen"

  def install
    bin.install Dir["sopen-*"].first => "sopen"
  end

  test do
    assert_match "preview", shell_output("#{bin}/sopen --version")
  end
end
