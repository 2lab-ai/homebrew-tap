class SopenPreview < Formula
  desc "Opens a file or folder on another machine as if it were local (preview channel)"
  homepage "https://github.com/2lab-ai/sopen"
  version "2026.11.19.1058"
  license "MIT"

  # `sopen cut` and the media window run ffmpeg/ffprobe at runtime.
  depends_on "ffmpeg"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1058-4d5664cd6b1a/sopen-macos-aarch64"
      sha256 "7510a5127c3af55a72d3dbb4b1499f2e923c7b85a1dd28b0fab8c7b769bd1f52"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1058-4d5664cd6b1a/sopen-macos-x86_64"
      sha256 "26279b34a1c482f3a077fe65a960b33a9e940626347bf65d1d60e36d90c10666"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1058-4d5664cd6b1a/sopen-linux-aarch64"
      sha256 "cadd6ff43d60b6be2479b73e73bd7930daf0164cf401a23877f2d5fd9fb07f13"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1058-4d5664cd6b1a/sopen-linux-x86_64"
      sha256 "86f4f1be18b5f223501e253ea22c5f5fb2da12c2b2d873fe5d11756c0c800200"
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
