class HarnPreview < Formula
  desc "Lists the harness an AI coding agent loads for a directory, reversibly"
  homepage "https://github.com/2lab-ai/harn"
  version "2026.10.14.0440"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-0440-781975cf56b7/harn-macos-aarch64"
      sha256 "f1cb1ec912d806817097a89c89ec847f76e8ff90ee9630392e1b1d6a54ef37f2"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-0440-781975cf56b7/harn-macos-x86_64"
      sha256 "b589683ce5dccb9ab7d0e421067457c4f8abce8b9e548456aea34390eda813df"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-0440-781975cf56b7/harn-linux-aarch64"
      sha256 "f3ff71a060661a356473acf230534a7b67d1df31418a9a271e83306cc88e30d7"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-0440-781975cf56b7/harn-linux-x86_64"
      sha256 "36078567eca8ac884aa124348f2a7afc4c5b3e48e8aecb14da2f966d95a2d361"
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
