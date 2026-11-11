class Xfx < Formula
  desc "Rust port of the fx agentic coding CLI"
  homepage "https://github.com/2lab-ai/xfx"
  version "0.2.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/v0.2.0/xfx-aarch64-apple-darwin.tar.gz"
      sha256 "7f21d4b8f56159c7a35e52a66156211284b4111097a7143ccede80721344f41e"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/v0.2.0/xfx-x86_64-apple-darwin.tar.gz"
      sha256 "e89818e4e390ebf04893eeb1108781f087171657dc8336e3150a0dd98305a04b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/v0.2.0/xfx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "11d5f75ffdd0fd33528ed610fbe146311ab103748d1136243d406823db175d95"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/v0.2.0/xfx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ffc771f2adbe9961d5b03a52125812e47b22002a30c1d0f597167ebfc727b4a8"
    end
  end

  link_overwrite "bin/xfx"

  def install
    # Each stable archive extracts to xfx-<rust-target>/ alongside its LICENSE,
    # NOTICE and docs; only the executable is installed.
    bin.install Dir["xfx-*/xfx"].first => "xfx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xfx --version")

    # The Cargo version is identical on every channel, so it cannot prove this
    # is the stable build. `status --json` carries the compile-time build
    # identity, which is what the release channel promises.
    status = JSON.parse(shell_output("#{bin}/xfx status --json"))
    assert_equal "release", status["build_channel"]
  end
end
