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
