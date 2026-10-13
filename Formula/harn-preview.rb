class HarnPreview < Formula
  desc "Lists the harness an AI coding agent loads for a directory, reversibly"
  homepage "https://github.com/2lab-ai/harn"
  version "2026.10.13.0905"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-0905-54bc8d7f04e1/harn-macos-aarch64"
      sha256 "f300af29c8d53488cbf60375d4602fea223ce21c8842ad29959d46ca5e62f887"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-0905-54bc8d7f04e1/harn-macos-x86_64"
      sha256 "574bb26eba7fc010be4e9f51996aed3f49ace962187c21e58775c3871a375487"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-0905-54bc8d7f04e1/harn-linux-aarch64"
      sha256 "ff04136f7cc7ab9bc248c444fbafdfffa63f05a955f691b8f8faf19c96e6845d"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-0905-54bc8d7f04e1/harn-linux-x86_64"
      sha256 "ae8f63509cde88274f45e89e4ae64f8098173c96d802943351669fc04fc413f8"
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
