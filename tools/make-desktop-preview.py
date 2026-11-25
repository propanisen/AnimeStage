#!/usr/bin/env python3
"""Draws README illustrations of the AnimeStage desktop: wallpaper + panel with
window titles (desktop.jpg, taskbar.png) and a wallpaper gallery whose panels
use the colors AnimeStage extracts from each image (wallpapers.jpg).

The panel is an illustration drawn with Pillow in the AnimeStage style (real
Papirus icons, M PLUS Rounded font, colors from `colors_from_image`), because
the real task manager can't be rendered offscreen without real windows.

    tools/make-desktop-preview.py OUTDIR DESKTOP.jpg GALLERY1.jpg GALLERY2.jpg GALLERY3.jpg
"""
import importlib.machinery
import importlib.util
import math
import os
import subprocess
import sys
import tempfile

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.join(os.path.dirname(os.path.realpath(__file__)), "..")
loader = importlib.machinery.SourceFileLoader("animestage_cli", os.path.join(ROOT, "bin", "animestage"))
spec = importlib.util.spec_from_loader("animestage_cli", loader)
cli = importlib.util.module_from_spec(spec)
loader.exec_module(cli)

ICONS = os.path.expanduser("~/.local/share/icons/Papirus-Dark")
FONTS = os.path.expanduser("~/.local/share/fonts/animestage")
S = 2                                   # draw at 2x, downscale afterwards
TMP = tempfile.mkdtemp()


def font(size, weight="Bold"):
    return ImageFont.truetype(os.path.join(FONTS, f"MPLUSRounded1c-{weight}.ttf"), int(size * S))


def svg(path, size):
    out = os.path.join(TMP, f"{os.path.basename(path)}-{size}.png")
    if not os.path.exists(out):
        subprocess.run(["magick", "-background", "none", "-density", "600", path,
                        "-resize", f"{size}x{size}", out], check=True)
    return Image.open(out).convert("RGBA")


def icon(name, size, ctx="apps", res="64x64"):
    return svg(os.path.join(ICONS, res, ctx, name + ".svg"), size)


def rgb(h, a=255):
    h = h.lstrip("#")
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4)) + (a,)


def cover(path, w, h):
    im = Image.open(path).convert("RGB")
    r = max(w / im.width, h / im.height)
    im = im.resize((math.ceil(im.width * r), math.ceil(im.height * r)), Image.LANCZOS)
    x, y = (im.width - w) // 2, (im.height - h) // 2
    return im.crop((x, y, x + w, y + h)).convert("RGBA")


def wrap2(d, text, f, width):
    """Two lines like Plasma's task manager, second one elided."""
    words, lines, cur = text.split(" "), [], ""
    for wd in words:
        t = (cur + " " + wd).strip()
        if d.textlength(t, font=f) <= width or not cur:
            cur = t
        else:
            lines.append(cur)
            cur = wd
    lines.append(cur)
    if len(lines) > 2:
        lines = [lines[0], " ".join(lines[1:])]
    if len(lines) == 2:
        while d.textlength(lines[1] + "…", font=f) > width and len(lines[1]) > 1:
            lines[1] = lines[1][:-1]
        if len(lines[1]) < len(" ".join(text.split(" ")[len(lines[0].split(" ")):])):
            lines[1] = lines[1].rstrip() + "…"
    return lines


TASKS = [  # (icon, title, active, running)
    ("system-file-manager", "Downloads — Dolphin", False, True),
    ("kitty", "~ : fastfetch — kitty", False, True),
    ("firefox", "Frieren: Beyond Journey's End — AniList — Mozilla Firefox", True, True),
    ("firefox", "New Tab — Mozilla Firefox", False, True),
    ("code", "README.md — AnimeStage — Visual Studio Code", False, True),
]


