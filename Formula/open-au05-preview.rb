class OpenAu05Preview < Formula
  desc "Open-source Linux driver, daemon, voice dictation, LED controller, and TUI for Ulanzi Vibe Key AU05"
  homepage "https://github.com/2lab-ai/open-au05"
  version "2026.11.23.0620"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/open-au05/releases/download/preview-2026-11-23-0620-5af10e6f8cc9/open-au05-macos-aarch64"
      sha256 "a51c88fcced09af092ece5867739b465ff0276f76a6cccc973faaff643783d85"
    end
    on_intel do
      url "https://github.com/2lab-ai/open-au05/releases/download/preview-2026-11-23-0620-5af10e6f8cc9/open-au05-macos-x86_64"
      sha256 "ef8c365d6c82bdf22b9385ce399d7e44b32b61f3b075204987ac05ea879f6c08"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/open-au05/releases/download/preview-2026-11-23-0620-5af10e6f8cc9/open-au05-linux-aarch64"
      sha256 "d372e97a2e803c9700be06202f5e1041dc49b4e248605ff65c3bc6834c827933"
    end
    on_intel do
      url "https://github.com/2lab-ai/open-au05/releases/download/preview-2026-11-23-0620-5af10e6f8cc9/open-au05-linux-x86_64"
      sha256 "00882930978be20dd673aa0c599fccc1f5bd2f9257bd2a3600a227b497732e41"
    end
  end

  link_overwrite "bin/open-au05"

  def install
    bin.install Dir["open-au05-*"].first => "open-au05"
  end

  def caveats
    <<~EOS
      On Linux, grant non-root access to the AU05 vendor HID interface & /dev/uinput:
        sudo #{opt_bin}/open-au05 setup udev --install
      Then unplug and replug the AU05 USB receiver and verify with:
        open-au05 doctor
    EOS
  end

  test do
    assert_match "preview", shell_output("#{bin}/open-au05 --version")
  end
end
