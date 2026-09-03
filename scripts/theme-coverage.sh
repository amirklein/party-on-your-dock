#!/usr/bin/env bash
# Report theme pack coverage vs Dock apps (present / missing counts).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
THEME="${1:-}"
SCOPE="${2:---dock}"

if [[ -z "$THEME" ]]; then
  echo "usage: $0 <theme-slug> [--dock]" >&2
  exit 1
fi

DIR="$ROOT/themes/$THEME"
if [[ ! -d "$DIR" ]]; then
  echo "error: theme not found: $DIR" >&2
  exit 1
fi

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

if ! "$ROOT/scripts/poyd" missing "$THEME" $SCOPE > "$TMP" 2>&1; then
  true
fi

present=0
missing=0
while IFS=$'\t' read -r status name; do
  [[ -z "${status:-}" ]] && continue
  case "$status" in
    present) present=$((present + 1)) ;;
    missing) missing=$((missing + 1)) ;;
  esac
done < <(grep -E '^(present|missing)\t' "$TMP" || true)

pngs=$(find "$DIR" -maxdepth 1 -name '*.png' | wc -l | tr -d ' ')

echo "theme: $THEME"
echo "scope: ${SCOPE#--}"
echo "dock targets: $((present + missing)) (present $present, missing $missing)"
echo "theme pngs: $pngs"
echo
cat "$TMP" | grep -E '^(present|missing)\t' || true

if (( missing > 0 )); then
  exit 2
fi
