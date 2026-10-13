class HarnPreview < Formula
  desc "Lists the harness an AI coding agent loads for a directory, reversibly"
  homepage "https://github.com/2lab-ai/harn"
  version "2026.10.13.1536"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-1536-88474d4dcfe0/harn-macos-aarch64"
      sha256 "ca5582dcb303ab17e258d53000f409676c657729ceb808965cf968b64c9f1776"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-1536-88474d4dcfe0/harn-macos-x86_64"
      sha256 "7e64c37464da073f5d0c4a1c850b3f6ef8371396987d9b3e673af40e93e684ea"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-1536-88474d4dcfe0/harn-linux-aarch64"
      sha256 "643680beefd7d8ac10f275a450af06b5cdcf1f59e8abbbbf25fe8a75fcdbd183"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-1536-88474d4dcfe0/harn-linux-x86_64"
      sha256 "f11662f5cdbbc9411f9078d86bdec64fd6e5076daab39ee257627699e35a6e85"
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
