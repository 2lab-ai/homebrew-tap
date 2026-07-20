class DbotterPreview < Formula
  desc "Local Rust database client for MySQL and Redis (preview channel)"
  homepage "https://github.com/2lab-ai/dbotter"
  version "2026.07.20.095048.29731634437.1"
  license "Apache-2.0"

  # Immutable release identity:
  # tag: preview-2026-07-20-095048-29731634437-1-5f887198112c
  # source: 5f887198112c46f308c50b6596610afb9720415b
  # manifest: https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-20-095048-29731634437-1-5f887198112c/preview-manifest.json
  # manifest-sha256: f5302654a20cffa51497aa1f504b44d80f721230099f27ce090df91d8e8cffce

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-20-095048-29731634437-1-5f887198112c/dbotter-preview-aarch64.tar.gz"
      sha256 "cef791d0964f5005df17a1d15c307201c3357e7c229cc9dd1e73b53f2379f5b2"
    end
    on_intel do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-20-095048-29731634437-1-5f887198112c/dbotter-preview-x86_64.tar.gz"
      sha256 "107cab58054b2e38d86e2c860eab89a62d504ba653376f29409e4e0b76b5afcb"
    end
  end

  link_overwrite "bin/dbotter"

  def install
    app = prefix/"Dbotter Preview.app"
    if (buildpath/"Dbotter Preview.app").directory?
      prefix.install "Dbotter Preview.app"
    elsif (buildpath/"Contents").directory?
      app.install "Contents"
    else
      odie "Dbotter Preview.app payload is missing"
    end
    bin.install_symlink app/"Contents/MacOS/dbotter" => "dbotter"
  end

  test do
    assert_predicate prefix/"Dbotter Preview.app", :directory?
    assert_predicate prefix/"Dbotter Preview.app/Contents/MacOS/dbotter", :executable?
    assert_match "preview", shell_output("#{bin}/dbotter --version")
    shell_output("#{bin}/dbotter drivers")
  end
end
