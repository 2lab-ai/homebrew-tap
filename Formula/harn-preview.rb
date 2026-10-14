class HarnPreview < Formula
  desc "Lists the harness an AI coding agent loads for a directory, reversibly"
  homepage "https://github.com/2lab-ai/harn"
  version "2026.10.14.0546"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-0546-088946a83680/harn-macos-aarch64"
      sha256 "25a63be5f626338cff4ae9a6ffebca965648322b323a259f0abd9e56df382e31"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-0546-088946a83680/harn-macos-x86_64"
      sha256 "a28e1b47962b6480e13dc9d69057e12c090e7b783be9c34659e292591d2a5ba9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-0546-088946a83680/harn-linux-aarch64"
      sha256 "a8efe2cae2bc19528de9bdc0841cbbe086f7fc1550b56926e1abc120a59dffa4"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-0546-088946a83680/harn-linux-x86_64"
      sha256 "49cd19c88e71dffd29e2325b8b40af2c39b16d744e458344b87fdf2bdd635236"
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
