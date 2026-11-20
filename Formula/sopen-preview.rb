class SopenPreview < Formula
  desc "Opens a file or folder on another machine as if it were local (preview channel)"
  homepage "https://github.com/2lab-ai/sopen"
  version "2026.11.20.0622"
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
    url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-20-0622-f1359ac2d0fd/THIRD-PARTY-NOTICES"
    sha256 "84512eb4b650ea41d9e997d265202a475a2cc40b3f9a401d1776fb62ef87e119"
  end

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-20-0622-f1359ac2d0fd/sopen-macos-aarch64"
      sha256 "a8789060d51a6ceaa6c363346a8747f8eb354e30eb933e6edabf9c9486df2a44"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-20-0622-f1359ac2d0fd/sopen-macos-x86_64"
      sha256 "2c8a46ff8898ba3be8ee3bc1951a1d6140a51e01251437bb39223f1e687ba26f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-20-0622-f1359ac2d0fd/sopen-linux-aarch64"
      sha256 "fa91beb12d0200a893f30080b54f9306e4df6a4b65a21d174c170503096ab756"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-20-0622-f1359ac2d0fd/sopen-linux-x86_64"
      sha256 "f7cf27986f008df020d67f49557eb149ea715792da8f0cc5f5a83e434009bc4d"
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
