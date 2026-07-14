class DbotterPreview < Formula
  desc "Local Rust database client for MySQL and Redis (preview channel)"
  homepage "https://github.com/2lab-ai/dbotter"
  version "2026.07.14.1149"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-14-1149-175779c8c8f8/dbotter-macos-aarch64"
      sha256 "55e2775522ca85f96a1c91f156e0875befb54288daede97c69fddbb77e0b9895"
    end
    on_intel do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-14-1149-175779c8c8f8/dbotter-macos-x86_64"
      sha256 "d94c751ed282e4627ca937be258389a9a4c9e3741a947578d7435eb7454791f5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-14-1149-175779c8c8f8/dbotter-linux-aarch64"
      sha256 "1a9536307b3696b3971f97c07351a3d606da29506b99cb883ce0b18db6c51c62"
    end
    on_intel do
      url "https://github.com/2lab-ai/dbotter/releases/download/preview-2026-07-14-1149-175779c8c8f8/dbotter-linux-x86_64"
      sha256 "e3ca36db376c3f39207211b3f6918d8f47170ececacfd0a75421ffc28b7b7aa9"
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
