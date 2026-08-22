class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.08.22.001322.32539611227.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-08-22-001322-32539611227-1-13305501162e
  # source: 13305501162e0902ab7539aa78d674003ecdaaa5
  SOURCE_REVISION = "13305501162e".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-22-001322-32539611227-1-13305501162e/xfx-macos-aarch64"
      sha256 "f76b10ead452346022afa79597caeba8c49ed3a364c8de6c217739bbdc75bb01"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-22-001322-32539611227-1-13305501162e/xfx-macos-x86_64"
      sha256 "77390e5854fb3dc96e0f644d94cd145100b74bed0e050f646cd72f74011602b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-22-001322-32539611227-1-13305501162e/xfx-linux-aarch64"
      sha256 "43335017ca9303c05ac61a7aed0a2f08386344d4e5aee7966e9cea32fddbac2b"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-22-001322-32539611227-1-13305501162e/xfx-linux-x86_64"
      sha256 "4013cf2a6ca051294073b1156900e4cf82e0f326504065d79a91c6ba89359863"
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
