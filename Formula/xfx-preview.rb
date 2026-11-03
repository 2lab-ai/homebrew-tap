class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.11.03.233634.41740485465.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-11-03-233634-41740485465-1-93f516b537ad
  # source: 93f516b537adf52db208e3a343d9229c5f3d40e2
  SOURCE_REVISION = "93f516b537ad".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-03-233634-41740485465-1-93f516b537ad/xfx-macos-aarch64"
      sha256 "2d25c5d984e863d486ef8db3663ade6b23e51500593fbb7a356d3718bf59f73c"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-03-233634-41740485465-1-93f516b537ad/xfx-macos-x86_64"
      sha256 "1ea7bb79bc4155eea60a1640004b75892de0ecc7cd8eedd8aeca20dc2453c036"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-03-233634-41740485465-1-93f516b537ad/xfx-linux-aarch64"
      sha256 "a153a125823beb0d6603b143bb48193682e6d9c28adb17aa26bbdae7abb8e498"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-03-233634-41740485465-1-93f516b537ad/xfx-linux-x86_64"
      sha256 "348c952dcc4ff5f1aa70b2d292020dbade6d46c703a89ef7521b09c0b7065b53"
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
