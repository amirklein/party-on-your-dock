# FAQ

## Why do my Dock icons still look stock after apply?

Custom icons often do not refresh while an app is running. Quit the app, run apply again if needed, then refresh Dock caches safely:

```bash
./scripts/refresh-dock.sh
```

Never patch files inside `.app/Contents`.

## Why did an app say it was “damaged and can’t be opened”?

That usually means the app bundle was modified or ad-hoc re-signed. This project forbids that. Use `./scripts/poyd revert` for custom icons only, and reinstall the app from the vendor if the signature is already broken.

## Which apps get themed by default?

Prefer Dock apps:

```bash
./scripts/poyd dock
./scripts/poyd apply <theme> --dock
```

## Can I preview before applying?

```bash
./scripts/poyd apply <theme> --dock --dry-run
./scripts/poyd revert --dry-run --dock
```

## How do I undo a theme?

```bash
./scripts/poyd revert --dock
# or
./scripts/poyd revert --only Spotify
```

## Can I theme Slack / Chrome / system apps?

Maybe not. Root-owned, SIP-protected, or locked apps can fail `fileicon set`. Skip them and continue.

## What should generated icons look like?

Logo-only on a transparent background. No square plates, fake squircles, or full-bleed poster art. See [`ART.md`](./ART.md) and [`AGENTS.md`](./AGENTS.md).

## How do I check theme coverage?

```bash
./scripts/poyd missing <theme> --dock
./scripts/theme-coverage.sh <theme> --dock
make coverage THEME=<theme>
```

Generate missing PNGs before apply. See [`themes/example/`](./themes/example/) for a documented pack scaffold.
