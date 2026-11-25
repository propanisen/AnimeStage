# AnimeStage

**Dein KDE-Plasma-6-Desktop im Look deines Lieblingsanime.**
Anime eintippen – AnimeStage gestaltet den ganzen Desktop drumherum: wechselnde Hintergründe, überall passende Farben, Figuren im Startmenü und dazu Terminal, Firefox und VS Code im selben Stil.

🌐 [English](../README.md) · **Deutsch** · [日本語](README.ja.md) · [Français](README.fr.md) · [Español](README.es.md) · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![AnimeStage-Desktop mit Frieren-Hintergrund und AnimeStage-Panel](screenshots/desktop.jpg)

## Funktionen

- **Jeder Anime geht** – Suche über AniList; Titel, Banner und Figuren (mit Alter) kommen automatisch.
- **Wechselnde Hintergründe** – alle 2 Stunden (einstellbar) neue Bilder von Konachan, passend zu Figur, Filter und Stimmung. Lieblingsbilder merken, unpassende aussortieren.
- **Farben passen sich an** – aus jedem neuen Bild werden die Akzentfarben genommen: für Plasma, Fensterrahmen, Ordnersymbole (Papirus), Terminal, Firefox und VS Code.
- **Panel im Anime-Stil** – Startmenü mit Figur, Taskleiste mit Fensternamen wie bei Windows, Musik-Player, CPU/RAM/GPU-Ringe und Kalender.
- **Terminal** – kitty oder Konsole in den Theme-Farben, Begrüßung mit frischem Bild und Systeminfo, Starship-Prompt und auf Wunsch ein Bild als Hintergrund.
- **Firefox** – Tabs und Adressleiste in passenden Farben, dazu bei jedem Start ein neues Bild auf der Neuer-Tab-Seite.
- **Sperr- und Anmeldebildschirm** zeigen ebenfalls deinen Hintergrund (Anmeldung: Plasma Login Manager).
- **Kontrollzentrum** – alles in einem Fenster einstellbar, ohne Config-Dateien.
- **13 Sprachen** – richtet sich nach der Systemsprache, im Kontrollzentrum umstellbar.

### Taskleiste wie bei Windows

![Taskleiste mit Fensternamen](screenshots/taskbar.png)

Jedes Fenster bekommt einen eigenen Eintrag mit seinem Namen neben dem Symbol – zwei Firefox-Fenster sind zwei Einträge. Angeheftete Programme bleiben an ihrem Platz, ihre Fenster öffnen sich genau dort. Unter **Kontrollzentrum → Oberfläche → Taskleiste** lassen sich die Namen ausblenden, Fenster gruppieren oder die Breite wählen (schmal / mittel / breit).

### Hintergründe & Farben

![Drei Hintergründe mit den Farben, die AnimeStage jeweils daraus nimmt](screenshots/wallpapers.jpg)

Jeder neue Hintergrund bringt seine eigenen Farben mit: AnimeStage nimmt Akzent- und Hintergrundfarbe aus dem Bild und färbt Panel, Fenster, Symbole, Terminal, Firefox und VS Code neu ein – automatisch alle 2 Stunden. Das Panel unten in jedem Bild zeigt die Farben genau dieses Bildes.

### Startmenü, Kalender & Auslastung

![AnimeStage: Startmenü, Kalender und Auslastung](screenshots/preview.png)

| Kontrollzentrum – Anime & Figuren | Kontrollzentrum – Hintergrund |
|---|---|
| ![Kontrollzentrum: Anime](screenshots/control-anime.png) | ![Kontrollzentrum: Hintergrund](screenshots/control-wallpaper.png) |

## Voraussetzungen

- **KDE Plasma 6** (entwickelt und getestet auf Bazzite / Fedora Atomic mit Plasma 6.8; andere Distributionen mit Plasma 6 sollten genauso laufen)
- Python 3 mit **Pillow** (`python3-pillow`)
- Internetverbindung (AniList, Konachan, Danbooru)
- Optional: kitty (wird auf Wunsch automatisch installiert), Homebrew für Starship/eza/bat/zoxide, Kvantum

