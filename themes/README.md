# Theme packs

Each subdirectory is a theme slug. Filenames must match app names from `./scripts/poyd list`:

```
themes/n64/Slack.png
themes/n64/Spotify.png
```

## Scaffold a pack

```bash
./scripts/poyd init-theme "Nintendo 64"   # → themes/n64/
./scripts/poyd themes                     # list packs + icon counts
```

Generate logo-only transparent PNGs with an agent (“change my theme to …”), then validate:

```bash
./scripts/poyd missing n64 --dock
./scripts/validate-theme.sh n64
./scripts/poyd apply n64
```

## Coverage report

```bash
./scripts/theme-coverage.sh n64 --dock
```

Lists present vs missing Dock icons for a theme pack.

## Example pack

See [`example/`](./example/) for a documented scaffold (README only, no bundled PNGs).

## Full workflow

```bash
./scripts/poyd init-theme "My Theme"
./scripts/poyd missing my-theme --dock
./scripts/validate-theme.sh my-theme
./scripts/theme-coverage.sh my-theme --dock
./scripts/poyd apply my-theme --dock --dry-run
./scripts/poyd apply my-theme --dock
./scripts/refresh-dock.sh
```

Or via Make: `make apply THEME=my-theme`, `make coverage THEME=my-theme`, `make refresh`.
