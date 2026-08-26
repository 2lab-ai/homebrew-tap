class SlackCli < Formula
  desc "Official command-line interface for building and running Slack apps"
  homepage "https://github.com/slackapi/slack-cli"

  # The dependency target of somawork-cli. soma-work's setup code
  # (src/cli/setup/slack-auth.ts) says packaging owns this binary: setup reports
  # a missing `slack` as a precondition the packager failed to meet, so the
  # clean journey has to be one package install plus `somawork setup`. Homebrew
  # formulae cannot depend on casks, which is why the official CLI is packaged
  # here as a formula instead of pointing at Slack's own cask.
  #
  # Pinned, immutable, and cross-checked: this is the v4.6.0 release asset, and
  # the digest below is the one GitHub reports for that asset and the one
  # Homebrew's official Slack CLI cask publishes for the same file.
  url "https://github.com/slackapi/slack-cli/releases/download/v4.6.0/slack_cli_4.6.0_macOS_arm64.tar.gz"
  version "4.6.0"
  sha256 "c1586ad5625a31d802abb31aa4b023bd12fe3c794221aaf17f6814aaa321a792"

  license "Apache-2.0"

  # Only one archive is pinned, and it carries a thin arm64 Mach-O. Anything
  # else must fail to install rather than install something that cannot run.
  depends_on arch: :arm64
  depends_on :macos

  # Apache-2.0 4(a) asks that a copy of the License travel with the object form
  # being redistributed, and the release archive does not carry one: `tar -tzf`
  # on the pinned asset lists exactly `./`, `./bin/` and `./bin/slack` — no
  # LICENSE, NOTICE or COPYING member. Upstream keeps the License in the repo,
  # so it is taken from the same immutable tag as the binary and pinned by
  # digest — a moving `main` would make the legal artifact unverifiable. The
  # v4.6.0 tree has a LICENSE and no NOTICE, so there is no notice file to
  # carry alongside it.
  resource "license" do
    url "https://raw.githubusercontent.com/slackapi/slack-cli/v4.6.0/LICENSE", using: :nounzip
    sha256 "a65d087cf010a52f8736da6b387df1feb7089e2c0636ef21cb86bef05940e0a4"
  end

  def install
    # `slack`, not `bin/slack`. The archive's only top-level member is `bin/`,
    # and Homebrew's staging normalizes that away: when the unpacked tree has
    # exactly one entry and it is a directory, the download strategy chdirs into
    # it before `install` runs (Library/Homebrew/download_strategy/
    # abstract_download_strategy.rb, `chdir`). So the raw tar layout is
    # `./bin/slack` while the build directory this method runs in *is* that
    # `bin/`, holding `slack` alone. Writing the tar path here is an
    # `Errno::ENOENT: bin/slack` at install time, which is exactly how this was
    # found — and it is only safe to hardcode the normalized path because the
    # archive is pinned by digest, so its layout cannot move without a formula
    # edit that has to come back through this comment.
    bin.install "slack"

    resource("license").stage do
      prefix.install "LICENSE"
    end
  end

  def caveats
    <<~EOS
      This is the official Slack CLI, packaged here because somawork-cli depends
      on it. Run `slack login` yourself only if you are not using somawork —
      `somawork setup` drives the login it needs.
    EOS
  end

  test do
    # `slack` is a name several unrelated tools answer to, so running the binary
    # is not by itself evidence that the public Slack CLI got installed.
    # `_fingerprint` is the CLI's own identity command and answers the same
    # constant everywhere; the version line pins what this formula claims.
    assert_equal "d41d8cd98f00b204e9800998ecf8427e",
                 shell_output("#{bin}/slack _fingerprint").strip
    assert_equal "Using slack v#{version}",
                 shell_output("#{bin}/slack version --no-color --skip-update").strip

    # The redistribution obligation, checked rather than asserted in a comment.
    assert_match "Apache License", (prefix/"LICENSE").read
  end
end
