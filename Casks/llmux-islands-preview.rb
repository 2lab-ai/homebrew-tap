cask "llmux-islands-preview" do
  version "2026.09.01.2349"
  sha256 "c04591c84e368c251d09daa06057486eb136b2816aefb8e4d552ec1a3047a7c8"

  url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-09-01-2349-2a0319af3b59/LlmuxIslands-#{version}.zip"
  name "llmux islands (preview)"
  desc "Preview build of the menu-bar app for viewing llmux account usage"
  homepage "https://github.com/2lab-ai/llmux"

  # Installing the app also installs the preview llmux CLI it talks to.
  depends_on formula: "2lab-ai/tap/llmux-preview"
  conflicts_with cask: "llmux-islands"

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
