# AnimeStage

**Dein KDE-Plasma-6-Desktop im Stil deines Lieblingsanimes.**
Du gibst einen Anime ein, und AnimeStage gestaltet den ganzen Desktop passend dazu: Die Hintergründe wechseln regelmäßig, die Farben passen überall zusammen, im Startmenü erscheinen die Figuren, und auch Terminal, Firefox und VS Code bekommen denselben Look.

🌐 [English](../README.md) · **Deutsch** · [日本語](README.ja.md) · [Français](README.fr.md) · [Español](README.es.md) · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![AnimeStage-Desktop mit Frieren-Hintergrund und AnimeStage-Panel](screenshots/desktop.jpg)

## Funktionen

- **Beliebiger Anime:** Du suchst deinen Anime über AniList. Titel, Banner und Figuren samt Alter holt AnimeStage automatisch.
- **Wechselnde Hintergründe:** Alle zwei Stunden (einstellbar) kommt ein neues Bild von Konachan, passend zu Figur, Filter und Stimmung. Bilder, die dir gefallen, speicherst du als Favoriten; alle anderen kannst du aussortieren.
- **Farben passend zum Hintergrund:** AnimeStage übernimmt die Farben jedes neuen Bildes für Plasma, Fensterrahmen, Ordnersymbole (Papirus), Terminal, Firefox und VS Code.
- **Panel im Anime-Stil:** Dazu gehören ein Startmenü mit Figur, eine Taskleiste mit Fensternamen wie bei Windows, ein Musikplayer, Auslastungsringe für CPU, RAM und GPU sowie ein Kalender.
- **Terminal:** kitty oder Konsole erscheinen in den Theme-Farben, mit einer Begrüßung samt Bild und Systeminfos, einem Starship-Prompt und auf Wunsch einem Hintergrundbild.
- **Firefox:** Tabs und Adressleiste bekommen passende Farben, und auf der Seite „Neuer Tab“ erscheint bei jedem Start ein neues Bild.
- **Sperr- und Anmeldebildschirm** zeigen ebenfalls deinen Hintergrund (beim Anmeldebildschirm über den Plasma Login Manager).
- **Kontrollzentrum:** Alle Einstellungen findest du in einem Fenster – Konfigurationsdateien musst du nicht anfassen.
- **13 Sprachen:** AnimeStage übernimmt die Sprache deines Systems; im Kontrollzentrum kannst du sie jederzeit ändern.

### Taskleiste wie bei Windows

![Taskleiste mit Fensternamen](screenshots/taskbar.png)

Jedes Fenster bekommt einen eigenen Eintrag, neben dem Symbol steht sein Name. Zwei offene Firefox-Fenster ergeben also zwei Einträge. Angeheftete Programme bleiben an ihrem Platz, und ihre Fenster öffnen sich genau dort. Unter **Kontrollzentrum → Oberfläche → Taskleiste** kannst du die Namen ausblenden, Fenster gruppieren oder die Breite der Einträge ändern (schmal, mittel oder breit).

### Hintergründe und Farben

![Drei Hintergründe mit den Farben, die AnimeStage jeweils daraus übernimmt](screenshots/wallpapers.jpg)

Jeder neue Hintergrund bringt seine eigenen Farben mit. AnimeStage übernimmt Akzent- und Hintergrundfarbe aus dem Bild und färbt damit Panel, Fenster, Symbole, Terminal, Firefox und VS Code ein – automatisch alle zwei Stunden. Das Panel unten in jedem Beispiel zeigt die Farben, die aus genau diesem Bild stammen.

### Startmenü, Kalender und Auslastung

![AnimeStage: Startmenü, Kalender und Auslastung](screenshots/preview.png)

| Kontrollzentrum – Anime und Figuren | Kontrollzentrum – Hintergrund |
|---|---|
| ![Kontrollzentrum: Anime](screenshots/control-anime.png) | ![Kontrollzentrum: Hintergrund](screenshots/control-wallpaper.png) |

## Voraussetzungen

- **KDE Plasma 6** (entwickelt und getestet unter Bazzite / Fedora Atomic mit Plasma 6.8; andere Distributionen mit Plasma 6 sollten ebenfalls funktionieren)
- Python 3 mit **Pillow** (`python3-pillow`)
- eine Internetverbindung (für AniList, Konachan und Danbooru)
- optional: kitty (installiert AnimeStage auf Wunsch selbst), Homebrew für Starship, eza, bat und zoxide sowie Kvantum

AnimeStage installiert alles in dein Benutzerprofil, **Root-Rechte brauchst du nicht**. Nur für den Hintergrund des Anmeldebildschirms wirst du einmal nach deinem Passwort gefragt.

## Installation

**Der einfache Weg (empfohlen):**

