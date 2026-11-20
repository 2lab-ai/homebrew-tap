class AgentMailbox < Formula
  desc "Mail server, CLI and MCP endpoint for AI agents, with invites and federation"
  homepage "https://github.com/2lab-ai/homebrew-tap/releases/tag/agent-mailbox-v0.3.0"
  version "0.3.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/homebrew-tap/releases/download/agent-mailbox-v0.3.0/mailbox-macos-aarch64"
      sha256 "6f640e1e94b387e962d80fc624a7e9ee3f0ca7057c42583d1eaf4e5630ef5a68"
    end
    on_intel do
      url "https://github.com/2lab-ai/homebrew-tap/releases/download/agent-mailbox-v0.3.0/mailbox-macos-x86_64"
      sha256 "7680d35f10240cf921505f726111afae8d5f3065dbf7f132c49fe1c3d8c8fb70"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/homebrew-tap/releases/download/agent-mailbox-v0.3.0/mailbox-linux-aarch64"
      sha256 "917d30e6682f2d7b4ce842615e1171f7b67a7e43330b5cec51e8c15d3ebff756"
    end
    on_intel do
      url "https://github.com/2lab-ai/homebrew-tap/releases/download/agent-mailbox-v0.3.0/mailbox-linux-x86_64"
      sha256 "6fb76a36ce554d3ae6ad33aab649fbf3dcc7a5e7084c7c07ee7d60d580fd9e23"
    end
  end

  # A host that also runs the autodeploy install links its own build at bin/mailbox.
  link_overwrite "bin/mailbox"

  def install
    bin.install Dir["mailbox-*"].first => "mailbox"
  end

  service do
    run [opt_bin/"mailbox", "server", "--config", "#{Dir.home}/.config/agent-mailbox/server.json"]
    keep_alive true
    log_path var/"log/agent-mailbox.log"
    error_log_path var/"log/agent-mailbox.log"
  end

  def caveats
    <<~EOS
      Join a mailbox server with an invite key from its admin:
        mailbox register https://<server> --invite mbxi_... --as <agent>:<host>:<instance>
      Agents can read https://<server>/setup.md instead.

      To run a server here, write ~/.config/agent-mailbox/server.json
      (mailbox init-config --server <name>) and: brew services start agent-mailbox
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mailbox version")
    assert_match "agent mailbox client", shell_output("#{bin}/mailbox help")
  end
end
