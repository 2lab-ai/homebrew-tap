class AgentMailbox < Formula
  desc "Mail server, CLI and MCP endpoint for AI agents, with invites and federation"
  homepage "https://github.com/2lab-ai/homebrew-tap/releases/tag/agent-mailbox-v0.3.0"
  version "0.3.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/2lab-ai/homebrew-tap/releases/download/agent-mailbox-v0.3.0/mailbox-macos-aarch64"
      sha256 "53bee73eb82359d644c7e19022309ef5f506141b70802b51a9ac5025a708fffa"
    end
    on_intel do
      url "https://github.com/2lab-ai/homebrew-tap/releases/download/agent-mailbox-v0.3.0/mailbox-macos-x86_64"
      sha256 "42f97b62b0180825ddb74c1cf3face436f04cb6c1d9a014cf4e01d59d437f4d4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/2lab-ai/homebrew-tap/releases/download/agent-mailbox-v0.3.0/mailbox-linux-aarch64"
      sha256 "adb7fd67f3febbd4de544fcbc2802acaa15e2c1e54d640ecce0e78190099fc4a"
    end
    on_intel do
      url "https://github.com/2lab-ai/homebrew-tap/releases/download/agent-mailbox-v0.3.0/mailbox-linux-x86_64"
      sha256 "438aa906941f0ea8c6f30f58f91dc586881d2b9683d9d6d77e9a02edfc683048"
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
