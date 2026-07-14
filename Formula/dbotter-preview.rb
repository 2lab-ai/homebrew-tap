class DbotterPreview < Formula
  desc "Local Rust database client for MySQL and Redis (preview channel)"
  homepage "https://github.com/2lab-ai/dbotter"
  version "2026.07.14.1121"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-14-1121-8966e3abb67b/dbotter-macos-aarch64"
      sha256 "f2d131ea2d75025b1b25551459469462733a2fb5eceac1c829cea05491a730e5"
    end
    on_intel do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-14-1121-8966e3abb67b/dbotter-macos-x86_64"
      sha256 "03f711e603fe5a184262d9537b2a2061fa2f5bd0086fc0cae83a3719762919c7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-14-1121-8966e3abb67b/dbotter-linux-aarch64"
      sha256 "a550aee0eb537344086241f210324af2688314dc5e1e794b695c9f4c757e7a1b"
    end
    on_intel do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-14-1121-8966e3abb67b/dbotter-linux-x86_64"
      sha256 "e688ea5629c77eb4d827079c162ffd786d8d7020d9b3aa69c7706bbcf71d97a5"
    end
  end

  link_overwrite "bin/dbotter"

  def install
    bin.install Dir["dbotter-*"].first => "dbotter"
  end

  test do
    assert_match "preview", shell_output("#{bin}/dbotter --version")
    shell_output("#{bin}/dbotter drivers")
  end
end
