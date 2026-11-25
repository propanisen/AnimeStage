"""AnimeStage – all image sources in one place.

This file (and only this file) knows how to search and download from an image site.
The control program `animestage` only asks:

    src = get("konachan")
    posts = src.search(["sousou_no_frieren", "night"], rating="s")
    src.tags("frieren", "character")      # → [(tag, count), …]
    raw = download(posts[0]["url"])

Every source returns uniform entries (Post):
    id, site, tags (text, space separated), rating ("s" safe, "q" questionable,
    "e" explicit), width, height, url (full size), large (large JPEG), sample (smaller),
    page (image page), author, source, ext, chars (character tags, if known), score

Adding a new site: write a class with `search`, `tags` (and optionally `lookup`)
and register it in SOURCES below. It then becomes selectable in the Control Center.

Ratings: when in doubt the stricter rating is reported (Danbooru "sensitive" → "q"),
so the safety rules in `animestage` never become too lax.
"""

import json
import random as _random
import urllib.parse
import urllib.request

IMAGE_EXT = {"jpg", "jpeg", "png", "webp"}
UA = {"User-Agent": "AnimeStage/1.0 (personal KDE desktop theme)"}
KINDS = ("general", "copyright", "character")


def http_get(url, timeout=60):
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        return resp.read()


def http_json(url, timeout=30):
    return json.loads(http_get(url, timeout))


def download(url, timeout=120):
    """Bilddatei laden (Bytes)."""
    return http_get(url, timeout)


class Post(dict):
    """Uniform image entry, behaves like a dict."""

    @property
    def tagset(self):
        return set(self.get("tags", "").split())


class Source:
    name = ""            # internal name (config)
    label = ""           # shown in the Control Center
    prefix = ""          # file name prefix (kc-123.jpg …)
    max_tags = 6         # max search tags the site accepts (the rest is filtered locally)
    safe_only = False    # site has safe images only
    cutouts = False      # knows the tag "transparent_background" (cutouts)
    has_categories = True  # tags distinguish copyright/character

    def search(self, tags, rating="s", limit=100, random=True, page=1, timeout=30):
        """List of Post. rating: "s", "q", "e" or None (any)."""
        raise NotImplementedError

    def tags(self, name, kind, limit=30, timeout=30):
        """[(tag, count)] – tags containing `name`, only of type kind (KINDS)."""
        raise NotImplementedError

    def lookup(self, term, timeout=15):
        """[(tag, count)] – all tag types, for free search."""
        return self.tags(term, "general", 20, timeout)

    def _split(self, tags):
        tags = [t for t in tags if t]
        return tags[:self.max_tags], set(t for t in tags[self.max_tags:] if not t.startswith("-"))

    @staticmethod
    def _image(post):
        """Real images only (no videos/animations/archives)."""
        return post["ext"] in IMAGE_EXT and bool(post["url"])

    @staticmethod
    def _filter(posts, rest):
        return [p for p in posts if rest <= p.tagset] if rest else posts

    def __repr__(self):
        return f"<Quelle {self.name}>"


# ---------------------------------------------------------------- Moebooru
# Konachan, yande.re (same API)

