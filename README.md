# 2lab-ai homebrew tap

```bash
brew install 2lab-ai/tap/dbotter-preview
```

| formula | what it is |
|---|---|
| `dbotter-preview` | Preview channel of [dbotter](https://github.com/2lab-ai/dbotter), a local Rust database client for MySQL and Redis. Tracks the latest `preview-*` prerelease and installs as `dbotter`. |
| `dbotter` | Stable dbotter channel — appears automatically when the first `v*` stable release is cut. |
| `herdr-mx-preview` | **herdr, multiplexed further** — preview channel of [herdr-mx](https://github.com/2lab-ai/herdr-mx), the friendly downstream distribution of [herdr](https://github.com/ogulcancelik/herdr) with a full multi-remote client. Tracks the latest `mx`-branch prerelease; installs as `herdr` (drop-in; conflicts with the core `herdr` formula). |
| `herdr-mx` | Stable channel — appears automatically when the first stable release is cut. |

Formulae are prebuilt-binary installs from GitHub releases and are bumped automatically by [`bump.yml`](.github/workflows/bump.yml) within a few hours of each release (or run it manually from the Actions tab).
