class ZwalletPreview < Formula
  desc "Local wallet CLI for AI agents: create, balance, contract calls, transfers"
  homepage "https://github.com/2lab-ai/zwallet"
  version "2026.10.20.1315"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-20-1315-814c4aed0978/zwallet-macos-aarch64"
      sha256 "394a9c8c22f1ca8e061f070f07024d396840b28d433e2042e09f3d0eb0f40f8c"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-20-1315-814c4aed0978/zwallet-macos-x86_64"
      sha256 "b69c80eeb00158878ca13f5804995d4e2310044e1349bcded17341666aee5f6b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-20-1315-814c4aed0978/zwallet-linux-aarch64"
      sha256 "cb5ab6c8e3f7227f796953cd7b00a33eef1ab83d7f94a28fa645064996dd7971"
    end
    on_intel do
      url "https://github.com/2lab-ai/zwallet/releases/download/preview-2026-10-20-1315-814c4aed0978/zwallet-linux-x86_64"
      sha256 "0007cc33b489bfb61817f02f0712a9c45d2b45f807c89a74e70bc260071f9a5d"
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
