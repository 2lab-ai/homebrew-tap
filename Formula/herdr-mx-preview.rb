class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.08.21.2034"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-21-2034-8fec6568a040/herdr-macos-aarch64"
      sha256 "e67d6b17ccd819ba0334ee62dc3e1d9eea362c52ea28bea0fc609d1c7956f369"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-21-2034-8fec6568a040/herdr-macos-x86_64"
      sha256 "1beab24244b1d4d62619bdc0b6860e67a17ddb51068e9b96a135a62a595a9a3e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-21-2034-8fec6568a040/herdr-linux-aarch64"
      sha256 "4aa50bc70cf6c36ed03b26d761f1860a859ee7d7e5bdc524021c9b5cfd5a77f8"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-08-21-2034-8fec6568a040/herdr-linux-x86_64"
      sha256 "9f24680bca5f765e02f33af0e429b2951a4f3c0c90b70cfad89121a7301e9ec3"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
