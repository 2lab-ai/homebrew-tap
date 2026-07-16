class DbotterPreview < Formula
  desc "Local Rust database client for MySQL and Redis (preview channel)"
  homepage "https://github.com/2lab-ai/dbotter"
  version "2026.07.16.213015.29534925455.1"
  license "Apache-2.0"

  # Immutable release identity:
  # tag: preview-2026-07-16-213015-29534925455-1-8a22e1393134
  # source: 8a22e1393134450025a275be19a97332d06317b7
  # manifest: https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-16-213015-29534925455-1-8a22e1393134/preview-manifest.json
  # manifest-sha256: 78972dda57348b78bb23bea519b044528698a39b30aa9e6741d0fc8f270f00a8

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-16-213015-29534925455-1-8a22e1393134/dbotter-preview-aarch64.tar.gz"
      sha256 "15a4de1e83d93b014f6bead2cfc1f707611a6b6af22448e4c45f04bfb5615046"
    end
    on_intel do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-16-213015-29534925455-1-8a22e1393134/dbotter-preview-x86_64.tar.gz"
      sha256 "6d2ba551db84b28403c022e919e4e43e40e80b5dd8aa0ee64bd89f4ccd7c2c1e"
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
