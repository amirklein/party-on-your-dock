# Agent instructions — party-on-your-dock

You are operating **party-on-your-dock**: a local macOS toolkit that restyles app icons from a theme prompt (e.g. "Nintendo 64", "retro", "vaporwave") and applies them via **safe custom icons only**.

When the user says anything like **"change my theme to X"**, **"party theme: X"**, or **"restyle my dock as X"**, follow this workflow. Prefer **Dock apps only** unless they ask for more.

---

## Hard rules (never break these)

1. **Never modify app bundles.** Do **not** replace `Contents/Resources/*.icns`, edit `Info.plist`, touch `Assets.car`, ad-hoc resign, or rewrite anything inside `.app`. That breaks code signing / Gatekeeper (“damaged and can’t be opened”).
2. **Safe apply only:** `fileicon set` / `NSWorkspace.setIcon` on the `.app` wrapper (custom icon). If that fails or Dock won’t show it, **skip** — do not escalate to bundle edits.
3. **Icon art = logo only.** Restyles must be the **symbol/logo itself** restyled in the theme. **No** full-bleed square backgrounds, no fake macOS squircle chrome, no Smash-Ball poster frames, no explosion backdrops behind a plate. Transparent canvas; just the mark.
4. **Revert must be easy and complete.** `./scripts/poyd revert` clears custom icons so the stock bundle icon returns. Never leave apps in a half-patched state.
5. **Don’t fight the OS.** Skip SIP/system apps and apps you can’t write (e.g. root-owned Slack/Chrome). Say so and continue.

If the user asks for something that requires breaking rule 1, **refuse** and explain that Dock-visible theming for running apps isn’t worth breaking Gatekeeper.

---

## Workflow

### 1. Normalize the theme slug
- Lowercase, hyphens, ASCII: `Nintendo 64` → `n64`.
- Or let the CLI do it:
```bash
./scripts/poyd init-theme "Nintendo 64"
./scripts/poyd themes
```
- Theme directory: `themes/<slug>/`.

### 2. Ensure PNG originals exist
```bash
./scripts/poyd extract
```
`originals/` is local and gitignored (used as art reference only — not written back into bundles).

### 3. Scope = Dock by default
```bash
./scripts/poyd dock
./scripts/poyd apply <slug> --dock
```
Or list everything in `/Applications`:
```bash
./scripts/poyd list
```

### 4. AI-restyle each icon
For each target app:
1. Read `originals/<AppName>.png`.
2. Generate a restyled **logo-only** PNG:
   - Preserve recognizability of the core mark.
   - **Transparent background** — no square tile, no fake app-icon bezel.
   - Square pixel canvas (e.g. 1024×1024) with the logo centered; empty pixels transparent.
   - No watermark, no tiny text.
   - Prompt pattern: *Restyle this app logo in the style of \<theme\>. Output only the symbol on a transparent background — no square background, no poster, no extra chrome. Keep it identifiable.*
3. Save as `themes/<slug>/<AppName>.png`.

### 4b. Validate theme filenames (before apply)
```bash
./scripts/poyd missing <slug> --dock
./scripts/validate-theme.sh <slug>
```
Fix any `unknown` PNG names or missing Dock apps before applying.

### 5. Apply (safe path only)
Preview first:
```bash
./scripts/poyd apply <slug> --dock --dry-run
```

Needs `fileicon` (`brew install fileicon`) and **App Management** permission for the agent app.
```bash
./scripts/poyd apply <slug>
./scripts/poyd apply <slug> --only Spotify Notion
```

If icons don’t show in the Dock while apps are running: tell the user custom icons often need the app quit + Dock refresh; **do not** patch `.icns` inside the bundle.

### 6. Confirm
- Theme slug, applied count, skips/failures.
- Remind: `./scripts/poyd revert` restores stock icons.

## Revert
```bash
./scripts/poyd revert
./scripts/poyd revert --only Spotify
```
This **removes** custom icons (stock icons return). It must not leave substitute “original PNGs” glued on if a full clear is requested — clearing custom icons is the goal.

## Commands
| Command | Purpose |
|--------|---------|
| `./scripts/poyd list` | List `/Applications` names |
| `./scripts/poyd dock` | List pinned Dock apps (paths) |
| `./scripts/poyd extract` | Backup icon renders → `originals/` |
| `./scripts/poyd apply <theme>` | Safe custom-icon apply (`--dock` optional) |
| `./scripts/poyd apply-one AppName path.png` | Apply one |
| `./scripts/poyd revert` | Remove custom icons |
| `./scripts/poyd verify` | Flag apps with broken code signatures |
| `./scripts/poyd status` | Show `custom` vs `stock` icon state |
| `./scripts/poyd doctor` | Check Swift, fileicon, and CLI setup |
| `./scripts/poyd version` | Print CLI version |
| `./scripts/poyd missing <theme>` | List target apps lacking a theme PNG |
| `./scripts/poyd themes` | List theme packs + PNG counts |
| `./scripts/poyd init-theme <slug>` | Create `themes/<slug>/` scaffold |

See also [`SAFETY.md`](./SAFETY.md).

## Repo layout
```
themes/<slug>/<AppName>.png   # generated theme packs
originals/<AppName>.png       # local art references (gitignored)
scripts/poyd
AGENTS.md
```

## Product intent
- Agent-driven costume party for the Dock.
- AI restyle, reversible, **never** at the cost of unopenable apps.
