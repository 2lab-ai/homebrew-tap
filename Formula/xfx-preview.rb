class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.08.24.141446.32737492970.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-08-24-141446-32737492970-1-ea3dc9dfe7ce
  # source: ea3dc9dfe7ce02996e37c68f601d52508f859e61
  SOURCE_REVISION = "ea3dc9dfe7ce".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-141446-32737492970-1-ea3dc9dfe7ce/xfx-macos-aarch64"
      sha256 "8eb79c579bca58e8381ca52f1187fed69db1dbaa8d875213b4c962d9b9064ea1"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-141446-32737492970-1-ea3dc9dfe7ce/xfx-macos-x86_64"
      sha256 "b6fa750319524de3762a61f7328c696c618e574cb27f5437a92821f9d24d6f10"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-141446-32737492970-1-ea3dc9dfe7ce/xfx-linux-aarch64"
      sha256 "76b6868fab6ea39a2bee0e3a89ea2e324ce7ab34e232233426282799f6f920a0"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-141446-32737492970-1-ea3dc9dfe7ce/xfx-linux-x86_64"
      sha256 "c93a7448ae5441cb0b57a64efa48bf21f7f2075535861471c39647bec68800c3"
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
