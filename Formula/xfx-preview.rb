class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.08.24.040226.32688529457.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-08-24-040226-32688529457-1-7c99e449cc1c
  # source: 7c99e449cc1c0ac7598de2be4590e8c12afecfaa
  SOURCE_REVISION = "7c99e449cc1c".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-040226-32688529457-1-7c99e449cc1c/xfx-macos-aarch64"
      sha256 "43eb53b814a8286e7f72d1bde741f66a4e131ca222214c8f7e86f125d26e03a5"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-040226-32688529457-1-7c99e449cc1c/xfx-macos-x86_64"
      sha256 "df3eaaaba3438215c09bec2a0449a166d12e7e7d895d390162965dfa2717c211"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-040226-32688529457-1-7c99e449cc1c/xfx-linux-aarch64"
      sha256 "c5d7e8656419b4346d825b561f17b42325597b533ed4ec4b155398416223024b"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-08-24-040226-32688529457-1-7c99e449cc1c/xfx-linux-x86_64"
      sha256 "38430afc20593c34829956269f66e1573ce7df19a6045db3797f9161309e7cd4"
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
