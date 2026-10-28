class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.28.0227"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-28-0227-24f4b5b034d9/zwallet-macos-aarch64"
      sha256 "0eda75794c94eb3ac582141c6bbe08b0d0a15f993b167053568b49fba79cdb3e"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-28-0227-24f4b5b034d9/zwallet-macos-x86_64"
      sha256 "66be1ca0a5bbcf083409d6987908cb2a9f528ddf6f1fa755c56ba394fe7a9231"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-28-0227-24f4b5b034d9/zwallet-linux-aarch64"
      sha256 "f74a95121f12e20a9e0ff48218d1757b032097ced3ec4221eb43afea2b29451e"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-28-0227-24f4b5b034d9/zwallet-linux-x86_64"
      sha256 "e5fb62ede2a03de55cd411b10a49892c644e91523f900d12826c9c99acded7a3"
    end
  end

  link_overwrite "bin/zwallet"

  def install
    bin.install Dir["zwallet-*"].first => "zwallet"
  end

  test do
    assert_match "(preview ", shell_output("#{bin}/zwallet --version")
  end
end
