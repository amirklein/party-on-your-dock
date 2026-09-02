# Icon art guidelines

Theme PNGs must be **logo-only** on a **transparent** background.

## Do

- Restyle the recognizable app mark/symbol
- Use a square canvas (e.g. 1024×1024) with transparent pixels around the logo
- Match filenames exactly to `./scripts/poyd list` / `./scripts/poyd dock`
- Keep the app identifiable at Dock size

## Don't

- Full-bleed square backgrounds or fake macOS squircle plates
- Poster frames, explosion backdrops, Smash-Ball chrome behind a plate
- Watermarks or tiny unreadable text
- Invent a new logo from scratch when an original exists in `originals/`

## Prompt pattern

> Restyle this app logo in the style of \<theme\>. Output only the symbol on a transparent background — no square background, no poster, no extra chrome. Keep it identifiable.

Validate names before apply:

```bash
./scripts/validate-theme.sh <slug>
./scripts/poyd missing <slug> --dock
```
