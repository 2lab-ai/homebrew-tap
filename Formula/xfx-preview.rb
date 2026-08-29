class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.08.29.173210.33265879878.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-08-29-173210-33265879878-1-09fa05639e25
  # source: 09fa05639e258aed0599d5dfcf26e780fcdb04e7
  SOURCE_REVISION = "09fa05639e25".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-29-173210-33265879878-1-09fa05639e25/xfx-macos-aarch64"
      sha256 "5034067deaa4201bcc03a41c268ce1b2f525465ec1b01a289173e20a104a83a9"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-29-173210-33265879878-1-09fa05639e25/xfx-macos-x86_64"
      sha256 "f82d6ede9323321b8850d17017969851614b887956d730dac34e10977ec535a4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-29-173210-33265879878-1-09fa05639e25/xfx-linux-aarch64"
      sha256 "feba0cde0ab578aad81673175ce7ba5c1fd0518f634a65daeb5419e7654a7871"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-29-173210-33265879878-1-09fa05639e25/xfx-linux-x86_64"
      sha256 "332b5b4b758529923373c45c196a83c9fc7a2e270144ed518074911c6788b099"
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
