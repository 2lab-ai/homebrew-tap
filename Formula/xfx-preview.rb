class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.08.22.084137.32562947487.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-08-22-084137-32562947487-1-3bdcaec4803f
  # source: 3bdcaec4803fc36a50a6561e3faa891250188fc4
  SOURCE_REVISION = "3bdcaec4803f".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-22-084137-32562947487-1-3bdcaec4803f/xfx-macos-aarch64"
      sha256 "14a891d051629079cfd3b1e04290d6a943a53f6a87932f1426fd470305a654e9"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-22-084137-32562947487-1-3bdcaec4803f/xfx-macos-x86_64"
      sha256 "af04483558ae7493248e853e0bb421eab57530b6e29bf8a66bdef1fc72b09f3d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-22-084137-32562947487-1-3bdcaec4803f/xfx-linux-aarch64"
      sha256 "a5950cf3ce1aa997ffbbd801ca6d1747e43a46bd96a681520b00cbd6981cd527"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-22-084137-32562947487-1-3bdcaec4803f/xfx-linux-x86_64"
      sha256 "812a02a14ab386a1f892a9dfa1e03c785c69b4dabb633943fc274e01560f401f"
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
