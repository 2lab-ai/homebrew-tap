class DbotterPreview < Formula
  desc "Local Rust database client for MySQL and Redis (preview channel)"
  homepage "https://github.com/2lab-ai/dbotter"
  version "2026.07.15.230832.29456766125.1"
  license "Apache-2.0"

  # Immutable release identity:
  # tag: preview-2026-07-15-230832-29456766125-1-340133dca652
  # source: 340133dca652a7bf51d652f06cdb7436b42bbc58
  # manifest: https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-15-230832-29456766125-1-340133dca652/preview-manifest.json
  # manifest-sha256: acf141c4eeb6fd1e5211b97097469116cf70619a742dfaa5ef7fe0ef4c2d1211

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-15-230832-29456766125-1-340133dca652/dbotter-preview-aarch64.tar.gz"
      sha256 "85a8ca1d1db1d7495b020e7637197a1ea910c97bc38137c8b7c45ca9fb856fdd"
    end
    on_intel do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-15-230832-29456766125-1-340133dca652/dbotter-preview-x86_64.tar.gz"
      sha256 "18d1acdaa1555ac2f4b29bf9152f8ce2f4f8c2ff67d4b484d38b4c60f114d9a1"
    end
  end

  link_overwrite "bin/dbotter"

  def install
    prefix.install "Dbotter Preview.app"
    bin.install_symlink prefix/"Dbotter Preview.app/Contents/MacOS/dbotter" => "dbotter"
  end

  test do
    assert_predicate prefix/"Dbotter Preview.app", :directory?
    assert_predicate prefix/"Dbotter Preview.app/Contents/MacOS/dbotter", :executable?
    assert_match "preview", shell_output("#{bin}/dbotter --version")
    shell_output("#{bin}/dbotter drivers")
  end
end
