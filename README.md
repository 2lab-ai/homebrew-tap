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
| `pdc` | Stable channel of [Palladium](https://github.com/labforadvancedstudy/palladium-a), a self-hosting systems language that compiles to C. Builds from the tagged source. Installs `pdc` plus the C runtime it links against, in `share/palladium/runtime`. |
| `pdc-preview` | Preview channel of Palladium, tracking `main`. Installs as `pdc-preview`, so it coexists with a stable `pdc`. |
| `xfx-preview` | Preview channel of [xfx](https://github.com/2lab-ai/xfx), a Rust port of the `fx` agentic coding CLI. Tracks the latest `preview-*` prerelease; the formula is `xfx-preview` but the installed executable is `xfx`. |
| `xfx` | Stable xfx channel — appears automatically when the first `v*` stable release is cut. Installs the same `xfx` executable, whose `xfx status --json` reports `"build_channel": "release"`. |
| `somawork-cli` | Controller for [soma-work](https://github.com/2lab-ai/soma-work), the agent harness. Installs the `somawork` executable and is the only formula of the three that links one. It does nothing on its own: it resolves a runtime keg through `brew --prefix`, so install it together with a channel below and then run `somawork setup`. |
| `somawork-preview` | Preview-channel runtime tree for somawork. `keg_only` — the controller resolves it by prefix rather than linking it — so it coexists with the production channel. Activate with `somawork setup --profile preview`. |
| `somawork` | Production-channel runtime tree for somawork, on the same `keg_only` terms. Activate with `somawork setup --profile production`. Preview and production releases are published separately and neither channel can write the other's formula. |
| `slack-cli` | The official [Slack CLI](https://github.com/slackapi/slack-cli), pinned to one immutable upstream release for macOS Apple Silicon and installed as `slack`. It is here because `somawork setup` logs a workspace in through it and a Homebrew formula cannot depend on a cask; installing `somawork-cli` pulls it in, so the clean journey stays one package install plus `somawork setup`. |

```bash
brew install 2lab-ai/tap/xfx-preview
xfx status --json   # "build_channel": "preview"
```

The formula name is `xfx-preview`; the executable it puts on your `PATH` is `xfx`. The qualified
form above always works. Once this tap is added — by that install or by `brew tap 2lab-ai/tap` —
the short `brew install xfx-preview` resolves to the same formula. `xfx --version` prints the same
Cargo version on every channel, so `xfx status --json` is what actually proves you are on preview.

Most formulae are prebuilt installs from GitHub releases; `pdc` and `pdc-preview` build from
source, because the Palladium compiler needs a C runtime installed alongside it and building
from the tagged tree is the simplest way to keep the two in step. Dbotter preview updates are dispatched by the matching immutable source release and fail closed unless its tag, source commit, version, manifest URL, and manifest digest all agree. `xfx-preview` is pushed here by the xfx preview
workflow itself, with the scheduled job as a backstop that never downgrades the formula. Other
formulae remain on the scheduled [`bump.yml`](.github/workflows/bump.yml) update.
