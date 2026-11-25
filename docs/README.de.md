# AnimeStage

**Mach deinen KDE-Plasma-6-Desktop zu deinem Lieblingsanime.**
Du gibst einen Anime ein – AnimeStage baut den ganzen Desktop darum: wechselnde Hintergründe, passende Farben überall, Figuren im Startmenü, ein Terminal im Theme, Firefox und VS Code.

🌐 [English](../README.md) · **Deutsch** · [日本語](README.ja.md) · [Français](README.fr.md) · [Español](README.es.md) · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![AnimeStage-Desktop mit Frieren-Hintergrund und dem AnimeStage-Panel](screenshots/desktop.jpg)

## Funktionen

- **Jeden Anime wählen** – Suche über AniList; Titel, Banner und Figuren (mit Alter) kommen automatisch.
- **Wechselnde Hintergründe** – neue Bilder von Konachan alle 2 Stunden (einstellbar), nach Figur, Filter und Stimmung. Favoriten merken oder Bilder aussortieren.
- **Farben folgen dem Hintergrund** – Akzentfarben aus jedem neuen Bild für Plasma, Fensterrahmen, Icons (Papirus-Ordner), Terminal, Firefox und VS Code.
- **Panel im Anime-Stil** – Startmenü mit Figur, Taskleiste mit Fensternamen, Musik-Pille, CPU/RAM/GPU-Ringe und Kalender.
- **Terminal** – kitty oder Konsole in Theme-Farben, Begrüßung mit frischem Bild + Systeminfo, Starship-Prompt und auf Wunsch ein Bild als Terminal-Hintergrund.
- **Firefox** – Tabs und Adressleiste in passenden Farben, dazu ein Neuer-Tab-Bild, das bei jedem Start wechselt.
- **Sperr- und Anmeldebildschirm** zeigen ebenfalls deinen Hintergrund (Anmeldung: Plasma Login Manager).
- **Kontrollzentrum** – alles in einem Fenster, keine Config-Dateien nötig.
- **13 Sprachen** – folgt der Systemsprache, im Kontrollzentrum umstellbar.

### Taskleiste wie bei Windows

![Taskleiste mit Fensternamen](screenshots/taskbar.png)

Jedes Fenster bekommt einen eigenen Eintrag mit seinem Namen neben dem Symbol – zwei Firefox-Fenster sind zwei Einträge. Angeheftete Programme bleiben an ihrem Platz, ihre Fenster öffnen sich genau dort. Unter **Kontrollzentrum → Oberfläche → Taskleiste** kannst du die Namen ausschalten, Fenster gruppieren oder die Breite wählen (schmal / mittel / breit).

### Hintergründe & Farben

![Drei Hintergründe, jeweils mit den Farben, die AnimeStage daraus nimmt](screenshots/wallpapers.jpg)

Jeder neue Hintergrund bringt seine eigenen Farben mit: AnimeStage nimmt Akzent- und Hintergrundfarben aus dem Bild und färbt Panel, Fenster, Symbole, Terminal, Firefox und VS Code neu ein – automatisch alle 2 Stunden. Das Panel unten in jedem Bild zeigt die Farben genau dieses Bildes.

### Startmenü, Kalender & Auslastung

![AnimeStage: Startmenü, Kalender und Auslastung](screenshots/preview.png)

| Kontrollzentrum – Anime & Figuren | Kontrollzentrum – Hintergrund |
|---|---|
| ![Kontrollzentrum: Anime](screenshots/control-anime.png) | ![Kontrollzentrum: Hintergrund](screenshots/control-wallpaper.png) |

## Voraussetzungen

- **KDE Plasma 6** (entwickelt und getestet auf Bazzite / Fedora Atomic mit Plasma 6.8; andere Distributionen mit Plasma 6 sollten funktionieren)
- Python 3 mit **Pillow** (`python3-pillow`)
- Internetverbindung (AniList, Konachan, Danbooru)
- Optional: kitty (wird auf Wunsch automatisch installiert), Homebrew für Starship/eza/bat/zoxide, Kvantum

Alles landet in deinem Benutzerprofil – **keine Root-Rechte nötig**. Nur für den Anmeldebildschirm wird einmal das Passwort abgefragt.

## Installation

**Der einfache Weg (empfohlen):**