class Moebooru(Source):
    RATING_TAG = {"s": "rating:safe", "q": "rating:questionable", "e": "rating:explicit"}
    TYPES = {"general": 0, "copyright": 3, "character": 4}

    def __init__(self, name, label, host, prefix, adult_host=None, random_order=True):
        self.name, self.label, self.host, self.prefix = name, label, host, prefix
        self.adult_host = adult_host or host
        self.random_order = random_order   # yande.re has no order:random → random page

    def _host(self, rating):
        return self.host if rating in ("s", None) else self.adult_host

    def search(self, tags, rating="s", limit=100, random=True, page=1, timeout=30):
        send, rest = self._split(list(tags))
        q = send + ([self.RATING_TAG[rating]] if rating else []) + (["order:random"] if random and self.random_order else [])
        host = self._host(rating)
        if random and not self.random_order and page == 1:
            page = _random.randint(1, 4)
        params = {"tags": " ".join(q), "limit": limit}
        if page > 1:
            params["page"] = page
        data = http_json(f"{host}/post.json?" + urllib.parse.urlencode(params), timeout)
        if not data and page > 1 and random and not self.random_order:
            params.pop("page")              # not that many pages → first page
            data = http_json(f"{host}/post.json?" + urllib.parse.urlencode(params), timeout)
        if random and not self.random_order:
            _random.shuffle(data)
        out = []
        for p in data:
            pid = str(p.get("id"))
            out.append(Post(
                id=pid, site=self.name, tags=p.get("tags", ""), rating=p.get("rating", "e"),
                width=p.get("width", 0), height=p.get("height", 0),
                url=p.get("file_url") or p.get("jpeg_url") or "",
                large=p.get("jpeg_url") or p.get("file_url") or "",
                sample=p.get("sample_url") or p.get("jpeg_url") or "",
                page=f"{host}/post/show/{pid}", author=p.get("author") or "", source=p.get("source") or "",
                ext=(p.get("file_url") or "").rsplit(".", 1)[-1].lower(), chars=None, score=p.get("score", 0)))
        return self._filter([p for p in out if self._image(p)], rest)

    def tags(self, name, kind, limit=30, timeout=30):
        t = self.TYPES[kind]
        q = urllib.parse.urlencode({"name": name, "type": t, "order": "count", "limit": limit})
        return [(x["name"], x["count"]) for x in http_json(f"{self.host}/tag.json?{q}", timeout) if x.get("type") == t]

    def lookup(self, term, timeout=15):
        q = urllib.parse.urlencode({"name": term, "order": "count", "limit": 20})
        return [(x["name"], x.get("count", 0)) for x in http_json(f"{self.host}/tag.json?{q}", timeout)]


# ---------------------------------------------------------------- Danbooru

class Danbooru(Source):
    # Danbooru: g = general, s = sensitive, q = questionable, e = explicit
    RATING_IN = {"s": "rating:g", "q": "rating:s", "e": "rating:q,e"}
    RATING_OUT = {"g": "s", "s": "q", "q": "e", "e": "e"}
    CATS = {"general": 0, "copyright": 3, "character": 4}
    max_tags = 2         # without an account at most 2 tags (rating: doesn't count, random does)
    cutouts = True

    def __init__(self, name, label, host, prefix):
        self.name, self.label, self.host, self.prefix = name, label, host, prefix

    def search(self, tags, rating="s", limit=100, random=True, page=1, timeout=30):
        tags = [t for t in tags if t]
        n = 1 if random else self.max_tags
        send, rest = tags[:n], set(t for t in tags[n:] if not t.startswith("-"))
        q = send + ([self.RATING_IN[rating]] if rating else [])
        params = {"tags": " ".join(q), "limit": limit}
        if random:
            params["random"] = "true"
        if page > 1:
            params["page"] = page
        out = []
        for p in http_json(f"{self.host}/posts.json?" + urllib.parse.urlencode(params), timeout):
            if not p.get("id") or not p.get("file_url"):
                continue            # banned/deleted posts have no URL
            pid = str(p["id"])
            out.append(Post(
                id=pid, site=self.name, tags=p.get("tag_string", ""), rating=self.RATING_OUT.get(p.get("rating"), "e"),
                width=p.get("image_width", 0), height=p.get("image_height", 0),
                url=p.get("file_url", ""), large=p.get("file_url", ""),
                sample=p.get("large_file_url") or p.get("file_url", ""),
                page=f"{self.host}/posts/{pid}", author=p.get("tag_string_artist") or "", source=p.get("source") or "",
                ext=(p.get("file_ext") or "").lower(), chars=p.get("tag_string_character", ""), score=p.get("score", 0)))
        return self._filter([p for p in out if self._image(p)], rest)

    def tags(self, name, kind, limit=20, timeout=30):
        q = urllib.parse.urlencode({"search[name_or_alias_matches]": f"*{name}*", "search[category]": self.CATS[kind],
                                    "search[order]": "count", "limit": limit})
        return [(x["name"], x["post_count"]) for x in http_json(f"{self.host}/tags.json?{q}", timeout)]

    def lookup(self, term, timeout=15):
        q = urllib.parse.urlencode({"search[name_or_alias_matches]": f"*{term}*", "search[order]": "count", "limit": 20})
        return [(x["name"], x["post_count"]) for x in http_json(f"{self.host}/tags.json?{q}", timeout)]


