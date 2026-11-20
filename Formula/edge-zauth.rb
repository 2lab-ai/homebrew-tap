class EdgeZauth < Formula
  desc "TOTP authenticator browser extension (zauthenticator) for Microsoft Edge"
  homepage "https://github.com/2lab-ai/zauthenticator"
  url "https://github.com/2lab-ai/zauthenticator/archive/98e080f04e9c8eddbd399447f268bfd93b29669f.tar.gz"
  version "0.3.0"
  sha256 "95ce52c088c164753fc603b64095dbecb851950e4bc1ef845661e4c8c0892a5b"
  license "MIT"

  # Delivers files only: Edge offers no way to register an off-store
  # extension for one user, so the owner loads the folder unpacked once.
  # Edge derives an unpacked extension's ID from the real path of the folder
  # it loaded, and that ID is the vault's storage key and the passkey's RP ID.
  # The Cellar and opt/ paths change with every version, so post_install keeps
  # a copy at one fixed, real directory under var/ instead.

  def zauth_version_name
    commit = stable.url[%r{/archive/(\h{40})\.tar\.gz\z}, 1]
    odie "url must pin a 40-character commit archive" if commit.nil?
    "#{version} (#{commit[0, 7]})"
  end

  def install
    pkgshare.install "extension"

    manifest = pkgshare/"extension/manifest.json"
    data = JSON.parse(manifest.read)
    data["version_name"] = zauth_version_name
    manifest.atomic_write("#{JSON.pretty_generate(data)}\n")
  end

  # Replaces var/edge-zauth/extension wholesale while keeping its path: stage a
  # fresh copy beside it, move the active one aside, move the copy into place,
  # then delete the old one. extension.old is only deleted while an active copy
  # exists; a run interrupted mid-swap is repaired by putting it back first.
  post_install_steps do
    unless_path_exists "edge-zauth/extension", base: :var do
      if_path_exists "edge-zauth/extension.old", base: :var do
        move "edge-zauth/extension.old", "edge-zauth/extension", source_base: :var, target_base: :var
      end
    end
    remove "edge-zauth/extension.new", base: :var, recursive: true
    copy "extension", "edge-zauth/extension.new", source_base: :pkgshare, target_base: :var, recursive: true
    if_path_exists "edge-zauth/extension", base: :var do
      remove "edge-zauth/extension.old", base: :var, recursive: true
      move "edge-zauth/extension", "edge-zauth/extension.old", source_base: :var, target_base: :var
    end
    move "edge-zauth/extension.new", "edge-zauth/extension", source_base: :var, target_base: :var
    remove "edge-zauth/extension.old", base: :var, recursive: true
  end

  def caveats
    <<~EOS
      The extension is at:
        #{var}/edge-zauth/extension

      Load it once: open edge://extensions, turn on Developer mode, click
      "Load unpacked" and choose that folder.

      After `brew upgrade`, click Reload on the extension's card or restart Edge.
      If `brew upgrade` stops with an error, run `brew postinstall edge-zauth`
      before reloading: it puts the last working copy back.

      This copy has its own extension ID and starts with an empty vault. Export
      an encrypted backup from any other zauthenticator copy first, then import
      it here.

      `brew uninstall` leaves that folder in place. To remove it:
        rm -rf #{var}/edge-zauth
    EOS
  end

  test do
    installed = pkgshare/"extension/manifest.json"
    assert_equal zauth_version_name, JSON.parse(installed.read)["version_name"]
    assert_path_exists pkgshare/"extension/background.js"
    assert_path_exists pkgshare/"extension/popup/popup.html"

    # The folder the browser loads must match this keg once post-install ran.
    active = var/"edge-zauth/extension/manifest.json"
    assert_equal installed.binread, active.binread if active.exist?
  end
end
