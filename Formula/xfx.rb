class Xfx < Formula
  desc "Rust port of the fx agentic coding CLI"
  homepage "https://github.com/2lab-ai/xfx"
  version "0.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/v0.1.0/xfx-aarch64-apple-darwin.tar.gz"
      sha256 "d6aa600b66451f46398b3525ecc2f290a69e6df895fb14d04c5b16d1960e48b5"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/v0.1.0/xfx-x86_64-apple-darwin.tar.gz"
      sha256 "8811b0181358e5d7aba12dd438f6dc102d1be6ce2f50e4f3f03a9d0467a2d966"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/v0.1.0/xfx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b13f13f2c1467f2f60d020f6b9fd05504d14172d6b76628040ae40d713fafcd6"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/v0.1.0/xfx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "afab4a33acba811212a2a8492ac57edc9e0f16d4b551aa49a737beb4a8ab183f"
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
