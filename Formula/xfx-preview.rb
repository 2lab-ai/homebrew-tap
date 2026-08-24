class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.08.24.041207.32689110942.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-08-24-041207-32689110942-1-05f1d0eedd27
  # source: 05f1d0eedd27cfbf408ecf0e1a278fd99ac651c8
  SOURCE_REVISION = "05f1d0eedd27".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-041207-32689110942-1-05f1d0eedd27/xfx-macos-aarch64"
      sha256 "d1babe2a65a6d018731cd47b8042909c26ce1da94800246ecd14ac9324d06423"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-041207-32689110942-1-05f1d0eedd27/xfx-macos-x86_64"
      sha256 "a8c58f49f4fb379e28416a4ec16ea7ccf5c962d376f61b2be2b12753ecc48bf0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-041207-32689110942-1-05f1d0eedd27/xfx-linux-aarch64"
      sha256 "bf3d46bb25f01b9a4147019e8b6d1e975cf8e3a0abba32aed75cf6b9cc7d0653"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-041207-32689110942-1-05f1d0eedd27/xfx-linux-x86_64"
      sha256 "f9204c6da31ab070155a9bdaeb076e7f960aa3f940c94b365ed248df9a25b407"
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
