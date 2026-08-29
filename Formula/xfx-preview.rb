class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.08.29.190455.33269934844.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-08-29-190455-33269934844-1-c5cbad561e62
  # source: c5cbad561e62514b8e8b8282df60b4e7c2b2f9d6
  SOURCE_REVISION = "c5cbad561e62".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-29-190455-33269934844-1-c5cbad561e62/xfx-macos-aarch64"
      sha256 "cddd3b2674425579e5e0868dc43c91b7fe9b880b6021b0059f2bb0e95e91b87e"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-29-190455-33269934844-1-c5cbad561e62/xfx-macos-x86_64"
      sha256 "d465ec31291bc7f3da1e844e88cd1bed24276fbd16c33992cb110aa2563f8bc2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-29-190455-33269934844-1-c5cbad561e62/xfx-linux-aarch64"
      sha256 "071154b7698d6ab6f8770652c88115ab37199f14aed3796ad0a058cc9cfbbaa2"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-29-190455-33269934844-1-c5cbad561e62/xfx-linux-x86_64"
      sha256 "63e78e267c76565986cf995816ccd6586fa5190142808f70d9445090c6a7cf19"
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
