class SopenPreview < Formula
  desc "Opens a file or folder on another machine as if it were local (preview channel)"
  homepage "https://github.com/2lab-ai/sopen"
  version "2026.11.19.1653"
  license "MIT"

  # `sopen cut` and the media window run ffmpeg/ffprobe at runtime.
  depends_on "ffmpeg"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1653-3a426b6d1bdd/sopen-macos-aarch64"
      sha256 "7ada094c2443cfa5ba9f8529366edec800b85298274222ddeb3982467c099fd8"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1653-3a426b6d1bdd/sopen-macos-x86_64"
      sha256 "f812900dbb84a54aae4b6fb1b0436a14499d098bc05191d84c002bd52265faf4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1653-3a426b6d1bdd/sopen-linux-aarch64"
      sha256 "31b492332385e851d36d0e8b541e36537c412ac1abe8f67eec1357f354989100"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1653-3a426b6d1bdd/sopen-linux-x86_64"
      sha256 "c5892c49f292494af28677d5a3475565848fd8ea201e76487554dc69fc28b162"
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
