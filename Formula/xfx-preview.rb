class XfxPreview < Formula
  desc "Rust port of the fx agentic coding CLI (preview channel)"
  homepage "https://github.com/2lab-ai/xfx"
  version "2026.11.07.051721.42342073586.1"
  license "Apache-2.0"

  # Immutable preview identity, rendered from the exact prerelease:
  # tag: preview-2026-11-07-051721-42342073586-1-4e68d4d3b00c
  # source: 4e68d4d3b00cd3abcf22336dd8a263206c8cb6a3
  SOURCE_REVISION = "4e68d4d3b00c".freeze

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-07-051721-42342073586-1-4e68d4d3b00c/xfx-macos-aarch64"
      sha256 "b35defb7ff4be54f814ea42c9d2968e58d28963554c8c97b241822d883b81937"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-07-051721-42342073586-1-4e68d4d3b00c/xfx-macos-x86_64"
      sha256 "e70a10f35bbdc5efa473ebf72c588b26cdd2d86fe32f8a01bc80b2ba5779677f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-07-051721-42342073586-1-4e68d4d3b00c/xfx-linux-aarch64"
      sha256 "9f4a0aa3beef68f7ea2122076f02bb001691c3bfee40ff9af49d378f7a235b80"
    end
    on_intel do
      url "https://github.com/2lab-ai/xfx/releases/download/preview-2026-11-07-051721-42342073586-1-4e68d4d3b00c/xfx-linux-x86_64"
      sha256 "9d12bfc6a42bdbbc246241019ecafca4a68dbc67c6a353051e859a90622dcbfa"
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
