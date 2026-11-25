#!/usr/bin/env bash
# Renders a widget invisibly (offscreen) as PNG – for screenshots/tests.
#   tools/render-widget.sh control win out.png [lang] [page] [wait-ms] [WIDTHxHEIGHT]
# Uses the current environment – for demo screenshots point XDG_CONFIG_HOME/XDG_DATA_HOME
# to a demo environment (see tools/make-screenshots.sh).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
W="$1"; ITEM="$2"; OUT="$(realpath -m "$3")"; LANGC="${4:-}"; PAGE="${5:-}"; WAIT="${6:-4000}"; SIZE="${7:-}"
TMP="$(mktemp -d)"; T="$TMP/org.animestage.${W}render"
cp -r "$ROOT/plasma/plasmoids/org.animestage.$W" "$T"
rm -rf "$T/contents/ui/stage"; cp -r "$ROOT/plasma/shared/stage" "$T/contents/ui/stage"
sed -i "s/\"Id\": \"org.animestage.$W\"/\"Id\": \"org.animestage.${W}render\"/" "$T/metadata.json"
# RENDER_USER="Name": show this name instead of your login name (screenshots without personal data)
if [[ -n "${RENDER_USER:-}" ]]; then
    sed -i "s/(kuser.fullName || kuser.loginName)/\"$RENDER_USER\"/" "$T/contents/ui/main.qml"
fi
if [[ -n "$LANGC" ]]; then
    sed -i "s/readonly property string language: normalizeLanguage(/readonly property string language: \"$LANGC\" || normalizeLanguage(/" "$T/contents/ui/stage/StageConfig.qml"
fi
python3 - "$T/contents/ui/main.qml" "$ITEM" "$OUT" "$PAGE" "$WAIT" "$SIZE" <<'PY'
import sys, re
p, item, out, page, wait, size = sys.argv[1:7]
s = open(p).read()
i = s.index(f"id: {item}\n"); j = s.index("\n", i)
hook = f'        Timer {{ interval: {wait}; running: true; onTriggered: {item}.grabToImage(function(r) {{ r.saveToFile("{out}"); Qt.quit(); }}) }}\n'
if page:
    hook += f'        Timer {{ interval: 300; running: true; onTriggered: pages.currentIndex = {page} }}\n'
extra = __import__("os").environ.get("RENDER_JS", "")
if extra:
    hook += f'        Timer {{ interval: 400; running: true; onTriggered: {{ {extra} }} }}\n'
if size:
    w, h = size.split("x")
    hook += (f'        Timer {{ interval: 150; running: true; onTriggered: if ({item}.Window.window) '
             f'{{ {item}.Window.window.width = {w}; {item}.Window.window.height = {h} }} }}\n')
s = s[:j + 1] + hook + s[j + 1:]
open(p, "w").write(s)
PY
kpackagetool6 -t Plasma/Applet -i "$T" >/dev/null 2>&1 || kpackagetool6 -t Plasma/Applet -u "$T" >/dev/null
(cd "$TMP" && env -u ELECTRON_RUN_AS_NODE ${RENDER_SOFTWARE:+QT_QUICK_BACKEND=software} QT_QPA_PLATFORM=offscreen \
    timeout $(( WAIT / 1000 + 10 )) plasmawindowed "org.animestage.${W}render" 2>&1 | grep -iv "kf.svg\|libpng\|qt.qpa\|propagateSizeHints" | head -5) || true
kpackagetool6 -t Plasma/Applet -r "org.animestage.${W}render" >/dev/null 2>&1 || true
rm -rf "$TMP"
ls -la "$OUT"
