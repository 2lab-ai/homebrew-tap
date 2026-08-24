class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.08.24.035151.32687917880.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-08-24-035151-32687917880-1-00e6264902e5
  # source: 00e6264902e54cc94051e09dcc4dc4f446cb527b
  SOURCE_REVISION = "00e6264902e5".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-035151-32687917880-1-00e6264902e5/xfx-macos-aarch64"
      sha256 "c12dad3bc6694439e5bfc44458e2f361582a73e56f6d9aab25c7502471488fa5"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-035151-32687917880-1-00e6264902e5/xfx-macos-x86_64"
      sha256 "ed2d55b9806270a684a19f3ec48911a00e394636743d9cb7a81d57f0a2a0a124"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-035151-32687917880-1-00e6264902e5/xfx-linux-aarch64"
      sha256 "d54e1fa58db7d2785f2d0265351908d786bd4884e31c38872f75919b44896e7a"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-035151-32687917880-1-00e6264902e5/xfx-linux-x86_64"
      sha256 "fa0620dce576b5f9ba86206792d1753ef2df419bc131cef8a2f02ae0543e6e3a"
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
