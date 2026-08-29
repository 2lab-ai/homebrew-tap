class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.08.29.193913.33271421715.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-08-29-193913-33271421715-1-edcc2f551587
  # source: edcc2f5515870f50ac3b9ffc71201a52a0d1f746
  SOURCE_REVISION = "edcc2f551587".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-29-193913-33271421715-1-edcc2f551587/xfx-macos-aarch64"
      sha256 "fee58345e5606cda0e1c18389c4ac1c319f8e8d7f734b1b920674feafa6b5724"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-29-193913-33271421715-1-edcc2f551587/xfx-macos-x86_64"
      sha256 "e49b991263d87e25ddb1e80256c2dfdfe322b36a9d7a9084b78aa59d4cac70dd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-29-193913-33271421715-1-edcc2f551587/xfx-linux-aarch64"
      sha256 "7ddae8045a45802c7a7fe09c1c38d901b26218829be8b7dcea059a7f266cbffe"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-29-193913-33271421715-1-edcc2f551587/xfx-linux-x86_64"
      sha256 "cc33a86aa501a3569416eb3c440964d00e166740301c058d1f76dd046028e36f"
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
