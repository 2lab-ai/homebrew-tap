class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.08.21.1647"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-21-1647-b73db97509ac/herdr-macos-aarch64"
      sha256 "ab89c3526318ca69d9205cfb6fa02b13e8381b958d09ae5f2d7713e1486cf51d"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-21-1647-b73db97509ac/herdr-macos-x86_64"
      sha256 "06aa70fa3b8c866c033e21e553c6b9921cf9919060c846cb2b8b1395ddb1f89a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-21-1647-b73db97509ac/herdr-linux-aarch64"
      sha256 "52b28695ffc4bb4811c72fb7648387da0e8b854da7680cd7cc74921a2b651d94"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-21-1647-b73db97509ac/herdr-linux-x86_64"
      sha256 "cd7843116fb265db31b8d688c99a54194c3070f62cc2680e8a42744765c1ad5c"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
