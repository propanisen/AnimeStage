# AnimeStage

**Turn your KDE Plasma 6 desktop into your favorite anime.**
Type in an anime – AnimeStage builds the whole desktop around it: rotating wallpapers, matching colors everywhere, characters in the start menu, a themed terminal, Firefox and VS Code.

🌐 **English** · [Deutsch](docs/README.de.md) · [日本語](docs/README.ja.md) · [Français](docs/README.fr.md) · [Español](docs/README.es.md) · [Português (BR)](docs/README.pt_BR.md) · [Italiano](docs/README.it.md) · [Polski](docs/README.pl.md) · [Nederlands](docs/README.nl.md) · [Русский](docs/README.ru.md) · [简体中文](docs/README.zh_CN.md) · [繁體中文](docs/README.zh_TW.md) · [한국어](docs/README.ko.md)

![AnimeStage desktop with Frieren wallpaper and the AnimeStage panel](docs/screenshots/desktop.jpg)

## Features

- **Pick any anime** – search via AniList; title, banner and characters (with age) are loaded automatically.
- **Wallpapers that rotate** – new images from Konachan every 2 hours (adjustable), per character, filter and mood. Save favorites or ban images.
- **Colors follow the wallpaper** – accent colors are taken from every new image and applied to Plasma, window decorations, icons (Papirus folders), terminal, Firefox and VS Code.
- **Anime-style panel** – start menu with a character cutout, a Windows-like taskbar with window titles, music player, CPU/RAM/GPU rings and a calendar.
- **Terminal** – kitty or Konsole in theme colors, a greeting with a fresh image + system info, Starship prompt, and an optional image as terminal background.
- **Firefox** – tabs and address bar in matching colors plus a new-tab image that changes on every start.
- **Lock screen & login screen** show your wallpaper too (login: Plasma Login Manager).
- **Control Center** – everything in one window, no config files needed.
- **13 languages** – follows your system language, switchable in the Control Center.

### Taskbar like on Windows

![Taskbar with window titles](docs/screenshots/taskbar.png)

Every window gets its own entry with its title next to the icon – two Firefox windows are two entries. Pinned apps stay where you put them, and their windows open right there. In **Control Center → Appearance → Taskbar** you can turn titles off, group windows or choose the width (narrow / medium / wide).

### Wallpapers & colors

![Three wallpapers, each with the colors AnimeStage takes from it](docs/screenshots/wallpapers.jpg)

Every new wallpaper brings its own colors: AnimeStage takes the accent and background colors from the image and recolors the panel, windows, icons, terminal, Firefox and VS Code – automatically every 2 hours. The panel at the bottom of each picture shows the colors of that image.

### Start menu, calendar & system load

![AnimeStage: start menu, calendar and system load](docs/screenshots/preview.png)

| Control Center – anime & characters | Control Center – wallpaper |
|---|---|
| ![Control Center: anime](docs/screenshots/control-anime.png) | ![Control Center: wallpaper](docs/screenshots/control-wallpaper.png) |

## Requirements

- **KDE Plasma 6** (made for and tested on Bazzite / Fedora Atomic with Plasma 6.8; other distributions with Plasma 6 should work)
- Python 3 with **Pillow** (`python3-pillow`)
- An internet connection (AniList, Konachan, Danbooru)
- Optional: kitty (installed automatically on request), Homebrew for Starship/eza/bat/zoxide, Kvantum

Everything is installed into your user profile – **no root rights needed**. Only the login-screen wallpaper asks for your password once.

## Installation

**The easy way (recommended):**

1. Download **AnimeStage.zip** from the [latest release](https://github.com/propanisen/AnimeStage/releases/latest).
2. Extract it (right-click → *Extract here*).
3. Double-click **Install AnimeStage** in the folder and follow the windows: language, panel, anime – done.

**One line in the terminal:**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**With git (for developers):**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # show what will happen (changes nothing)
./install.sh                 # install (a backup of your KDE settings is made first)
```

Options:

```bash
./install.sh --anime "Frieren"   # start right away with an anime
./install.sh --lang ja           # language for installer and theme
./install.sh --profile core      # keep your current panel layout
```

Then open **Start menu → AnimeStage Control Center → Anime** and search for your anime.

### Update

AnimeStage checks GitHub once a day for a new release and shows a notification. Install it with one click in **Control Center → System → Updates** (or `animestage update install`). The notification has an **Install now** button – or let updates install automatically (setting there). A backup is made before every update. Don't want the check? Untick it there or run `animestage update off`.

Updating by hand from a git clone:

```bash
git pull
./update.sh          # your settings, favorites and panel stay as they are
```

### Uninstall

**The easy way:** Control Center → System → **Uninstall AnimeStage …** – a window asks first and restores everything.

**In the terminal:**

```bash
./uninstall.sh            # removes everything and restores your original KDE settings
./uninstall.sh --purge    # also deletes downloaded images and the config
```

**What happens on install and uninstall:** before changing anything, the installer saves your KDE settings (panel, colors, window decoration, fonts, lock screen, splash screen …) to `~/.local/state/animestage/backups/original`. Uninstalling removes every AnimeStage file and timer, undoes the changes to the terminal, Firefox, VS Code and the login screen, and then restores that backup – your desktop looks exactly like before. Panel changes you made after installing are reset as well. The backups themselves are kept.

## Content filter

AnimeStage is **safe by default** (filter “Strict”).

- **SFW** shows all characters of the anime.
- **Ecchi / NSFW** can be enabled, but **only ever shows adult characters**: the age must come from AniList (18+), or you mark a character yourself – which is only possible if AniList gives no age or a fantasy age like “1000+”. Characters who are minors according to AniList can never be unlocked.
- Revealing images are only used if no other character is in the picture and no tag suggests someone younger.
- **Lock screen, login screen, terminal and Firefox always show “safe” images only.**
- These rules are checked by a self-test; the installer refuses to install if they were removed or weakened.

You can also show **female characters only** (Control Center → Anime).

## Command line

```bash
animestage search frieren            # AniList search
animestage anime 154587 --apply      # use an anime
animestage wall next | fav | ban     # next wallpaper, save as favorite, never show again
animestage set wallswitch.minutes 60 # rotation interval
animestage themed new terminal --tags "night, city"   # custom search for the terminal background
animestage source check              # are the image sites reachable?
animestage status
animestage --help
```

## Image sources & adding your own

All searching and downloading of images lives in one file: [`lib/animestage_sources.py`](lib/animestage_sources.py).
If a site goes offline or you want another one, add it there (`SOURCES` and `PURPOSES`) and run `./update.sh` – it then appears in the Control Center under **System → Image sources**. Ready-made adapters exist for Moebooru (Konachan, yande.re), Danbooru and Gelbooru-style sites.

## Translations

Translations live in [`i18n/`](i18n/) – one JSON file per language, German source text → translation.
`tools/i18n-extract.py` lists missing texts. Corrections and new languages are very welcome!

## Credits

- Anime data: [AniList](https://anilist.co) · Wallpapers: [Konachan](https://konachan.net) · Cutouts: [Danbooru](https://danbooru.donmai.us) (AI-generated images are banned there)
- Font: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Icons: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage does not ship any anime images – everything is downloaded when you choose an anime. Artists are shown in the Control Center (hover an image). All characters © their respective owners. This is a non-commercial fan project and not affiliated with any of the services above.

Made by **propanisen** together with **Claude Opus 5.5** (Anthropic) – design, code and translations were created in conversation with the AI.

## License

[GPL-3.0](LICENSE)
