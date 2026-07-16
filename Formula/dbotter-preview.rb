class DbotterPreview < Formula
  desc "Local Rust database client for MySQL and Redis (preview channel)"
  homepage "https://github.com/2lab-ai/dbotter"
  version "2026.07.16.083904.29483123549.1"
  license "Apache-2.0"

  # Immutable release identity:
  # tag: preview-2026-07-16-083904-29483123549-1-976f73db687d
  # source: 976f73db687d830b76049019a5b57c1ffdcee499
  # manifest: https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-16-083904-29483123549-1-976f73db687d/preview-manifest.json
  # manifest-sha256: a3bdd491f168cbd993944d7d20f490109b7c7d6f1c87818fa71175068910a371

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-16-083904-29483123549-1-976f73db687d/dbotter-preview-aarch64.tar.gz"
      sha256 "5ef8a48150b2b17e9adbf675dce368c6bcd6712e7c7bc54912eb17a3364161a9"
    end
    on_intel do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-16-083904-29483123549-1-976f73db687d/dbotter-preview-x86_64.tar.gz"
      sha256 "27199c5c0ee2218a4008714f8c39600fed4b6c3c3332b7739199481defda5b3f"
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
