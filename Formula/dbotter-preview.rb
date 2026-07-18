class DbotterPreview < Formula
  desc "Local Rust database client for MySQL and Redis (preview channel)"
  homepage "https://github.com/2lab-ai/dbotter"
  version "2026.07.18.094835.29639223586.1"
  license "Apache-2.0"

  # Immutable release identity:
  # tag: preview-2026-07-18-094835-29639223586-1-7bfae29d4e70
  # source: 7bfae29d4e7094a66d4dd5462504618db6778470
  # manifest: https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-18-094835-29639223586-1-7bfae29d4e70/preview-manifest.json
  # manifest-sha256: fb66e38353ba676153ab67357a5b227ba4a61559a44d4002468d561d3155e80e

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-18-094835-29639223586-1-7bfae29d4e70/dbotter-preview-aarch64.tar.gz"
      sha256 "58e4cb5fad286fd7719175458661b63cce82f9bfc993248c5739f028ba954217"
    end
    on_intel do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-18-094835-29639223586-1-7bfae29d4e70/dbotter-preview-x86_64.tar.gz"
      sha256 "d5f25009a6f5c03ad8543802cc4bf0cf089610c303a3bf7b6c26c444efc7707a"
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
