class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.11.06.024852.42152675426.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-11-06-024852-42152675426-1-2e266236cc57
  # source: 2e266236cc57c0a6da45a2404e5d7d1d3ea1b7bf
  SOURCE_REVISION = "2e266236cc57".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-06-024852-42152675426-1-2e266236cc57/xfx-macos-aarch64"
      sha256 "8f66a70ac3ec362ac2ceab8d78c1f1d8736b028bbcd9bdab44d471f420e0d7e4"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-06-024852-42152675426-1-2e266236cc57/xfx-macos-x86_64"
      sha256 "11e48194fb027cff80c42b144e0a79c639e5b34414e088c487c7bbb9b14f7c5a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-06-024852-42152675426-1-2e266236cc57/xfx-linux-aarch64"
      sha256 "6e88b41f05091f19def9925cf0474f693ac86b87975df7a90226dc73532ca409"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-06-024852-42152675426-1-2e266236cc57/xfx-linux-x86_64"
      sha256 "2cbbb4add19034bc52c4a4a66a1a5e04caab09b1c1bab37cdec4b14889490dbf"
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