1. Lade **AnimeStage.zip** aus dem [neuesten Release](https://github.com/propanisen/AnimeStage/releases/latest) herunter.
2. Entpacke die Datei (Rechtsklick → *Hierher entpacken*).
3. Klicke im Ordner doppelt auf **AnimeStage installieren** und folge den Fenstern: Sprache, Panel und Anime auswählen – fertig.

**Mit einer Zeile im Terminal:**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**Mit git (für Entwickler):**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # zeigt, was passieren würde, ohne etwas zu ändern
./install.sh                 # installiert (vorher wird ein Backup deiner KDE-Einstellungen angelegt)
```

Optionen:

```bash
./install.sh --anime "Frieren"   # direkt mit einem Anime starten
./install.sh --lang de           # Sprache für Installer und Theme festlegen
./install.sh --profile core      # dein bisheriges Panel behalten
```

Öffne danach **Startmenü → AnimeStage Kontrollzentrum → Anime** und such dir deinen Anime aus.

### Updates

AnimeStage prüft einmal am Tag, ob es auf GitHub eine neue Version gibt, und meldet sich dann mit einer Benachrichtigung. Ein Klick auf **Jetzt installieren** genügt. Alternativ installierst du das Update unter **Kontrollzentrum → System → Updates** oder mit `animestage update install`. Dort kannst du auch einstellen, dass Updates automatisch installiert werden. Vor jedem Update legt AnimeStage ein Backup an. Wenn du keine Prüfung möchtest, stellst du sie dort auf „Aus“ oder gibst `animestage update off` ein.

Wenn du mit git arbeitest, aktualisierst du so:

```bash
git pull
./update.sh          # Einstellungen, Favoriten und Panel bleiben erhalten
```

### Deinstallation

**Der einfache Weg:** Öffne Kontrollzentrum → System → **AnimeStage deinstallieren …**. Ein Fenster fragt noch einmal nach und stellt dann alles wieder her.

**Im Terminal:**

```bash
./uninstall.sh            # entfernt alles und stellt deine ursprünglichen KDE-Einstellungen wieder her
./uninstall.sh --purge    # löscht zusätzlich die heruntergeladenen Bilder und die Konfiguration
```

**Was bei Installation und Deinstallation passiert:** Bevor der Installer etwas ändert, sichert er deine KDE-Einstellungen (Panel, Farben, Fensterrahmen, Schriften, Sperr- und Startbildschirm usw.) unter `~/.local/state/animestage/backups/original`. Bei der Deinstallation werden alle Dateien und Timer von AnimeStage entfernt, die Änderungen an Terminal, Firefox, VS Code und Anmeldebildschirm rückgängig gemacht und anschließend dieses Backup wiederhergestellt. Dein Desktop sieht danach genauso aus wie vor der Installation. Beachte: Auch Änderungen am Panel, die du nach der Installation vorgenommen hast, gehen dabei verloren. Die Backups selbst bleiben erhalten.

## Inhaltsfilter

AnimeStage ist **standardmäßig jugendfrei** eingestellt (Filter „Streng“).

- **SFW** zeigt alle Figuren des Anime.
- **Ecchi / NSFW** kannst du einschalten, es werden dann aber **ausschließlich volljährige Figuren** gezeigt. Das Alter muss von AniList stammen (18 oder älter) oder von dir selbst markiert worden sein. Selbst markieren kannst du eine Figur nur, wenn AniList kein Alter oder nur ein Fantasy-Alter wie „1000+“ angibt. Figuren, die laut AniList minderjährig sind, lassen sich nicht freischalten.
- Freizügige Bilder werden nur verwendet, wenn keine weitere Figur zu sehen ist und kein Tag auf eine jüngere Person hindeutet.
- **Sperrbildschirm, Anmeldebildschirm, Terminal und Firefox zeigen grundsätzlich nur „safe“-Bilder.**
- Ein Selbsttest prüft diese Regeln. Wurden sie entfernt oder abgeschwächt, bricht der Installer die Installation ab.

Wenn du möchtest, zeigt AnimeStage **nur weibliche Figuren** an (Kontrollzentrum → Anime).

## Kommandozeile

```bash
animestage search frieren            # auf AniList suchen
animestage anime 154587 --apply      # Anime übernehmen
animestage wall next | fav | ban     # nächster Hintergrund, als Favorit speichern, nie wieder zeigen
animestage set wallswitch.minutes 60 # Wechselintervall in Minuten
animestage themed new terminal --tags "night, city"   # eigene Suche für den Terminal-Hintergrund
animestage source check              # prüfen, ob die Bildquellen erreichbar sind
animestage status
animestage --help
```

## Bildquellen und eigene Quellen

Die gesamte Bildsuche und der Download stecken in einer einzigen Datei: [`lib/animestage_sources.py`](../lib/animestage_sources.py).
Falls eine Seite offline ist oder du eine andere nutzen möchtest, trägst du sie dort ein (`SOURCES` und `PURPOSES`) und startest `./update.sh`. Anschließend kannst du sie im Kontrollzentrum unter **System → Bildquellen** auswählen. Fertige Anbindungen gibt es für Seiten nach dem Muster von Moebooru (Konachan, yande.re), Danbooru und Gelbooru.

## Übersetzungen

Die Übersetzungen liegen in [`i18n/`](../i18n/), eine JSON-Datei pro Sprache (deutscher Ausgangstext → Übersetzung).
Mit `tools/i18n-extract.py` siehst du, welche Texte noch fehlen. Verbesserungen und neue Sprachen sind sehr willkommen!

## Credits

- Anime-Daten: [AniList](https://anilist.co) · Hintergründe: [Konachan](https://konachan.net) · Freisteller: [Danbooru](https://danbooru.donmai.us) (dort sind KI-Bilder verboten)
- Schrift: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Symbole: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage enthält selbst keine Anime-Bilder. Alle Bilder werden erst heruntergeladen, wenn du einen Anime auswählst. Wer ein Bild gezeichnet hat, siehst du im Kontrollzentrum, wenn du mit der Maus darüberfährst. Alle Figuren © der jeweiligen Rechteinhaber. AnimeStage ist ein nichtkommerzielles Fanprojekt und steht in keiner Verbindung zu den genannten Diensten.

Entwickelt von **propanisen** zusammen mit **Claude Opus 5.5** (Anthropic) – Design, Code und Übersetzungen sind im Gespräch mit der KI entstanden.

## Lizenz

[GPL-3.0](../LICENSE)
