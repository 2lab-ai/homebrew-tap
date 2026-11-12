class ReviewOfLegends < Formula
  desc "Self-hosted multi-agent GitHub pull request reviews"
  homepage "https://github.com/2lab-ai/review-of-legends"
  url "https://github.com/2lab-ai/review-of-legends/releases/download/v1.2.1/review-of-legends-1.2.1.tar.gz"
  sha256 "2faeb253cf17e99ec0f008a8ec8ea9fd05156c746c20132b2c9c2adb63f250b4"
  license "MIT"

  conflicts_with "review-of-legends-preview", because: "both install the rol command"


  depends_on "python@3.13"
  depends_on "gh"
  depends_on "git"
  depends_on "openssl@3"

  def install
    libexec.install "code_review_service", "config", "agents", "VERSION", "THIRD_PARTY_NOTICES.md"
    (bin/"rol").write <<~SH
      #!/bin/sh
      export ROL_ASSETS="#{opt_libexec}"
      export ROL_HOMEBREW=1
      export ROL_HOMEBREW_FORMULA="review-of-legends"
      export ROL_PYTHON="#{Formula["python@3.13"].opt_bin}/python3.13"
      export PYTHONPATH="#{opt_libexec}"
      export PATH="#{Formula["gh"].opt_bin}:#{Formula["git"].opt_bin}:#{Formula["openssl@3"].opt_bin}:#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" -P -m code_review_service.cli "$@"
    SH
  end

  service do
    run [opt_bin/"rol", "daemon"]
    keep_alive true
    log_path var/"log/review-of-legends.log"
    error_log_path var/"log/review-of-legends.error.log"
  end

  def caveats
    "Run rol setup as your user before starting the service. Never use sudo rol setup."
  end

  test do
    assert_match "Review of Legends", shell_output("#{bin}/rol --help")
    assert_match "v1.2.1", shell_output("#{bin}/rol version")
  end
end
