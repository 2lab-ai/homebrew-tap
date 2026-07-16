class DbotterPreview < Formula
  desc "Local Rust database client for MySQL and Redis (preview channel)"
  homepage "https://github.com/2lab-ai/dbotter"
  version "2026.07.16.094917.29487397821.1"
  license "Apache-2.0"

  # Immutable release identity:
  # tag: preview-2026-07-16-094917-29487397821-1-3160ac6a337e
  # source: 3160ac6a337ec6600e36955a0e6568023eaa9d5a
  # manifest: https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-16-094917-29487397821-1-3160ac6a337e/preview-manifest.json
  # manifest-sha256: 324de87b442ba99b9d60f31a01741263896c0dae78492deb551f6b1b3dcc8cf1

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-16-094917-29487397821-1-3160ac6a337e/dbotter-preview-aarch64.tar.gz"
      sha256 "bd03ffa49947f20291f9a50abd7c5d75ebf79807c974d5a3052663c41af4dea9"
    end
    on_intel do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-16-094917-29487397821-1-3160ac6a337e/dbotter-preview-x86_64.tar.gz"
      sha256 "c6c8365de77a0f26efd56789cf8cdfe4b077a9dc51b82c6b81efd390c74bb326"
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
