class SomaworkPreview < Formula
  desc "Preview-profile runtime tree resolved by the somawork controller"
  homepage "https://github.com/2lab-ai/soma-work"

  # Immutable release identity, verified before this file was written:
  # tag: somawork-preview-v1.0.0-32939873713
  # source: 8da20f3092da1748954f3e617e28103932d81a1e
  # channel: preview
  # package-version: 1.0.0
  # platform: darwin-arm64
  # layout-version: 1
  # manifest: https://github.com/2lab-ai/soma-work/releases/download/somawork-preview-v1.0.0-32939873713/somawork-manifest.json
  # manifest-sha256: 873ff16cddddc1d8e976ee0457a658647bc92cf1e955921552c3759cd119d079

  url "https://github.com/2lab-ai/soma-work/releases/download/somawork-preview-v1.0.0-32939873713/somawork-preview-1.0.0-darwin-arm64.tar.gz"
  version "1.0.0.32939873713"
  sha256 "203087cc2ddc4138764e735c2a549a3fdf5f4231a58a75bf18c92ad2e6046c55"

  # Fixed project metadata, not a manifest field: soma-work's LICENSE and its
  # package.json both say ISC, and no release payload gets to name this.
  license "ISC"

  # Never linked, for two reasons that both matter: the controller finds this
  # tree by asking `brew --prefix somawork-preview` and reading directly beneath
  # it, and the production runtime is a second keg that must be able to sit
  # beside this one without either of them owning a shared name.
  keg_only "it is a runtime tree the somawork controller resolves through `brew --prefix`, not a linkable toolchain"

  # The controller owns the only executable on PATH. This keg carries a runtime
  # tree and nothing else.
  depends_on "2lab-ai/tap/somawork-cli"
  depends_on arch: :arm64
  depends_on :macos

  def install
    # Flat at the keg prefix: `brew --prefix somawork-preview` is the runtime
    # root the controller canonicalizes and reads `dist/index.js` from, so
    # nothing may be nested below it. Dotfiles are installed too — the profile
    # marker is one.
    prefix.install Dir["*"] + Dir[".[^.]*"]
  end

  def caveats
    <<~EOS
      Point the controller at this runtime:

        somawork setup --profile preview
    EOS
  end

  test do
    assert_predicate prefix/".somawork-package.json", :file?
    assert_predicate prefix/"package.json", :file?
    assert_predicate prefix/"dist/cli/index.js", :file?
    assert_predicate prefix/"dist/run-with-rotating-logs.js", :file?
    assert_predicate prefix/"dist/index.js", :file?
    marker = JSON.parse((prefix/".somawork-package.json").read)
    assert_equal "preview", marker["profile"]
    assert_equal "1.0.0", marker["version"]
  end
end
