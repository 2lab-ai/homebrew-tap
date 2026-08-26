class SomaworkCli < Formula
  desc "Controller CLI that sets up and supervises somawork runtime kegs"
  homepage "https://github.com/2lab-ai/soma-work"

  # Immutable release identity, verified before this file was written:
  # tag: somawork-preview-v1.0.0-32939873713
  # source: 8da20f3092da1748954f3e617e28103932d81a1e
  # channel: preview
  # package-version: 1.0.0
  # platform: darwin-arm64
  # layout-version: 1
  # minimum-node: 20.0.0
  # manifest: https://github.com/2lab-ai/soma-work/releases/download/somawork-preview-v1.0.0-32939873713/somawork-manifest.json
  # manifest-sha256: 873ff16cddddc1d8e976ee0457a658647bc92cf1e955921552c3759cd119d079

  url "https://github.com/2lab-ai/soma-work/releases/download/somawork-preview-v1.0.0-32939873713/somawork-cli-1.0.0-darwin-arm64.tar.gz"
  version "1.0.0.32939873713"
  sha256 "78716a80de6c415929e170412d54184178592a57886c7ff216e43133138cbe16"

  # Fixed project metadata, not a manifest field: soma-work's LICENSE and its
  # package.json both say ISC, and no release payload gets to name this.
  license "ISC"

  # Homebrew's `node` is the only Node this formula will run under, and it is
  # always at or above the manifest's floor recorded above; the renderer refuses
  # a manifest that raises the floor past what this tap has checked.
  depends_on "2lab-ai/tap/llmux"
  depends_on arch: :arm64
  depends_on :macos
  depends_on "node"

  def install
    # The archive is a flat tree whose root IS the install prefix. That is not
    # cosmetic: the controller resolves its own package.json two directories
    # above its entry, so `libexec/bin/somawork` has to keep that exact
    # relationship to the manifest at the keg root. Dotfiles are installed too —
    # the release marker is one.
    prefix.install Dir["*"] + Dir[".[^.]*"]
    bin.install_symlink prefix/"libexec/bin/somawork" => "somawork"
  end

  def caveats
    <<~EOS
      somawork needs a runtime keg beside this controller. Install the profile
      you want, then run its setup:

        brew install 2lab-ai/tap/somawork-preview
        somawork setup --profile preview

        brew install 2lab-ai/tap/somawork
        somawork setup --profile production
    EOS
  end

  test do
    assert_predicate prefix/"libexec/bin/somawork", :executable?
    assert_predicate prefix/"package.json", :file?
    assert_match "1.0.0", shell_output("#{bin}/somawork --version")
  end
end
