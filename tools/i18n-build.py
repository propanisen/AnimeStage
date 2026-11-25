#!/usr/bin/env python3
"""Builds i18n/<lang>.json from i18n/src/<lang>.txt (one translation per line,
same order as i18n/template.json) and checks the placeholders.

    tools/i18n-build.py ja        one language
    tools/i18n-build.py           all existing ones
"""
import glob, json, os, re, sys
ROOT = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
I18N = os.path.join(ROOT, "i18n")
PH = re.compile(r"\{[a-zA-Z_][a-zA-Z0-9_]*\}|%\d|%s")

def build(code):
    keys = list(json.load(open(os.path.join(I18N, "template.json"), encoding="utf-8")))
    lines = [l for l in open(os.path.join(I18N, "src", f"{code}.txt"), encoding="utf-8").read().split("\n") if l.strip()]
    # Format "index<TAB>translation" (index = position in template.json)
    if lines and "\t" in lines[0] and lines[0].split("\t")[0].isdigit():
        byidx = {}
        for l in lines:
            n, _, v = l.partition("\t")
            byidx[int(n)] = v
        missing = [i for i in range(len(keys)) if i not in byidx]
        if missing:
            sys.exit(f"{code}: fehlende Nummern {missing[:20]}")
        lines = [byidx[i] for i in range(len(keys))]
    if len(lines) != len(keys):
        sys.exit(f"{code}: {len(lines)} Zeilen, erwartet {len(keys)}")
    out, bad = {}, []
    for i, (k, v) in enumerate(zip(keys, lines)):
        v = v.strip()
        if sorted(PH.findall(k)) != sorted(PH.findall(v)):
            bad.append(f"  Zeile {i + 1}: {k!r} → {v!r}")
        out[k] = v
    if bad:
        sys.exit(f"{code}: Platzhalter stimmen nicht:\n" + "\n".join(bad))
    with open(os.path.join(I18N, f"{code}.json"), "w", encoding="utf-8") as fh:
        json.dump(out, fh, ensure_ascii=False, indent=1)
        fh.write("\n")
    print(f"{code}: {len(out)} Texte")

codes = sys.argv[1:] or [os.path.basename(p)[:-4] for p in sorted(glob.glob(os.path.join(I18N, "src", "*.txt")))]
for c in codes:
    build(c)