Alles landet in deinem Benutzerprofil – **keine Root-Rechte nötig**. Nur für den Anmeldebildschirm wird einmal dein Passwort abgefragt.

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
./install.sh --plan          # zeigt, was passieren würde (ändert nichts)
./install.sh                 # installieren (vorher wird ein Backup deiner KDE-Einstellungen angelegt)
```

Optionen:

```bash
./install.sh --anime "Frieren"   # gleich mit einem Anime starten
./install.sh --lang de           # Sprache für Installer und Theme
./install.sh --profile core      # dein jetziges Panel behalten
```

Danach **Startmenü → AnimeStage Kontrollzentrum → Anime** öffnen und deinen Anime suchen.

### Update

AnimeStage schaut einmal am Tag auf GitHub nach einer neuen Version und meldet sich mit einer Benachrichtigung. Mit **Jetzt installieren** ist das Update in einem Klick erledigt – alternativ unter **Kontrollzentrum → System → Updates** oder mit `animestage update install`. Dort lässt sich auch einstellen, dass Updates automatisch installiert werden. Vor jedem Update wird ein Backup angelegt. Keine Prüfung gewünscht? Dort auf „Aus“ stellen oder `animestage update off`.

Von Hand aus einem git-Klon aktualisieren:

```bash
git pull
./update.sh          # Einstellungen, Favoriten und Panel bleiben, wie sie sind
```

### Deinstallation

**Der einfache Weg:** Kontrollzentrum → System → **AnimeStage deinstallieren …** – ein Fenster fragt vorher nach und stellt alles wieder her.

**Im Terminal:**

```bash
./uninstall.sh            # entfernt alles und stellt deine ursprünglichen KDE-Einstellungen wieder her
./uninstall.sh --purge    # löscht zusätzlich heruntergeladene Bilder und die Config
```

**Was bei Installation und Deinstallation passiert:** Bevor irgendetwas geändert wird, sichert der Installer deine KDE-Einstellungen (Panel, Farben, Fensterrahmen, Schriften, Sperr- und Startbildschirm …) nach `~/.local/state/animestage/backups/original`. Die Deinstallation entfernt alle AnimeStage-Dateien und -Timer, nimmt die Änderungen an Terminal, Firefox, VS Code und Anmeldebildschirm zurück und spielt dann dieses Backup ein – dein Desktop sieht danach genau so aus wie vorher. Auch Änderungen am Panel, die du nach der Installation gemacht hast, werden dabei zurückgesetzt. Die Backups selbst bleiben erhalten.

## Inhaltsfilter

AnimeStage ist **von Haus aus jugendfrei** (Filter „Streng“).

- **SFW** zeigt alle Figuren des Anime.
- **Ecchi / NSFW** lässt sich einschalten, zeigt aber **ausschließlich volljährige Figuren**: Das Alter muss von AniList kommen (18+) oder von dir markiert sein – markieren geht nur, wenn AniList kein Alter oder nur ein Fantasy-Alter wie „1000+“ angibt. Figuren, die laut AniList minderjährig sind, lassen sich nie freischalten.
- Freizügige Bilder werden nur genommen, wenn keine andere Figur mit im Bild ist und kein Tag auf jemand Jüngeren hindeutet.
- **Sperrbildschirm, Anmeldebildschirm, Terminal und Firefox zeigen immer nur „safe“-Bilder.**
- Ein Selbsttest prüft diese Regeln; fehlen sie oder wurden sie abgeschwächt, verweigert der Installer die Installation.

Auf Wunsch zeigt AnimeStage **nur weibliche Figuren** (Kontrollzentrum → Anime).

## Kommandozeile

```bash
animestage search frieren            # auf AniList suchen
animestage anime 154587 --apply      # Anime übernehmen
animestage wall next | fav | ban     # nächster Hintergrund, als Favorit merken, nie wieder zeigen
animestage set wallswitch.minutes 60 # Wechselintervall
animestage themed new terminal --tags "night, city"   # eigene Suche für den Terminal-Hintergrund
animestage source check              # sind die Bilderseiten erreichbar?
animestage status
animestage --help
```

## Bildquellen & eigene Quellen

Die komplette Bildsuche samt Download steckt in einer Datei: [`lib/animestage_sources.py`](../lib/animestage_sources.py).
Ist eine Seite offline oder willst du eine andere nutzen, trag sie dort ein (`SOURCES` und `PURPOSES`) und starte `./update.sh` – danach steht sie im Kontrollzentrum unter **System → Bildquellen** zur Auswahl. Fertige Adapter gibt es für Moebooru (Konachan, yande.re), Danbooru und Gelbooru-artige Seiten.

## Übersetzungen

Die Übersetzungen liegen in [`i18n/`](../i18n/) – eine JSON-Datei pro Sprache (deutscher Quelltext → Übersetzung).
`tools/i18n-extract.py` zeigt fehlende Texte. Verbesserungen und neue Sprachen sind sehr willkommen!

## Credits

- Anime-Daten: [AniList](https://anilist.co) · Hintergründe: [Konachan](https://konachan.net) · Freisteller: [Danbooru](https://danbooru.donmai.us) (KI-Bilder sind dort verboten)
- Schrift: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Icons: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage enthält selbst keine Anime-Bilder – alles wird erst geladen, wenn du einen Anime wählst. Die Künstler:innen stehen im Kontrollzentrum (mit der Maus über ein Bild fahren). Alle Figuren © ihrer Rechteinhaber. Nichtkommerzielles Fanprojekt, ohne Verbindung zu den oben genannten Diensten.

Gemacht von **propanisen** zusammen mit **Claude Opus 5.5** (Anthropic) – Design, Code und Übersetzungen sind im Gespräch mit der KI entstanden.

## Lizenz

[GPL-3.0](../LICENSE)
