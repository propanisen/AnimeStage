#!/usr/bin/env bash
# Builds the plasmoid packages into build/plasmoids: each package gets a
# copy of the shared QML components (plasma/shared/stage) and the logos.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/build/plasmoids"
rm -rf "$OUT"
mkdir -p "$OUT"
for pkg in "$ROOT"/plasma/plasmoids/org.animestage.*; do
    id="$(basename "$pkg")"
    cp -r "$pkg" "$OUT/$id"
    rm -rf "$OUT/$id/contents/ui/stage"
    cp -r "$ROOT/plasma/shared/stage" "$OUT/$id/contents/ui/stage"
    mkdir -p "$OUT/$id/contents/images"
    cp "$ROOT"/share/logos/*.svg "$OUT/$id/contents/images/"
done
echo "$OUT"
