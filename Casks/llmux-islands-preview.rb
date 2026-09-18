cask "llmux-islands-preview" do
  version "2026.09.18.0311"
  sha256 "958b4347150a0145717a5f36f31f9b320808979b9367105397e3d90a9c411178"

  url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-18-0311-7ef84b1c5d56/LlmuxIslands-#{version}.zip"
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
