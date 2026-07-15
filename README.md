# 2lab-ai homebrew tap

```bash
brew install 2lab-ai/tap/dbotter-preview
open "$(brew --prefix dbotter-preview)/Dbotter Preview.app"
```

| formula | what it is |
|---|---|
| `dbotter-preview` | Preview channel of [dbotter](https://github.com/2lab-ai/dbotter), a local Rust database client for MySQL and Redis. Installs the exact manifest-pinned macOS app and exposes its embedded CLI as `dbotter`. |
| `dbotter` | Stable dbotter channel — appears automatically when the first `v*` stable release is cut. |
| `herdr-mx-preview` | **herdr, multiplexed further** — preview channel of [herdr-mx](https://github.com/2lab-ai/herdr-mx), the friendly downstream distribution of [herdr](https://github.com/ogulcancelik/herdr) with a full multi-remote client. Tracks the latest `mx`-branch prerelease; installs as `herdr` (drop-in; conflicts with the core `herdr` formula). |
| `herdr-mx` | Stable channel — appears automatically when the first stable release is cut. |

Formulae are prebuilt installs from GitHub releases. Dbotter preview updates are dispatched by the matching immutable source release and fail closed unless its tag, source commit, version, manifest URL, and manifest digest all agree. Other formulae remain on the scheduled [`bump.yml`](.github/workflows/bump.yml) update.
