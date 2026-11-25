#!/usr/bin/env python3
"""Collects all translatable texts (German source strings) and checks the language files.

    tools/i18n-extract.py            writes i18n/template.json, shows missing translations
    tools/i18n-extract.py --missing ja   lists the missing texts of one language as JSON

Sources: QML (…tr("Text")), Python (_("Text")) and the installer (t "Text").
"""
import ast
import glob
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
I18N = os.path.join(ROOT, "i18n")


def qml_strings():
    out = set()
    pat = re.compile(r'\btr\(\s*"((?:[^"\\]|\\.)*)"')
    for path in glob.glob(os.path.join(ROOT, "plasma", "**", "*.qml"), recursive=True):
        for m in pat.finditer(open(path, encoding="utf-8").read()):
            out.add(json.loads('"' + m.group(1) + '"'))
    return out


def py_strings():
    out = set()
    for path in [os.path.join(ROOT, "bin", "animestage")] + glob.glob(os.path.join(ROOT, "lib", "*.py")):
        tree = ast.parse(open(path, encoding="utf-8").read())
        for node in ast.walk(tree):
            if (isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and node.func.id == "_"
                    and node.args and isinstance(node.args[0], ast.Constant) and isinstance(node.args[0].value, str)):
                out.add(node.args[0].value)
    return out


def sh_strings():
    out = set()
    pat = re.compile(r'\$\(t "((?:[^"\\]|\\.)*)"')
    for path in [os.path.join(ROOT, "install.sh")]:
        for m in pat.finditer(open(path, encoding="utf-8").read()):
            out.add(m.group(1).replace('\\"', '"'))
    return out


def main():
    keys = sorted(qml_strings() | py_strings() | sh_strings())
    os.makedirs(I18N, exist_ok=True)
    if len(sys.argv) > 2 and sys.argv[1] == "--missing":
        have = json.load(open(os.path.join(I18N, f"{sys.argv[2]}.json"), encoding="utf-8")) \
            if os.path.exists(os.path.join(I18N, f"{sys.argv[2]}.json")) else {}
        print(json.dumps([k for k in keys if not have.get(k)], ensure_ascii=False, indent=1))
        return
    with open(os.path.join(I18N, "template.json"), "w", encoding="utf-8") as fh:
        json.dump({k: "" for k in keys}, fh, ensure_ascii=False, indent=1)
        fh.write("\n")
    print(f"{len(keys)} Texte → i18n/template.json")
    for path in sorted(glob.glob(os.path.join(I18N, "*.json"))):
        code = os.path.basename(path)[:-5]
        if code == "template":
            continue
        have = json.load(open(path, encoding="utf-8"))
        missing = [k for k in keys if not have.get(k)]
        unused = [k for k in have if k not in keys]
        print(f"  {code:6} fehlt {len(missing):4}   veraltet {len(unused):3}")


if __name__ == "__main__":
    main()
