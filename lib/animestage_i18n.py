"""AnimeStage – translations.

Source strings are German; i18n/<lang>.json maps every German text to its
translation. If a translation is missing, English is used, otherwise German.

    from animestage_i18n import _, setup
    setup(cfg)                                   # language from config/system
    say(_("Hintergrund: {name}", name=n))

The widgets (StageConfig.tr) and the installer use the same files
(`python3 animestage_i18n.py --bash` prints a bash dictionary).
"""

import json
import locale
import os
import sys

LANGUAGES = {
    # code: (native name, English name)
    "en": ("English", "English"),
    "de": ("Deutsch", "German"),
    "ja": ("日本語", "Japanese"),
    "fr": ("Français", "French"),
    "es": ("Español (España)", "Spanish (Spain)"),
    "pt_BR": ("Português (Brasil)", "Portuguese (Brazil)"),
    "it": ("Italiano", "Italian"),
    "pl": ("Polski", "Polish"),
    "nl": ("Nederlands", "Dutch"),
    "ru": ("Русский", "Russian"),
    "zh_CN": ("简体中文", "Chinese (Simplified)"),
    "zh_TW": ("繁體中文（台灣）", "Chinese (Traditional, Taiwan)"),
    "ko": ("한국어", "Korean"),
}
SOURCE = "de"

_here = os.path.dirname(os.path.realpath(__file__))
SEARCH = [os.path.join(_here, "..", "i18n"),                      # development folder
          os.path.join(os.environ.get("XDG_DATA_HOME") or os.path.expanduser("~/.local/share"),
                       "animestage", "i18n")]
_lang = SOURCE
_table = {}
_fallback = {}


def normalize(code):
    """„de_DE.UTF-8“ → „de“, „pt_BR“ → „pt_BR“, „zh_HK“ → „zh_TW“ …"""
    code = (code or "").split(".")[0].split("@")[0].replace("-", "_")
    if not code or code in ("C", "POSIX"):
        return "en"
    if code in LANGUAGES:
        return code
    base = code.split("_")[0]
    if base == "zh":
        return "zh_TW" if code.split("_")[-1] in ("TW", "HK", "MO", "Hant") else "zh_CN"
    if base == "pt":
        return "pt_BR"
    return base if base in LANGUAGES else "en"


def system_language():
    for var in ("LANGUAGE", "LC_ALL", "LC_MESSAGES", "LANG"):
        val = os.environ.get(var)
        if val:
            return normalize(val.split(":")[0])
    try:
        return normalize(locale.getlocale()[0])
    except Exception:
        return "en"


def resolve(setting):
    """Config value "auto" or language code → actual language."""
    if setting and setting != "auto":
        return normalize(setting)
    return system_language()


def _load(code):
    for base in SEARCH:
        path = os.path.join(base, f"{code}.json")
        if os.path.exists(path):
            try:
                with open(path, encoding="utf-8") as fh:
                    data = json.load(fh)
                return {k: v for k, v in data.items() if isinstance(v, str) and v}
            except (OSError, ValueError):
                pass
    return {}


def setup(cfg=None, lang=None):
    global _lang, _table, _fallback
    _lang = normalize(lang) if lang else resolve((cfg or {}).get("language", "auto"))
    _table = {} if _lang == SOURCE else _load(_lang)
    _fallback = {} if _lang in (SOURCE, "en") else _load("en")
    return _lang


def current():
    return _lang


def _(text, **kw):
    out = _table.get(text) or _fallback.get(text) or text
    if kw:
        try:
            out = out.format(**kw)
        except (KeyError, IndexError, ValueError):
            out = text.format(**kw)
    return out


def bash_dict(lang):
    """For the installer: `declare -A TR=([german]=translation …)`."""
    import shlex
    setup(lang=lang)
    merged = dict(_fallback)
    merged.update(_table)
    items = " ".join(f"[{shlex.quote(k)}]={shlex.quote(v)}" for k, v in merged.items())
    return f"declare -gA TR=({items}); TR_LANG={shlex.quote(_lang)}"


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--bash":
        print(bash_dict(sys.argv[2] if len(sys.argv) > 2 else system_language()))
    elif len(sys.argv) > 1 and sys.argv[1] == "--list":
        print(json.dumps({k: v[0] for k, v in LANGUAGES.items()}, ensure_ascii=False))
    else:
        print(system_language())
