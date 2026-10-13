class HarnPreview < Formula
  desc "Lists the harness an AI coding agent loads for a directory, reversibly"
  homepage "https://github.com/2lab-ai/harn"
  version "2026.10.13.1411"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-1411-a21f2a13a53d/harn-macos-aarch64"
      sha256 "ea24b2b851a72aef89d28acc740cd17f269ec9948d3ddbd7cda72fdba5289ac4"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-1411-a21f2a13a53d/harn-macos-x86_64"
      sha256 "dfa51123c1d2fdc246f6f5abe7e85320799745ff1621fbc8a4d4d5e49303c95f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-1411-a21f2a13a53d/harn-linux-aarch64"
      sha256 "f3e43682a7f0098710817b3c03191f2623b5382c92547440493c168fc09b0c32"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-1411-a21f2a13a53d/harn-linux-x86_64"
      sha256 "af5448379693a12fd3baa7c4f55754fa948f609fd17a47cdc1a817ea551b1150"
    end
  end

  link_overwrite "bin/harn"

  def install
    bin.install Dir["harn-*"].first => "harn"
  end

  test do
    assert_match "preview", shell_output("#{bin}/harn --version")
  end
end
