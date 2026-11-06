class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.11.06.172119.42260843024.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-11-06-172119-42260843024-1-0b16d7e579b5
  # source: 0b16d7e579b53a02b9ce3e288c1b93b042a7ab7b
  SOURCE_REVISION = "0b16d7e579b5".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-06-172119-42260843024-1-0b16d7e579b5/xfx-macos-aarch64"
      sha256 "39d4c155385f1511a2a0e5bb2e33d1fe7919436c6bf57b6042d27ba828589776"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-06-172119-42260843024-1-0b16d7e579b5/xfx-macos-x86_64"
      sha256 "0a3ee682d103be5df3f16e9c0695dd0ee6dadcc2d44ce9bff028a33d38f5f14b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-06-172119-42260843024-1-0b16d7e579b5/xfx-linux-aarch64"
      sha256 "19f9fbc9180f395ad0efee4a98081dc87ad2f768c9b52f2261c36e79264d96aa"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-06-172119-42260843024-1-0b16d7e579b5/xfx-linux-x86_64"
      sha256 "c247b3427025a2f96fe5550ffd5e96b0cdd5c084cbb9b18dd2c985cfaadb07e8"
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
