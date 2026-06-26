class HerdrMxPreview < Formula
  desc "herdr-mx preview channel - latest mx-branch build (prerelease)"
  homepage "https://github.com/2lab-ai/herdr-mx"
  version "2026.06.26.0158"
  license "AGPL-3.0-or-later"

  conflicts_with "herdr", because: "both install a `herdr` binary"
  conflicts_with "herdr-mx", because: "both install a `herdr` binary"

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-26-0158-8a93d7e7a328/herdr-macos-aarch64"
      sha256 "4b02674bede6962a6ea3b0f94e518be94afb47858cab933bc102db381c3b91af"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-26-0158-8a93d7e7a328/herdr-macos-x86_64"
      sha256 "51969d6befcd5d81b1a8290807e2b6d8973a566931b1a9513a3c28af6c8cd1c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-26-0158-8a93d7e7a328/herdr-linux-aarch64"
      sha256 "f90f11250f1e86d1e2b5639bc71a7d1e6c35d596efdb8f387fcb8068838c52cc"
    end
    on_intel do
      url "https://github.com/2lab-ai/herdr-mx/releases/download/mx-preview-2026-06-26-0158-8a93d7e7a328/herdr-linux-x86_64"
      sha256 "863244dc433127af978fe26dc863d0aa2bc4839fdc8f2d3e30b6f3c5793d0c58"
    end
  end

  def install
    bin.install Dir["herdr-*"].first => "herdr"
  end

  test do
    assert_match "-mx.preview", shell_output("#{bin}/herdr --version")
  end
end
