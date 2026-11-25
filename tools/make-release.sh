#!/usr/bin/env bash
# Builds the release files into dist/:
#   AnimeStage.zip  – folder AnimeStage-<version>/ with "Install AnimeStage" (double-click)
#   get.sh          – one-line installer
# Then: gh release create v<version> dist/AnimeStage.zip dist/get.sh --notes-file …
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VER="$(cat "$ROOT/VERSION")"
OUT="$ROOT/dist"; NAME="AnimeStage-$VER"
rm -rf "$OUT"; mkdir -p "$OUT/$NAME"
tar -C "$ROOT" --exclude=./.git --exclude=./build --exclude=./dist --exclude='__pycache__' \
    --exclude='*.pyc' -cf - . | tar -C "$OUT/$NAME" -xf -
(cd "$OUT" && zip -qr -X "AnimeStage.zip" "$NAME")   # zip keeps the executable bits
cp "$ROOT/get.sh" "$OUT/get.sh"
rm -rf "${OUT:?}/$NAME"
ls -la "$OUT"
