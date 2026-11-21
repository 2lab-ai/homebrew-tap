class SopenPreview < Formula
  desc "Opens a file or folder on another machine as if it were local (preview channel)"
  homepage "https://github.com/2lab-ai/sopen"
  version "2026.11.21.2038"
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
    url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-21-2038-b75c39212ccf/THIRD-PARTY-NOTICES"
    sha256 "84512eb4b650ea41d9e997d265202a475a2cc40b3f9a401d1776fb62ef87e119"
  end

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-21-2038-b75c39212ccf/sopen-macos-aarch64"
      sha256 "4bda804f459d67d71367f4bc3affc5b3ac8bf836620403d843fb28ee7c469f19"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-21-2038-b75c39212ccf/sopen-macos-x86_64"
      sha256 "616cdca9c62d4b9bb3a2f610a9b603f0fb387a3fb5b81be238a84a2b576e4e1f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-21-2038-b75c39212ccf/sopen-linux-aarch64"
      sha256 "a41e2e32bff5827df62dae008f2207d0eba561b6fd30be0eba4a0a92cafacbbd"
    end
    on_intel do
      url "https://github.com/2lab-ai/sopen/releases/download/preview-2026-11-21-2038-b75c39212ccf/sopen-linux-x86_64"
      sha256 "d2ec49746159adf2a3aceb49392fd5ad4b0c13b1d0e171eed9f2f6ba2ea41ae6"
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
