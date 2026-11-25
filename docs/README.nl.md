# AnimeStage

**Maak van je KDE Plasma 6-bureaublad je favoriete anime.**
Typ een anime in – AnimeStage bouwt het hele bureaublad eromheen: wisselende achtergronden, overal passende kleuren, personages in het startmenu en een terminal, Firefox en VS Code in thema.

🌐 [English](../README.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · [Español](README.es.md) · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · [Polski](README.pl.md) · **Nederlands** · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![AnimeStage-bureaublad met Frieren-achtergrond en het AnimeStage-paneel](screenshots/desktop.jpg)

## Functies

- **Elke anime** – zoeken via AniList; titel, banner en personages (met leeftijd) komen automatisch.
- **Wisselende achtergronden** – nieuwe afbeeldingen van Konachan elke 2 uur (instelbaar), per personage, filter en sfeer. Favorieten bewaren of afbeeldingen weggooien.
- **Kleuren volgen de achtergrond** – de accentkleuren van elke nieuwe afbeelding gaan naar Plasma, vensterdecoratie, pictogrammen (Papirus-mappen), terminal, Firefox en VS Code.
- **Paneel in animestijl** – startmenu met een uitsnede van een personage, taakbeheer met venstertitels, muziekpil, CPU/RAM/GPU-ringen en kalender.
- **Terminal** – kitty of Konsole in themakleuren, begroeting met een nieuwe afbeelding + systeeminfo, Starship-prompt en desgewenst een afbeelding als terminalachtergrond.
- **Firefox** – tabbladen en adresbalk in passende kleuren, plus een afbeelding op de nieuw-tabbladpagina die bij elke start wisselt.
- **Vergrendel- en aanmeldscherm** tonen ook je achtergrond (aanmelden: Plasma Login Manager).
- **Controlecentrum** – alles in één venster, geen configuratiebestanden nodig.
- **13 talen** – volgt de systeemtaal, te wijzigen in het Controlecentrum.

### Taakbalk zoals in Windows

![Taakbalk met venstertitels](screenshots/taskbar.png)

Elk venster krijgt een eigen item met de titel naast het pictogram – twee Firefox-vensters zijn twee items. Vastgezette programma's blijven waar je ze hebt gezet, en hun vensters openen precies daar. In **Controlecentrum → Uiterlijk → Taakbeheer** kun je titels uitzetten, vensters groeperen of de breedte kiezen (smal / middel / breed).

### Achtergronden & kleuren

![Drie achtergronden, elk met de kleuren die AnimeStage eruit haalt](screenshots/wallpapers.jpg)

Elke nieuwe achtergrond brengt zijn eigen kleuren mee: AnimeStage haalt de accent- en achtergrondkleuren uit de afbeelding en kleurt paneel, vensters, pictogrammen, terminal, Firefox en VS Code opnieuw in – automatisch elke 2 uur. Het paneel onderaan elke afbeelding toont de kleuren van die afbeelding.

### Startmenu, kalender & systeembelasting

![AnimeStage: startmenu, kalender en systeembelasting](screenshots/preview.png)

| Controlecentrum – anime & personages | Controlecentrum – achtergrond |
|---|---|
| ![Controlecentrum: anime](screenshots/control-anime.png) | ![Controlecentrum: achtergrond](screenshots/control-wallpaper.png) |

## Vereisten

- **KDE Plasma 6** (gemaakt en getest op Bazzite / Fedora Atomic met Plasma 6.8; andere distributies met Plasma 6 zouden moeten werken)
- Python 3 met **Pillow** (`python3-pillow`)
- Een internetverbinding (AniList, Konachan, Danbooru)
- Optioneel: kitty (wordt op verzoek automatisch geïnstalleerd), Homebrew voor Starship/eza/bat/zoxide, Kvantum

Alles wordt in je gebruikersprofiel geïnstalleerd – **geen rootrechten nodig**. Alleen de achtergrond van het aanmeldscherm vraagt één keer je wachtwoord.

## Installatie

**De makkelijke manier (aanbevolen):**

1. Download **AnimeStage.zip** uit de [nieuwste release](https://github.com/propanisen/AnimeStage/releases/latest).
2. Pak het uit (rechtsklik → *Hier uitpakken*).
3. Dubbelklik in de map op **AnimeStage installeren** en volg de vensters: taal, paneel, anime – klaar.

**Eén regel in de terminal:**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**Met git (voor ontwikkelaars):**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # laat zien wat er gebeurt (verandert niets)
./install.sh                 # installeren (eerst wordt een back-up van je KDE-instellingen gemaakt)
```

Opties:

```bash
./install.sh --anime "Frieren"   # meteen met een anime beginnen
./install.sh --lang nl           # taal van installatie en thema
./install.sh --profile core      # je huidige paneel behouden
```

Open daarna **Startmenu → AnimeStage-controlecentrum → Anime** en zoek je anime.

### Bijwerken

AnimeStage kijkt één keer per dag op GitHub of er een nieuwe versie is en toont een melding. Installeer die met één klik in **Controlecentrum → Systeem → Updates** (of `animestage update install`). De melding heeft een knop **Nu installeren** – of laat updates automatisch installeren (instelling op dezelfde plek). Voor elke update wordt een back-up gemaakt. Geen controle gewenst? Vink het daar uit of voer `animestage update off` uit.

Handmatig bijwerken vanuit een git-kloon:

```bash
git pull
./update.sh          # instellingen, favorieten en paneel blijven zoals ze zijn
```

### Verwijderen

**De makkelijke manier:** Controlecentrum → Systeem → **AnimeStage verwijderen …** – een venster vraagt het eerst en zet alles terug.

**In de terminal:**

```bash
./uninstall.sh            # verwijdert alles en zet je oorspronkelijke KDE-instellingen terug
./uninstall.sh --purge    # verwijdert ook gedownloade afbeeldingen en de configuratie
```

**Wat er gebeurt bij installeren en verwijderen:** voordat er iets verandert, bewaart de installer je KDE-instellingen (paneel, kleuren, vensterdecoratie, lettertypen, vergrendelscherm, opstartscherm …) in `~/.local/state/animestage/backups/original`. Verwijderen haalt alle AnimeStage-bestanden en -timers weg, maakt de wijzigingen aan terminal, Firefox, VS Code en inlogscherm ongedaan en zet daarna die back-up terug – je bureaublad ziet er precies zo uit als vroeger. Wijzigingen aan het paneel na de installatie worden ook teruggezet. De back-ups zelf blijven bewaard.

## Inhoudsfilter

AnimeStage is **standaard geschikt voor iedereen** (filter ‘Streng’).

- **SFW** toont alle personages van de anime.
- **Ecchi / NSFW** kan worden ingeschakeld, maar **toont uitsluitend volwassen personages**: de leeftijd moet van AniList komen (18+), of je markeert een personage zelf – alleen mogelijk als AniList geen leeftijd of een fantasieleeftijd zoals ‘1000+’ geeft. Personages die volgens AniList minderjarig zijn, kunnen nooit worden vrijgegeven.
- Onthullende afbeeldingen worden alleen gebruikt als er geen ander personage op de afbeelding staat en geen tag op iemand jongers wijst.
- **Vergrendelscherm, aanmeldscherm, terminal en Firefox tonen altijd alleen ‘safe’-afbeeldingen.**
- Een zelftest controleert deze regels; de installatie weigert als ze zijn verwijderd of afgezwakt.

Je kunt ook **alleen vrouwelijke personages** tonen (Controlecentrum → Anime).

## Opdrachtregel

```bash
animestage search frieren            # zoeken op AniList
animestage anime 154587 --apply      # een anime gebruiken
animestage wall next | fav | ban     # volgende achtergrond, als favoriet bewaren, nooit meer tonen
animestage set wallswitch.minutes 60 # wisselinterval
animestage themed new terminal --tags "night, city"   # eigen zoekopdracht voor de terminalachtergrond
animestage source check              # zijn de afbeeldingssites bereikbaar?
animestage status
animestage --help
```

## Afbeeldingsbronnen & eigen bronnen toevoegen

Al het zoeken en downloaden van afbeeldingen zit in één bestand: [`lib/animestage_sources.py`](../lib/animestage_sources.py).
Valt een site uit of wil je een andere, voeg die daar toe (`SOURCES` en `PURPOSES`) en voer `./update.sh` uit – dan verschijnt hij in het Controlecentrum onder **Systeem → Afbeeldingsbronnen**. Er zijn kant-en-klare adapters voor Moebooru (Konachan, yande.re), Danbooru en Gelbooru-achtige sites.

## Vertalingen

De vertalingen staan in [`i18n/`](../i18n/) – één JSON-bestand per taal, Duitse brontekst → vertaling.
`tools/i18n-extract.py` toont ontbrekende teksten. Correcties en nieuwe talen zijn van harte welkom!

## Dankwoord

- Animegegevens: [AniList](https://anilist.co) · Achtergronden: [Konachan](https://konachan.net) · Uitsnedes: [Danbooru](https://danbooru.donmai.us) (AI-afbeeldingen zijn daar verboden)
- Lettertype: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Pictogrammen: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage bevat geen animeafbeeldingen – alles wordt gedownload zodra je een anime kiest. De artiesten staan in het Controlecentrum (beweeg over een afbeelding). Alle personages © hun rechthebbenden. Niet-commercieel fanproject, niet verbonden aan de genoemde diensten.

Gemaakt door **propanisen** samen met **Claude Opus 5.5** (Anthropic) – ontwerp, code en vertalingen zijn in gesprek met de AI ontstaan.

## Licentie

[GPL-3.0](../LICENSE)