1. **AnimeStage.zip** aus dem [neuesten Release](https://github.com/propanisen/AnimeStage/releases/latest) herunterladen.
2. Entpacken (Rechtsklick → *Hierher entpacken*).
3. Im Ordner doppelt auf **AnimeStage installieren** klicken und den Fenstern folgen: Sprache, Panel, Anime – fertig.

**Eine Zeile im Terminal:**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**Mit git (für Entwickler):**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # zeigt, was passiert (ändert nichts)
./install.sh                 # installieren (vorher wird ein Backup deiner KDE-Einstellungen angelegt)
```

Optionen:

```bash
./install.sh --anime "Frieren"   # gleich mit einem Anime starten
./install.sh --lang de           # Sprache für Installer und Theme
./install.sh --profile core      # dein aktuelles Panel behalten
```

Danach **Startmenü → AnimeStage Kontrollzentrum → Anime** öffnen und deinen Anime suchen.

### Update

AnimeStage schaut einmal am Tag auf GitHub nach einer neuen Version und zeigt eine Benachrichtigung. Installiert wird sie mit einem Klick unter **Kontrollzentrum → System → Updates** (oder `animestage update install`). Die Benachrichtigung hat einen Knopf **Jetzt installieren** – oder Updates installieren sich automatisch (Einstellung dort). Vor jedem Update wird ein Backup angelegt. Du willst keine Prüfung? Dort einfach abhaken oder `animestage update off`.

Von Hand aus einem git-Klon aktualisieren:

```bash
git pull
./update.sh          # Einstellungen, Favoriten und Panel bleiben erhalten
```

### Deinstallieren

**Der einfache Weg:** Kontrollzentrum → System → **AnimeStage deinstallieren …** – ein Fenster fragt vorher nach und stellt alles wieder her.

**Im Terminal:**

```bash
./uninstall.sh            # entfernt alles und stellt deine ursprünglichen KDE-Einstellungen wieder her
./uninstall.sh --purge    # löscht zusätzlich geladene Bilder und die Config
```

**Was bei Installation und Deinstallation passiert:** Bevor irgendetwas geändert wird, sichert der Installer deine KDE-Einstellungen (Panel, Farben, Fensterrahmen, Schriften, Sperrbildschirm, Startbildschirm …) nach `~/.local/state/animestage/backups/original`. Die Deinstallation entfernt alle AnimeStage-Dateien und -Timer, macht die Änderungen an Terminal, Firefox, VS Code und Anmeldebildschirm rückgängig und spielt danach dieses Backup zurück – dein Desktop sieht genau aus wie vorher. Änderungen am Panel, die du nach der Installation gemacht hast, werden dabei ebenfalls zurückgesetzt. Die Backups selbst bleiben erhalten.

## Inhaltsfilter

AnimeStage ist **standardmäßig jugendfrei** (Filter „Streng“).

- **SFW** zeigt alle Figuren des Anime.
- **Ecchi / NSFW** lässt sich einschalten, zeigt aber **ausschließlich volljährige Figuren**: Das Alter muss von AniList kommen (18+), oder du markierst eine Figur selbst – das geht nur, wenn AniList kein Alter oder ein Fantasy-Alter wie „1000+“ angibt. Figuren, die laut AniList minderjährig sind, lassen sich nie freischalten.
- Freizügige Bilder werden nur genommen, wenn keine andere Figur mit im Bild ist und kein Tag auf Jüngere hindeutet.
- **Sperrbildschirm, Anmeldebildschirm, Terminal und Firefox zeigen immer nur „safe“-Bilder.**
- Ein Selbsttest prüft diese Regeln; der Installer bricht ab, wenn sie entfernt oder abgeschwächt wurden.

Auf Wunsch zeigt AnimeStage **nur weibliche Figuren** (Kontrollzentrum → Anime).

## Kommandozeile

```bash
animestage search frieren            # AniList-Suche
animestage anime 154587 --apply      # Anime übernehmen
animestage wall next | fav | ban     # nächstes Bild, als Favorit merken, nie wieder zeigen
animestage set wallswitch.minutes 60 # Wechselintervall
animestage themed new terminal --tags "night, city"   # eigene Suche für den Terminal-Hintergrund
animestage source check              # sind die Bildseiten erreichbar?
animestage status
animestage --help
```

## Bildquellen & eigene Quellen

Alles Suchen und Laden von Bildern steckt in einer Datei: [`lib/animestage_sources.py`](../lib/animestage_sources.py).
Fällt eine Seite aus oder willst du eine andere, trag sie dort ein (`SOURCES` und `PURPOSES`) und führe `./update.sh` aus – dann erscheint sie im Kontrollzentrum unter **System → Bildquellen**. Fertige Anbindungen gibt es für Moebooru (Konachan, yande.re), Danbooru und Gelbooru-artige Seiten.

## Übersetzungen

Die Übersetzungen liegen in [`i18n/`](../i18n/) – eine JSON-Datei pro Sprache, deutscher Quelltext → Übersetzung.
`tools/i18n-extract.py` zeigt fehlende Texte. Korrekturen und neue Sprachen sind sehr willkommen!

## Danksagung

- Anime-Daten: [AniList](https://anilist.co) · Hintergründe: [Konachan](https://konachan.net) · Freisteller: [Danbooru](https://danbooru.donmai.us) (KI-Bilder sind dort verboten)
- Schrift: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Icons: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage enthält keine Anime-Bilder – alles wird erst geladen, wenn du einen Anime wählst. Die Künstler:innen stehen im Kontrollzentrum (Maus über ein Bild). Alle Figuren © ihrer Rechteinhaber. Nicht-kommerzielles Fan-Projekt, nicht mit den genannten Diensten verbunden.

Gemacht von **propanisen** zusammen mit **Claude Opus 5.5** (Anthropic) – Design, Code und Übersetzungen sind im Gespräch mit der KI entstanden.

## Lizenz

[GPL-3.0](../LICENSE)
