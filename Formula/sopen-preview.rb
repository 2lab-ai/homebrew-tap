class SopenPreview < Formula
  desc "Opens a file or folder on another machine as if it were local (preview channel)"
  homepage "https://github.com/2lab-ai/sopen"
  version "2026.11.20.0329"
  license "MIT"

  # `sopen cut` and the media window run ffmpeg/ffprobe at runtime.
  depends_on "ffmpeg"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-20-0329-dd7dce4461d0/sopen-macos-aarch64"
      sha256 "64f7873e11d2664b497aa7055a7fbc0760b44ace39096f7948f4a2402c46331f"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-20-0329-dd7dce4461d0/sopen-macos-x86_64"
      sha256 "b584a16f821d695363c11970a27eae34d7102afad5a3061f45fe483a3bc72d2e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-20-0329-dd7dce4461d0/sopen-linux-aarch64"
      sha256 "716e7a30ff3be9e3dcd92a683f8aebbc7ad565d4b2f8a7a4418828e9d759c22b"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-20-0329-dd7dce4461d0/sopen-linux-x86_64"
      sha256 "3447c297e241c284e3fa235f43501d7756dc59938e7c1f37416a12d7f543eb4c"
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
