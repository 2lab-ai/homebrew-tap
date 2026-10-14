class HarnPreview < Formula
  desc "Lists the harness an AI coding agent loads for a directory, reversibly"
  homepage "https://github.com/2lab-ai/harn"
  version "2026.10.14.1636"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-1636-0d4b0a637e6e/harn-macos-aarch64"
      sha256 "277ccf19e97a665d980368056e286ca46663dcf6f218effe6d7f4cea1684070c"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-1636-0d4b0a637e6e/harn-macos-x86_64"
      sha256 "de65c440e2ff9bd585b8cfc29cebc3c7dad18bf16caff8593fce2c609434187e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-1636-0d4b0a637e6e/harn-linux-aarch64"
      sha256 "9df2f7488d6ed8ae09774680f946d09157fe64cf26e5c347a15f2d294c262412"
    end
    on_intel do
      url "https://github.com/2lab-ai/harn/releases/download/preview-2026-10-14-1636-0d4b0a637e6e/harn-linux-x86_64"
      sha256 "9a7f858a8179036dbce57561dc98fe8f2f22a52845f4fc3d78e85dac0bf6e785"
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
