class DbotterPreview < Formula
  desc "Local Rust database client for MySQL and Redis (preview channel)"
  homepage "https://github.com/2lab-ai/dbotter"
  version "2026.07.16.161750.29513008288.2"
  license "Apache-2.0"

  # Immutable release identity:
  # tag: preview-2026-07-16-161750-29513008288-2-11a839fadadb
  # source: 11a839fadadbbe6d380f516a37b1708ea4917cd1
  # manifest: https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-16-161750-29513008288-2-11a839fadadb/preview-manifest.json
  # manifest-sha256: c569c19d0681c1ecda59683d44f4a1ae32730fdbc50fb9d4e0e932bad4cca898

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-16-161750-29513008288-2-11a839fadadb/dbotter-preview-aarch64.tar.gz"
      sha256 "e8ba811ec959536505bf547201f9d99113ee2c9cf0b4b6c8fb90b960ad283eca"
    end
    on_intel do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-16-161750-29513008288-2-11a839fadadb/dbotter-preview-x86_64.tar.gz"
      sha256 "5b0705ade9bc1caf85935337077bb0541a6b13f2a16521b65fabd310ca516b23"
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
