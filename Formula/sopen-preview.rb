class SopenPreview < Formula
  desc "Opens a file or folder on another machine as if it were local (preview channel)"
  homepage "https://github.com/2lab-ai/sopen"
  version "2026.11.19.1441"
  license "MIT"

  # `sopen cut` and the media window run ffmpeg/ffprobe at runtime.
  depends_on "ffmpeg"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1441-ab5a0e526b64/sopen-macos-aarch64"
      sha256 "743815c0147c13a44132134318865743ba5b3995a8b830008e808fb40adc371a"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1441-ab5a0e526b64/sopen-macos-x86_64"
      sha256 "5e34af0044d6835d894c53decc4b63fc8468782ec793c1d5e48b2fb83462a9e7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1441-ab5a0e526b64/sopen-linux-aarch64"
      sha256 "0e3437c83672ad4aa15ee57275ac914a7df6e2c4a13a80af679f3a82efbdf0a6"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-19-1441-ab5a0e526b64/sopen-linux-x86_64"
      sha256 "51806685723ec43898f9a00e1c4bcbc7d2fadf248e69915de5826e15a5665a7b"
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
