class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.11.10.122006.42814832116.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-11-10-122006-42814832116-1-8f9214251710
  # source: 8f9214251710c13f3083ea564acc7cc17e4d0057
  SOURCE_REVISION = "8f9214251710".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-10-122006-42814832116-1-8f9214251710/xfx-macos-aarch64"
      sha256 "4bfd4897cc794bde290f80126449fb1956047fb5d131e3a352ca7bf2f8412454"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-10-122006-42814832116-1-8f9214251710/xfx-macos-x86_64"
      sha256 "bf55be8af68228b5a52af9618c0f49badbef285491183f08d2a8d20f68fe5e84"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-10-122006-42814832116-1-8f9214251710/xfx-linux-aarch64"
      sha256 "03cc79e839612a7f6f7944b4d69df118c1f2d34a22e32a4f37d17e21413e522a"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-10-122006-42814832116-1-8f9214251710/xfx-linux-x86_64"
      sha256 "18af4386cad647e8366be34fe5bb94a551b1fc10f48f1d79fd8120eb235c9a72"
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