# ---------------------------------------------------------------- Gelbooru software
# safebooru.org: safe images only, tags like Danbooru – but without copyright/character categories.
# So copyright and character tags are looked up on Danbooru (same names).

class Gelbooru(Source):
    RATING_OUT = {"general": "s", "safe": "s", "sensitive": "q", "questionable": "q", "explicit": "e", "s": "s", "q": "q", "e": "e"}
    has_categories = False

    def __init__(self, name, label, host, prefix, safe_only=False, tag_helper=None):
        self.name, self.label, self.host, self.prefix = name, label, host, prefix
        self.safe_only = safe_only
        self.tag_helper = tag_helper

    def search(self, tags, rating="s", limit=100, random=True, page=1, timeout=30):
        if rating and rating != "s" and self.safe_only:
            return []
        send, rest = self._split(list(tags))
        q = send + (["sort:random"] if random else [])
        if rating and not self.safe_only:
            q.append({"s": "rating:general", "q": "rating:questionable", "e": "rating:explicit"}[rating])
        params = {"page": "dapi", "s": "post", "q": "index", "json": 1, "limit": limit, "tags": " ".join(q)}
        if page > 1:
            params["pid"] = page - 1
        data = http_json(f"{self.host}/index.php?" + urllib.parse.urlencode(params), timeout)
        if isinstance(data, dict):
            data = data.get("post", [])
        out = []
        for p in data or []:
            pid = str(p.get("id"))
            r = self.RATING_OUT.get(str(p.get("rating", "")).lower(), "e")
            if rating and r != rating:
                continue
            url = p.get("file_url") or ""
            out.append(Post(
                id=pid, site=self.name, tags=p.get("tags", ""), rating=r,
                width=p.get("width", 0), height=p.get("height", 0), url=url, large=url,
                sample=p.get("sample_url") or url,
                page=f"{self.host}/index.php?page=post&s=view&id={pid}", author=p.get("owner") or "",
                source=p.get("source") or "", ext=url.rsplit(".", 1)[-1].lower(), chars=None, score=p.get("score", 0)))
        return self._filter([p for p in out if self._image(p)], rest)

    def tags(self, name, kind, limit=30, timeout=30):
        if self.tag_helper:
            return get(self.tag_helper).tags(name, kind, limit, timeout)
        return []

    def lookup(self, term, timeout=15):
        if self.tag_helper:
            return get(self.tag_helper).lookup(term, timeout)
        return []


# ---------------------------------------------------------------- list of sources

SOURCES = {
    "konachan": Moebooru("konachan", "Konachan", "https://konachan.net", "kc",
                         adult_host="https://konachan.com"),
    # cutouts only (characters without background) – Konachan has none
    "danbooru": Danbooru("danbooru", "Danbooru", "https://danbooru.donmai.us", "db"),

    # Add more sources here later and enable them in PURPOSES below, e.g.:
    # "yandere": Moebooru("yandere", "yande.re", "https://yande.re", "yd", random_order=False),
    # "safebooru": Gelbooru("safebooru", "Safebooru (safe only)", "https://safebooru.org", "sb",
    #                       safe_only=True, tag_helper="danbooru"),
}

# Which sources are offered for which purpose (first = default). Selectable in the
# Control Center under System → Image sources.
PURPOSES = {
    "wallpaper": ["konachan"],
    "cutouts": ["danbooru"],
}
DEFAULTS = {"wallpaper": "konachan", "cutouts": "danbooru"}


def get(name):
    return SOURCES.get(name) or SOURCES[DEFAULTS["wallpaper"]]


def for_purpose(name, purpose):
    """Source for a purpose; unknown/unsuitable → default."""
    return get(name if name in PURPOSES[purpose] else DEFAULTS[purpose])


def check(name, timeout=12):
    """Is the site reachable? → (True, number of images found) or (False, error text)"""
    try:
        posts = get(name).search([], rating="s", limit=5, random=False, timeout=timeout)
        return True, len(posts)
    except Exception as exc:
        return False, str(exc)


def listing():
    return {purpose: [{"value": n, "text": SOURCES[n].label} for n in names] for purpose, names in PURPOSES.items()}
