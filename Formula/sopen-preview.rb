class SopenPreview < Formula
  desc "Opens a file or folder on another machine as if it were local (preview channel)"
  homepage "https://github.com/2lab-ai/sopen"
  version "2026.11.28.1037"
  license "MIT"

  # `sopen cut` and the media window run ffmpeg/ffprobe at runtime.
  depends_on "ffmpeg"

  # `sopen stems` (voice / music separation) loads this model at run time from pkgshare and
  # checks its SHA-256; it is not one of sopen's release assets. UVR-MDX-NET-Voc_FT from
  # Ultimate Vocal Remover (Anjok07 & aufr33, MIT), converted to ONNX by k2-fsa/sherpa-onnx.
  resource "stems-model" do
    url "https://github.com/k2-fsa/sherpa-onnx/releases/download/source-separation-models/UVR-MDX-NET-Voc_FT.onnx"
    sha256 "e411182ce2c53541fefdcc99a8f46f2fe03978eb22038b9497c1d9d95a00fad4"
  end

  # The licences of what the binary links statically (sherpa-onnx, ONNX Runtime, …) and of the
  # model, installed with it.
  resource "third-party-notices" do
    url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-28-1037-a540d1f09ea6/THIRD-PARTY-NOTICES"
    sha256 "8494d085202d0231813b109ed23ed775d438c245e9bbd11f4a944072c4b785fc"
  end

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-28-1037-a540d1f09ea6/sopen-macos-aarch64"
      sha256 "147d2cc4b952118a8d0500c06f68d3b6c09ea32db916125288183a9be0514f65"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-28-1037-a540d1f09ea6/sopen-macos-x86_64"
      sha256 "0d377cf8a4a667154e4843e16a68d381c2aec4d1ced1435f1e98be63f96a3bc9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-28-1037-a540d1f09ea6/sopen-linux-aarch64"
      sha256 "5e9ca209a68d9cc31e4df471f57fa8f0cddca3018ef19cf0d1ff0dfc3f16b632"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-28-1037-a540d1f09ea6/sopen-linux-x86_64"
      sha256 "26484ad4a7a03fa0a04562ad246ce326ace4c72cd377dd056eee65ab471ed51f"
    end
  end

  link_overwrite "bin/sopen"

  def install
    bin.install Dir["sopen-*"].first => "sopen"
    resource("stems-model").stage { pkgshare.install Dir["*"].first => "UVR-MDX-NET-Voc_FT.onnx" }
    resource("third-party-notices").stage { prefix.install Dir["*"].first => "THIRD-PARTY-NOTICES" }
  end

  test do
    assert_match "preview", shell_output("#{bin}/sopen --version")
    # `sopen stems` finds the model where install put it, with nothing pointing at it.
    ENV.delete "SOPEN_STEMS_MODEL"
    ENV["SOPEN_FFMPEG"] = Formula["ffmpeg"].opt_bin/"ffmpeg"
    ENV["SOPEN_FFPROBE"] = Formula["ffmpeg"].opt_bin/"ffprobe"
    ENV["SOPEN_CACHE_DIR"] = testpath/"cache"
    ENV["SOPEN_STATE_DIR"] = testpath/"state"
    system Formula["ffmpeg"].opt_bin/"ffmpeg", "-loglevel", "error", "-f", "lavfi",
           "-i", "sine=frequency=440:duration=2", testpath/"tone.wav"
    system bin/"sopen", "stems", testpath/"tone.wav"
    assert_path_exists testpath/"tone.voice.wav"
    assert_path_exists testpath/"tone.music.wav"
  end
end
