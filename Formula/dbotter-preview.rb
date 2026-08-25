class DbotterPreview < Formula
  desc "Local Rust database client for MySQL and Redis (preview channel)"
  homepage "https://github.com/2lab-ai/dbotter"
  version "2026.08.25.081710.32824018255.1"
  license "Apache-2.0"

  # Immutable release identity:
  # tag: preview-2026-08-25-081710-32824018255-1-0ab3bb2df44f
  # source: 0ab3bb2df44f186d6b8b35c9b98a07120298041b
  # manifest: https://github.com/2lab-ai/dbotter/releases/download/preview-2026-08-25-081710-32824018255-1-0ab3bb2df44f/preview-manifest.json
  # manifest-sha256: 613681e31122b53c1cc4d5a6fa68bfae0e235aa5fb8dcdf782ab43cf6a2068d7

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-08-25-081710-32824018255-1-0ab3bb2df44f/dbotter-preview-aarch64.tar.gz"
      sha256 "cbe492d2a3ad79eef309bb8ab3c614da7c8982f76054af768bfab970e2971958"
    end
    on_intel do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-08-25-081710-32824018255-1-0ab3bb2df44f/dbotter-preview-x86_64.tar.gz"
      sha256 "2b45f6c15bbbd45976f8d8a5683c907094ed2da89d929be8985022698f134e77"
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
