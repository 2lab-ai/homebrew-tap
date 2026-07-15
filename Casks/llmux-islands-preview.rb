cask "llmux-islands-preview" do
  version "2026.07.15.0222"
  sha256 "025f0852e8dc3e8d1d733ea383fd613251d9cc736c78ce5c8e25860e10bb01c9"

  url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-07-15-0222-56af2123a536/LlmuxIslands-#{version}.zip"
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
