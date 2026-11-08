class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.11.08.155709.42497362081.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-11-08-155709-42497362081-1-f096c163e659
  # source: f096c163e659310069790176b387d9a912ce0b51
  SOURCE_REVISION = "f096c163e659".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-08-155709-42497362081-1-f096c163e659/xfx-macos-aarch64"
      sha256 "6f01f0d92aeab060ab4621585798866300d7eef9f71f36630c03fbf6da430b69"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-08-155709-42497362081-1-f096c163e659/xfx-macos-x86_64"
      sha256 "37e63c9a0c041e6c5881a3446b4de6b51cc0de4e65fb7f9580f9d336e57d6cbe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-08-155709-42497362081-1-f096c163e659/xfx-linux-aarch64"
      sha256 "f9268a0396b361bfda9c8c1f5c9ba2c17869f174bac53f9f62ed02a47db88312"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-08-155709-42497362081-1-f096c163e659/xfx-linux-x86_64"
      sha256 "e3f7b7b8a7095f9f418c4ddfff0e722ded6b8c7b7dcd61046fb9dc4a3c26dba7"
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
