class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.10.06.115638.37459773015.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-10-06-115638-37459773015-1-14ad04202fe5
  # source: 14ad04202fe54ff266fca0ca94c93a74a510e927
  SOURCE_REVISION = "14ad04202fe5".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-10-06-115638-37459773015-1-14ad04202fe5/xfx-macos-aarch64"
      sha256 "0a4d03c07358791467f6fd4d738e6b983d6b790844b64db0ee84d7ade1483a32"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-10-06-115638-37459773015-1-14ad04202fe5/xfx-macos-x86_64"
      sha256 "ea06e5d1d4923a130c95acb80f385ae2f45275a9bbabcd0b48b5bef14754f368"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-10-06-115638-37459773015-1-14ad04202fe5/xfx-linux-aarch64"
      sha256 "61a78fc6c18cf7f0de623373a85708e27848e3742c65a34ede50a90a435234cb"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-10-06-115638-37459773015-1-14ad04202fe5/xfx-linux-x86_64"
      sha256 "1c465895fd9e6e0382be61194ea8fa225ce5c697dee26d3f68557a2552cc7b3e"
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
