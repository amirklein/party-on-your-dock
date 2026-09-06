#!/usr/bin/env bash
# Safe Dock icon refresh — restarts Dock/Finder and clears icon caches only.
# Never touches files inside .app/Contents.
set -euo pipefail

for cache in \
  "$HOME/Library/Caches/com.apple.iconservices.store" \
  "$HOME/Library/Caches/com.apple.iconservices" \
  "$HOME/Library/Caches/com.apple.dock"
do
  if [[ -e "$cache" ]]; then
    rm -rf "$cache"
    echo "cleared $cache"
  fi
done

killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
echo "restarted Dock and Finder (quit themed apps first if icons look stale)"
