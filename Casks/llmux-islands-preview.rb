cask "llmux-islands-preview" do
  version "2026.10.16.0709"
  sha256 "9cec6e70cc9d656a19c305e5ed1a7a97a6a171c90a57d6b45fbf15c2c1e6b6d8"

  url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-16-0709-a162822a9215/LlmuxIslands-#{version}.zip"
  name "llmux islands (preview)"
  desc "Preview build of the menu-bar app for viewing llmux account usage"
  homepage "https://github.com/2lab-ai/llmux"

  conflicts_with cask: "llmux-islands"
  # Installing the app also installs the preview llmux CLI it talks to.
  depends_on formula: "2lab-ai/tap/llmux-preview"
  depends_on :macos

  app "LlmuxIslands.app"

  postflight_steps do
    # Ad-hoc signed (no Developer ID notarization yet): drop the download
    # quarantine so Gatekeeper allows first launch.
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/LlmuxIslands.app"]
  end

  uninstall quit: "ai.2lab.LlmuxIslands"

  zap trash: [
    "~/Library/Application Support/ai.2lab.LlmuxIslands",
    "~/Library/Caches/ai.2lab.LlmuxIslands",
    "~/Library/Preferences/ai.2lab.LlmuxIslands.plist",
  ]
end
