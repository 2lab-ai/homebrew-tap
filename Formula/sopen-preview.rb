class SopenPreview < Formula
  desc "Opens a file or folder on another machine as if it were local (preview channel)"
  homepage "https://github.com/2lab-ai/sopen"
  version "2026.11.25.0746"
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
    url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-25-0746-6a86f31b0541/THIRD-PARTY-NOTICES"
    sha256 "8494d085202d0231813b109ed23ed775d438c245e9bbd11f4a944072c4b785fc"
  end

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-25-0746-6a86f31b0541/sopen-macos-aarch64"
      sha256 "15375880258a758c5feb71db01809d1ae5fed67d73f5f19a18df3f38911ed01e"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-25-0746-6a86f31b0541/sopen-macos-x86_64"
      sha256 "3c35a3d05916b7bef631f9adac8328e1b8eaeb704cd877b4f764a872daa3ef5a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-25-0746-6a86f31b0541/sopen-linux-aarch64"
      sha256 "f80bba8561fbfe90086e3a9a2dd765259c502bf39ffb596c3f74ba6a18b9b1b1"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-25-0746-6a86f31b0541/sopen-linux-x86_64"
      sha256 "2c008585c13fdf8b936c9b7404ad1eff253b967b3a231b61d715c41ecb727f71"
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
