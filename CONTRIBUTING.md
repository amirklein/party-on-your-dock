# Contributing

Thanks for helping throw a better costume party on the Dock.

## Ground rules

Read [`SAFETY.md`](./SAFETY.md) and the hard rules in [`AGENTS.md`](./AGENTS.md) first.

- **Never** edit files inside an `.app` bundle (no `.icns`, `Assets.car`, `Info.plist`, or `codesign --sign`).
- Apply icons only via `fileicon` / `NSWorkspace.setIcon` custom icons.
- Theme art should be **logo-only** on a transparent background.

## Local setup

```bash
brew install fileicon
chmod +x scripts/poyd
./scripts/poyd help
./scripts/poyd doctor
```

Grant **App Management** to your terminal / Cursor in System Settings → Privacy & Security.

## Suggested change sizes

Prefer small PRs:

1. CLI command or flag
2. Docs / agent instructions
3. Theme scaffolding / tooling (not huge binary dumps unless intentional)

## Before you open a PR

- [ ] `./scripts/poyd help` still runs
- [ ] You did not write under any `*.app/Contents/`
- [ ] Docs mention new commands if you added any
- [ ] Branch name is descriptive (`cursor/...` is fine)

## Agent-driven themes

If an agent generates icons, keep PNGs under `themes/<slug>/` with filenames matching `./scripts/poyd list` / `./scripts/poyd dock`. Do not commit `originals/` (gitignored machine backups).