def draw_panel(base, c, y0, x0=None, w=None, h=52, tasks=TASKS, compact=False):
    """Floating AnimeStage panel onto RGBA image `base` (already 2x)."""
    W = base.width
    x0 = 10 * S if x0 is None else x0
    w = W - 2 * x0 if w is None else w
    H = h * S
    acc, acc2 = rgb(c["accent"]), rgb(c["accent2"])
    # shadow + translucent surface with accent edge
    sh = Image.new("RGBA", base.size, (0, 0, 0, 0))
    ImageDraw.Draw(sh).rounded_rectangle((x0, y0 + 4 * S, x0 + w, y0 + H + 4 * S), 14 * S, fill=(0, 0, 0, 120))
    base.alpha_composite(sh.filter(ImageFilter.GaussianBlur(10 * S)))
    lay = Image.new("RGBA", base.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(lay)
    d.rounded_rectangle((x0, y0, x0 + w, y0 + H), 14 * S, fill=rgb(c["surface"], 236),
                        outline=rgb(c["accent"], 90), width=S)
    base.alpha_composite(lay)
    d = ImageDraw.Draw(base)
    cy = y0 + H // 2
    x = x0 + 10 * S

    # launcher: AnimeStage star in an accent circle
    r = 17 * S
    d.ellipse((x, cy - r, x + 2 * r, cy + r), fill=rgb(c["accent"], 60), outline=acc, width=S)
    mark = svg(os.path.join(ROOT, "share", "logos", "animestage-mark.svg"), int(r * 1.3))
    base.alpha_composite(mark, (x + r - mark.width // 2, cy - mark.height // 2))
    x += 2 * r + 12 * S

    # task manager: icon + window title, every window separate
    tf = font(11.5, "Medium") if os.path.exists(os.path.join(FONTS, "MPLUSRounded1c-Medium.ttf")) else font(11.5, "Regular")
    tw = (118 if compact else 172) * S
    for name, title, active, running in tasks:
        bx = (x, y0 + 5 * S, x + tw, y0 + H - 5 * S)
        if active:
            d.rounded_rectangle(bx, 9 * S, fill=rgb(c["surfaceAlt"], 255), outline=rgb(c["accent"], 110), width=S)
        elif running:
            d.rounded_rectangle(bx, 9 * S, fill=rgb(c["surfaceAlt"], 120))
        ic = icon(name, 26 * S)
        base.alpha_composite(ic, (x + 8 * S, cy - ic.height // 2))
        lines = wrap2(d, title, tf, tw - 46 * S)
        lh = 14 * S
        ty = cy - lh * len(lines) // 2 - 1 * S
        for i, ln in enumerate(lines):
            d.text((x + 40 * S, ty + i * lh), ln, font=tf, fill=rgb(c["text"], 255 if active else 215))
        if running:  # indicator line at the bottom like Plasma
            lw = 22 * S if active else 10 * S
            d.rounded_rectangle((x + tw // 2 - lw // 2, y0 + H - 7 * S, x + tw // 2 + lw // 2, y0 + H - 5 * S),
                                S, fill=acc if active else rgb(c["muted"]))
        x += tw + 4 * S
    # pinned Control Center (no window)
    ic = svg(os.path.join(ROOT, "share", "logos", "animestage.svg"), 26 * S)
    base.alpha_composite(ic, (x + 8 * S, cy - ic.height // 2))
    x += 46 * S

    right = x0 + w - 12 * S
    # clock
    cf, df = font(15, "ExtraBold"), font(9.5, "Regular")
    hh, mm = "18", "42"
    tw_ = d.textlength(hh + ":" + mm, font=cf)
    cx = right - tw_
    d.text((cx, cy - 15 * S), hh, font=cf, fill=rgb(c["text"]))
    d.text((cx + d.textlength(hh, font=cf), cy - 15 * S), ":", font=cf, fill=acc)
    d.text((cx + d.textlength(hh + ":", font=cf), cy - 15 * S), mm, font=cf, fill=rgb(c["text"]))
    dt = "Tue 25 Nov"
    d.text((right - d.textlength(dt, font=df), cy + 3 * S), dt, font=df, fill=rgb(c["muted"]))
    right = int(cx) - 16 * S
    if compact:
        return
    # tray
    for n in ("bluetooth-active", "network-wireless-signal-excellent", "audio-volume-high"):
        p = os.path.join(ICONS, "22x22", "panel", n + ".svg")
        if os.path.exists(p):
            ic = svg(p, 18 * S)
            right -= ic.width
            base.alpha_composite(ic, (right, cy - ic.height // 2))
            right -= 8 * S
    right -= 10 * S
    # system rings CPU / RAM / GPU
    rr = 13 * S
    for val, col in ((0.62, acc2), (0.41, rgb(c["positive"])), (0.27, acc)):
        bx = (right - 2 * rr, cy - rr, right, cy + rr)
        d.ellipse(bx, outline=rgb(c["surfaceAlt"], 255), width=4 * S)
        d.arc(bx, -90, -90 + 360 * val, fill=col, width=4 * S)
        right -= 2 * rr + 7 * S
    right -= 8 * S
    # media pill
    mf = font(10.5, "Bold")
    title, artist = "Zoltraak", "Evan Call"
    pw = 190 * S
    px = right - pw
    d.rounded_rectangle((px, cy - 15 * S, right, cy + 15 * S), 15 * S, fill=rgb(c["surfaceAlt"], 230))
    d.ellipse((px + 5 * S, cy - 11 * S, px + 27 * S, cy + 11 * S), fill=acc)
    d.rectangle((px + 13 * S, cy - 5 * S, px + 15 * S, cy + 5 * S), fill=rgb(c["bg"]))
    d.rectangle((px + 18 * S, cy - 5 * S, px + 20 * S, cy + 5 * S), fill=rgb(c["bg"]))
    d.text((px + 34 * S, cy - 14 * S), title, font=mf, fill=rgb(c["text"]))
    d.text((px + 34 * S, cy - 2 * S), artist, font=font(9, "Regular"), fill=rgb(c["muted"]))
    d.line((px + 34 * S, cy + 13 * S, px + pw - 14 * S, cy + 13 * S), fill=rgb(c["muted"], 90), width=S)
    d.line((px + 34 * S, cy + 13 * S, px + 34 * S + int((pw - 48 * S) * 0.38), cy + 13 * S), fill=acc, width=S * 2)


def desktop(out, wall):
    c = cli.colors_from_image(wall)
    W, H = 1600, 900
    base = cover(wall, W * S, H * S)
    py = (H - 52 - 10) * S
    draw_panel(base, c, py)
    base.convert("RGB").resize((W, H), Image.LANCZOS).save(os.path.join(out, "desktop.jpg"), quality=90, optimize=True)
    # close-up of the task manager
    crop = base.crop((0, py - 14 * S, 1080 * S, H * S)).convert("RGB")
    crop.resize((crop.width * 3 // 4, crop.height * 3 // 4), Image.LANCZOS).save(
        os.path.join(out, "taskbar.png"), optimize=True)


def gallery(out, walls):
    tw, th, gap = 520, 293, 16
    W = tw * len(walls) + gap * (len(walls) + 1)
    H = th + 2 * gap + 34
    img = Image.new("RGBA", (W * S, H * S), rgb("#0B0D16"))
    d = ImageDraw.Draw(img)
    for i, w in enumerate(walls):
        c = cli.colors_from_image(w)
        x = (gap + i * (tw + gap)) * S
        tile = cover(w, tw * S, th * S)
        draw_panel(tile, c, (th - 34 - 6) * S, x0=6 * S, h=34, compact=True,
                   tasks=[("firefox", "Firefox", True, True), ("kitty", "kitty", False, True)])
        m = Image.new("L", tile.size, 0)
        ImageDraw.Draw(m).rounded_rectangle((0, 0, tile.width, tile.height), 12 * S, fill=255)
        img.paste(tile, (x, gap * S), m)
        # swatches: accent, second accent, background
        sy = (gap + th + 10) * S
        for j, k in enumerate(("accent", "accent2", "bg", "surfaceAlt")):
            sx = x + j * 30 * S
            d.rounded_rectangle((sx, sy, sx + 24 * S, sy + 16 * S), 5 * S, fill=rgb(c[k]), outline=(255, 255, 255, 40), width=S)
        d.text((x + 128 * S, sy - 1 * S), f'{c["accent"].upper()}  ·  {c["accent2"].upper()}', font=font(11, "Bold"),
               fill=rgb(c["text"]))
    img.convert("RGB").resize((W, H), Image.LANCZOS).save(os.path.join(out, "wallpapers.jpg"), quality=90, optimize=True)


if __name__ == "__main__":
    if len(sys.argv) < 4:
        sys.exit(__doc__)
    outdir = sys.argv[1]
    desktop(outdir, sys.argv[2])
    gallery(outdir, sys.argv[3:])
