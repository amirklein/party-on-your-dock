# Contributing

Thanks for helping throw a better costume party on the Dock.

## Ground rules

Read [`SAFETY.md`](./SAFETY.md) and the hard rules in [`AGENTS.md`](./AGENTS.md) first.

- **Never** edit files inside an `.app` bundle (no `.icns`, `Assets.car`, `Info.plist`, or `codesign --sign`).
- Apply icons only via `fileicon` / `NSWorkspace.setIcon` custom icons.
- Theme art should be **logo-only** on a transparent background.

## Local setup

```bash
./scripts/install-deps.sh
./scripts/poyd help
./scripts/poyd doctor
```

Grant **App Management** to your terminal / Cursor in System Settings → Privacy & Security.

## Suggested change sizes

Prefer small PRs:

1. CLI command or flag
2. Docs / agent instructions
3. Theme scaffolding / tooling (not huge binary dumps unless intentional)


## Make workflow

```bash
make init-theme NAME="My Theme"
make missing THEME=my-theme
make validate THEME=my-theme
make coverage THEME=my-theme
make preview THEME=my-theme
make apply THEME=my-theme
make refresh
make revert
```

Use `THEME=<slug>` for theme-scoped targets. See [`AGENTS.md`](./AGENTS.md) for the full Make shortcuts table.

## Theme validation

Before applying or committing a theme pack:

```bash
./scripts/poyd missing <slug> --dock
./scripts/validate-theme.sh <slug>
```

Fix unknown PNG filenames (must match `./scripts/poyd list`) and generate missing icons.

## Before you open a PR

- [ ] `./scripts/poyd help` still runs
- [ ] You did not write under any `*.app/Contents/`
- [ ] Docs mention new commands if you added any
- [ ] Branch name is descriptive (`cursor/...` is fine)

## Agent-driven themes

If an agent generates icons, keep PNGs under `themes/<slug>/` (see [`themes/example/`](./themes/example/) for a scaffold) with filenames matching `./scripts/poyd list` / `./scripts/poyd dock`. Do not commit `originals/` (gitignored machine backups).

## Shell completion

```bash
source ./scripts/poyd.bash   # bash
source ./scripts/poyd.zsh   # zsh
source ./scripts/poyd.fish  # fish
```
