class HarnPreview < Formula
  desc "Lists the harness an AI coding agent loads for a directory, reversibly"
  homepage "https://github.com/2lab-ai/harn"
  version "2026.10.13.0840"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-0840-3f6844340e4a/harn-macos-aarch64"
      sha256 "1bf02a368f2aa1241f4fbfa6d66beffe1bc38db72eded7ff593e362065d4bcdf"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-0840-3f6844340e4a/harn-macos-x86_64"
      sha256 "654a7c05d6affdb1f6446c68f3db1a34a5a62e4223d4cce42d9c0194362bf582"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-0840-3f6844340e4a/harn-linux-aarch64"
      sha256 "4595c17ed7ece4d524d93005395f5c0edad00a8dc537c20dcabd45deea7c8d1a"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-0840-3f6844340e4a/harn-linux-x86_64"
      sha256 "d80aa6f636706b4d4221ddbd4f99df125eb9a627a7d4c1c8a20217caf8bc2d5d"
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
