#!/usr/bin/env python3
"""Frames rendered widget images for the README: background in the theme color,
rounded corners, soft shadow. Also creates preview.png (collage).

    tools/screenshot-frame.py ROHORDNER docs/screenshots [#hintergrund]
"""
import os
import sys
from PIL import Image, ImageDraw, ImageFilter

src, dst = sys.argv[1], sys.argv[2]
bg = sys.argv[3] if len(sys.argv) > 3 else "#0B0D16"
os.makedirs(dst, exist_ok=True)


def hex2rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))


def framed(path, radius=18, pad=28, panel="#11141F"):
    im = Image.open(path).convert("RGBA")
    # put transparent areas on the popup background
    base = Image.new("RGBA", im.size, hex2rgb(panel) + (255,))
    base.alpha_composite(im)
    mask = Image.new("L", im.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, im.width - 1, im.height - 1), radius, fill=255)
    W, H = im.width + 2 * pad, im.height + 2 * pad
    out = Image.new("RGBA", (W, H), hex2rgb(bg) + (255,))
    shadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle((pad, pad + 8, pad + im.width, pad + im.height + 8), radius, fill=(0, 0, 0, 150))
    out.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(14)))
    out.paste(base, (pad, pad), mask)
    return out


shots = {}
for name in sorted(os.listdir(src)):
    if name.endswith(".png"):
        img = framed(os.path.join(src, name))
        img.convert("RGB").save(os.path.join(dst, name), optimize=True)
        shots[name] = img
        print("✓", name, img.size)

# Collage: start menu large, calendar + system load on the right
if {"launcher.png", "calendar.png", "system.png"} <= shots.keys():
    L, C, S = shots["launcher.png"], shots["calendar.png"], shots["system.png"]
    scale = L.height / (C.height + S.height)
    C2 = C.resize((int(C.width * scale), int(C.height * scale)), Image.LANCZOS)
    S2 = S.resize((int(S.width * scale), int(S.height * scale)), Image.LANCZOS)
    right = max(C2.width, S2.width)
    out = Image.new("RGBA", (L.width + right, L.height), hex2rgb(bg) + (255,))
    out.alpha_composite(L, (0, 0))
    out.alpha_composite(C2, (L.width, 0))
    out.alpha_composite(S2, (L.width, C2.height))
    out.convert("RGB").save(os.path.join(dst, "preview.png"), optimize=True)
    print("✓ preview.png", out.size)
