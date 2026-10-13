class HarnPreview < Formula
  desc "Lists the harness an AI coding agent loads for a directory, reversibly"
  homepage "https://github.com/2lab-ai/harn"
  version "2026.10.13.1426"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-1426-e05077fd3773/harn-macos-aarch64"
      sha256 "14258eb584946b727e03ed2efb0c8f6b902dcb5437572bc44e7e7b3478a84053"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-1426-e05077fd3773/harn-macos-x86_64"
      sha256 "9e18ec334687f2fc3b20d1af9587294b67702d2fd4fe8897d9634a724e3a16a0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-1426-e05077fd3773/harn-linux-aarch64"
      sha256 "0ca722bcbe0455d144a678fc6987ef97e7245fe7a59a35986a0a68a09f163d18"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-13-1426-e05077fd3773/harn-linux-x86_64"
      sha256 "c6c90dd9423e3c515b758fe7a5c202c10ea37f0c667211aa99c2f203857333ad"
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
