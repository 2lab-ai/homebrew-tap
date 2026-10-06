cask "llmux-islands-preview" do
  version "2026.10.06.0513"
  sha256 "0982e493cf638174490ec6eb8400b8065c61d4b6e0dff7249f334d1aeb9e87d0"

  url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-10-06-0513-4b3d4a4a0be8/LlmuxIslands-#{version}.zip"
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
