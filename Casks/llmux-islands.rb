cask "llmux-islands" do
  version "0.2.15"
  sha256 "e5cb58c6926d64d6c08d8a580716eeb1aa3c0626fa6225e5bf50bf7df617421c"

  url "https://github.com/2lab-ai/llmux/releases/download/v#{version}/LlmuxIslands-#{version}.zip"
  name "llmux islands"
  desc "Menu-bar app for viewing llmux account usage and managing subscriptions"
  homepage "https://github.com/2lab-ai/llmux"

  # Installing the app also installs the llmux CLI it talks to.
  depends_on formula: "2lab-ai/tap/llmux"

  app "LlmuxIslands.app"

  postflight do
    # Ad-hoc signed (no Developer ID notarization yet): drop the download
    # quarantine so Gatekeeper allows first launch.
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/LlmuxIslands.app"]
  end

  uninstall quit: "ai.2lab.LlmuxIslands"

  zap trash: [
    "~/Library/Application Support/ai.2lab.LlmuxIslands",
    "~/Library/Caches/ai.2lab.LlmuxIslands",
    "~/Library/Preferences/ai.2lab.LlmuxIslands.plist",
  ]
end
