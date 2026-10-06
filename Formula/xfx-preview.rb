class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.10.06.112101.37455797717.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-10-06-112101-37455797717-1-ab55e133dce2
  # source: ab55e133dce2f9f6939224c1d6ee0c2d39a71506
  SOURCE_REVISION = "ab55e133dce2".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-10-06-112101-37455797717-1-ab55e133dce2/xfx-macos-aarch64"
      sha256 "0f59cb4b19f5bc8920afa91bb7bae67ee4111ffe2269d6516718369f0a9fef15"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-10-06-112101-37455797717-1-ab55e133dce2/xfx-macos-x86_64"
      sha256 "f0bd3517733fdb51d8ce4f887d5c7166e5c455d7350316d6175d66b6fa2a3a48"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-10-06-112101-37455797717-1-ab55e133dce2/xfx-linux-aarch64"
      sha256 "0e9c07a500f0bfd5fc6b4ce61f4fcf922f8f696e2b9dc3bce8969067243d417c"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-10-06-112101-37455797717-1-ab55e133dce2/xfx-linux-x86_64"
      sha256 "c871be26e06e8a12315a39622400086f008f55493072717692272668c2f58477"
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
