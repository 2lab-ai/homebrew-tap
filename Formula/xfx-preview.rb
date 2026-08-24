class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.08.24.030744.32685351848.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-08-24-030744-32685351848-1-6e8656291504
  # source: 6e865629150470aa693f7e342c0cfacc2695f401
  SOURCE_REVISION = "6e8656291504".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-030744-32685351848-1-6e8656291504/xfx-macos-aarch64"
      sha256 "0b35f7037fae3c7c4a86aee5abeddf906e742d8b0c1591e7a7c10ae780f56060"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-030744-32685351848-1-6e8656291504/xfx-macos-x86_64"
      sha256 "cfc1d266fcdf53fa74be72594922b47c317636dbfc81dcca6b088b77c82dfb1e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-030744-32685351848-1-6e8656291504/xfx-linux-aarch64"
      sha256 "8f06f133037e9468fd06a9c5ad7e5624a5b4682c6075d8f30655eb2007e4caa4"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-030744-32685351848-1-6e8656291504/xfx-linux-x86_64"
      sha256 "640353f525e328ee5ec6673824a1df40dad1cdfe9ce832c5a9d00d0642ba0a8f"
    end
  end

  link_overwrite "bin/xfx"

  def install
    bin.install Dir["xfx-*"].first => "xfx"
  end

  test do
    # `xfx --version` prints the Cargo version (0.1.0) on every channel, so it
    # cannot prove this is the preview build. `status --json` carries the
    # compile-time build identity, which is what the preview channel promises.
    status = JSON.parse(shell_output("#{bin}/xfx status --json"))
    assert_equal "preview", status["build_channel"]
    assert_equal SOURCE_REVISION, status["build_revision"]
  end
end
