#!/usr/bin/env bash
# Developer helper: builds and (re)installs single or all plasmoids.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$("$ROOT/tools/build-plasmoids.sh")"
mkdir -p "$HOME/.local/bin" "$HOME/.local/share/animestage"
install -m 755 "$ROOT/bin/animestage" "$HOME/.local/bin/animestage"
cp -r "$ROOT/share/." "$HOME/.local/share/animestage/"
for id in "${@:-all}"; do
    if [[ "$id" == all ]]; then set -- "$OUT"/org.animestage.*; else set -- "$OUT/org.animestage.$id"; fi
    for pkg in "$@"; do
        kpackagetool6 -t Plasma/Applet -u "$pkg" >/dev/null 2>&1 || kpackagetool6 -t Plasma/Applet -i "$pkg"
        echo "ok $(basename "$pkg")"
    done
done
