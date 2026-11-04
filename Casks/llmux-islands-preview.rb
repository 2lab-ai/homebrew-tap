cask "llmux-islands-preview" do
  version "2026.11.04.0759"
  sha256 "c05be92e6ac0bbac9206aed37cc80350003035d44c6e439da6b8159cc6034e58"

  url "https://github.com/2lab-ai/llmux/releases/download/preview-2026-11-04-0759-051abe182b90/LlmuxIslands-#{version}.zip"
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
