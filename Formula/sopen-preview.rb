class SopenPreview < Formula
  desc "Opens a file or folder on another machine as if it were local (preview channel)"
  homepage "https://github.com/2lab-ai/sopen"
  version "2026.11.19.1222"
  license "MIT"

  # `sopen cut` and the media window run ffmpeg/ffprobe at runtime.
  depends_on "ffmpeg"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1222-4b967385aad9/sopen-macos-aarch64"
      sha256 "fd309ad799e4fb3ab33338ab067a092d1fcb8de5303694e2f285e854b0413a5a"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1222-4b967385aad9/sopen-macos-x86_64"
      sha256 "c4ec43deb07038107672c3dd5c41fb69653886755ef1699b4471a4d0200c2468"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1222-4b967385aad9/sopen-linux-aarch64"
      sha256 "3987b3c16a20d3e355d552f99ea8d5ad33af1078e7b390dee654e3c9b9c160a0"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1222-4b967385aad9/sopen-linux-x86_64"
      sha256 "af7c484519d6ccdbb36df2e7637e2a3f39c0822ca19ca4a1b7f08294ca223046"
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
