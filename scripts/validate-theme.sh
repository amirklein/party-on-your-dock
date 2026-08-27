#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
THEME="${1:-}"

if [[ -z "$THEME" ]]; then
  echo "usage: $0 <theme-slug>" >&2
  exit 1
fi

DIR="$ROOT/themes/$THEME"
if [[ ! -d "$DIR" ]]; then
  echo "error: theme not found: $DIR" >&2
  exit 1
fi

APPS_FILE="$(mktemp)"
trap 'rm -f "$APPS_FILE"' EXIT
"$ROOT/scripts/poyd" list > "$APPS_FILE"

pngs=0
unknown=0
echo "theme: $THEME"
shopt -s nullglob
for png in "$DIR"/*.png; do
  pngs=$((pngs + 1))
  name="$(basename "$png" .png)"
  if grep -Fxq "$name" "$APPS_FILE"; then
    echo "ok	$name.png"
  else
    echo "unknown	$name.png (no matching /Applications app)"
    unknown=$((unknown + 1))
  fi
done

echo "validate: $pngs png(s), $unknown unknown name(s)" >&2
if (( unknown > 0 )); then
  exit 2
fi
