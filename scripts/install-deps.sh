#!/usr/bin/env bash
set -euo pipefail

echo "Installing party-on-your-dock dependencies..."

if ! command -v brew >/dev/null 2>&1; then
  echo "error: Homebrew is required (https://brew.sh)" >&2
  exit 1
fi

if command -v fileicon >/dev/null 2>&1; then
  echo "ok: fileicon already installed"
else
  brew install fileicon
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
chmod +x "$ROOT/scripts/poyd" "$ROOT/scripts/poyd.swift" "$ROOT/scripts/install-deps.sh"

echo "ok: scripts marked executable"
echo "Next: ./scripts/poyd doctor"
