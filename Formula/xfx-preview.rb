class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.08.25.221443.32905189256.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-08-25-221443-32905189256-1-f1913a6be24f
  # source: f1913a6be24fcc0c8ade6c460686f89d231a4f37
  SOURCE_REVISION = "f1913a6be24f".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-25-221443-32905189256-1-f1913a6be24f/xfx-macos-aarch64"
      sha256 "da18e61d3011cdfef7a5e43125696c0a00f1378e1d8acefef6eabf7c119c6a0b"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-25-221443-32905189256-1-f1913a6be24f/xfx-macos-x86_64"
      sha256 "7eda717e4e2ff6c861c4faaa37275c8ee7d29001e425cfcbafdd4814141465ab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-25-221443-32905189256-1-f1913a6be24f/xfx-linux-aarch64"
      sha256 "1ce417643acfdd0f8f0f7387a5aa9845389654d711a9d694e14380772a5ff901"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-25-221443-32905189256-1-f1913a6be24f/xfx-linux-x86_64"
      sha256 "f3ed65b54266634918b56c1580a3fec974154f0d7ed4ee62a46450a628a69249"
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
