# Credits & image sources

AnimeStage does not ship any anime images – everything is downloaded only when you choose an anime.

| Source | Used for | Note |
|---|---|---|
| [AniList](https://anilist.co) | anime search, titles, cover, banner, characters, ages | public GraphQL API |
| [Konachan](https://konachan.net) | wallpapers, terminal and Firefox images | konachan.net = “safe” only; konachan.com only for Ecchi/NSFW with adult characters |
| [Danbooru](https://danbooru.donmai.us) | cutouts (characters without background) | AI-generated images are banned there |

Artists and source pages are shown for every image in the Control Center (hover an image) and stored in
`~/.local/state/animestage/wallswitch.json` and `~/.local/share/animestage/anime/<id>/cuts/credits.json`.

- Logo and panel icons (`share/logos/`) are original SVGs made for this project.
- Font: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) – SIL Open Font License (downloaded during installation).
- Icons: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) – GPL-3.0 (downloaded during installation, folders recolored).
- Screenshots in `docs/screenshots/` show *Frieren: Beyond Journey's End* – characters © Kanehito Yamada, Tsukasa Abe / Shogakukan / “Frieren” Project; artwork © the respective artists on Konachan and Danbooru.
  - Wallpapers in `desktop.jpg`, `taskbar.png` and `wallpapers.jpg`: seoki ([konachan #364587](https://konachan.net/post/show/364587)), ji dao ji ([#367161](https://konachan.net/post/show/367161)), oichida ([#387511](https://konachan.net/post/show/387511)), takoyoomi ([#400149](https://konachan.net/post/show/400149)).
  - The panel in these three images is an illustration drawn by `tools/make-desktop-preview.py` in the AnimeStage style (real icons, font and extracted colors); the other screenshots are rendered from the real widgets.

All anime characters © their respective owners. Non-commercial fan project, not affiliated with any of the services above.
