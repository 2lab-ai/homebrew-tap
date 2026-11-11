class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.11.11.121927.43019311819.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-11-11-121927-43019311819-1-afeaea7cd3e7
  # source: afeaea7cd3e73d8ceefb5773de36c06cbb96c2e1
  SOURCE_REVISION = "afeaea7cd3e7".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-11-121927-43019311819-1-afeaea7cd3e7/xfx-macos-aarch64"
      sha256 "9344128d1404115dc862466ef851c2a7ee938076b9ad6d26f1b002b957b1bfbf"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-11-121927-43019311819-1-afeaea7cd3e7/xfx-macos-x86_64"
      sha256 "0b1f8100d97fb22b45f88201038d7c7550c3d464a817e9a6b105d63aaa6a4b03"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-11-121927-43019311819-1-afeaea7cd3e7/xfx-linux-aarch64"
      sha256 "992bf458b3f773d4fe21d2a710085b3a8a4980468b3e7390975d94d8647bc1bd"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-11-121927-43019311819-1-afeaea7cd3e7/xfx-linux-x86_64"
      sha256 "dcd7eac1ee4565bbe7aadda421b3275e17f646f90cb0d1ca31836b56da9ca8c6"
    end
  end

  link_overwrite "bin/xfx"

  def install
    bin.install Dir["xfx-*"].first => "xfx"
  end

  test do
    # `xfx --version` names the build: `xfx <version> (preview <id>)`, where
    # <id> is the release tag's UTC minute and the 12-character revision
    # (YYYY-MM-DD-HHMM-<sha12>). `status --json` carries the same identity.
    assert_match(/ \(preview \d{4}-\d{2}-\d{2}-\d{4}-#{SOURCE_REVISION}\)\z/,
                 shell_output("#{bin}/xfx --version").strip)
    status = JSON.parse(shell_output("#{bin}/xfx status --json"))
    assert_equal "preview", status["build_channel"]
    assert_equal SOURCE_REVISION, status["build_revision"]
  end
end
