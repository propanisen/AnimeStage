# AnimeStage

**Je KDE Plasma 6-bureaublad in de stijl van je favoriete anime.**
Typ een anime in en AnimeStage bouwt het hele bureaublad eromheen: wisselende achtergronden, overal passende kleuren, personages in het startmenu en een terminal, Firefox en VS Code in dezelfde stijl.

🌐 [English](../README.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · [Español](README.es.md) · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · [Polski](README.pl.md) · **Nederlands** · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![AnimeStage-bureaublad met een Frieren-achtergrond en het AnimeStage-paneel](screenshots/desktop.jpg)

## Functies

- **Elke anime** – zoeken via AniList; titel, banner en personages (met leeftijd) worden vanzelf opgehaald.
- **Wisselende achtergronden** – elke 2 uur (instelbaar) nieuwe afbeeldingen van Konachan, passend bij personage, filter en sfeer. Bewaar je favorieten en zet de rest weg.
- **Kleuren volgen de achtergrond** – uit elke nieuwe afbeelding worden de accentkleuren gehaald voor Plasma, vensterdecoraties, mappictogrammen (Papirus), terminal, Firefox en VS Code.
- **Paneel in anime-stijl** – startmenu met personage, taakbalk met venstertitels zoals in Windows, muziekspeler, CPU/RAM/GPU-ringen en een agenda.
- **Terminal** – kitty of Konsole in de themakleuren, een begroeting met een verse afbeelding en systeeminfo, een Starship-prompt en desgewenst een afbeelding als achtergrond.
- **Firefox** – tabbladen en adresbalk in passende kleuren, plus bij elke start een nieuwe afbeelding op de pagina Nieuw tabblad.
- **Vergrendelscherm en aanmeldscherm** tonen ook je achtergrond (aanmelden: Plasma Login Manager).
- **Controlecentrum** – alles in één venster in te stellen, zonder configuratiebestanden.
- **13 talen** – volgt de systeemtaal en is te wijzigen in het Controlecentrum.

### Taakbalk zoals in Windows

![Taakbalk met venstertitels](screenshots/taskbar.png)

Elk venster krijgt een eigen knop met de titel naast het pictogram – twee Firefox-vensters zijn twee knoppen. Vastgezette programma's blijven waar je ze hebt gezet, en hun vensters openen precies daar. Via **Controlecentrum → Uiterlijk → Taakbalk** kun je de titels verbergen, vensters groeperen of de breedte kiezen (smal / middel / breed).

### Achtergronden en kleuren

![Drie achtergronden met de kleuren die AnimeStage eruit haalt](screenshots/wallpapers.jpg)

Elke nieuwe achtergrond brengt zijn eigen kleuren mee: AnimeStage haalt de accent- en achtergrondkleur uit de afbeelding en kleurt paneel, vensters, pictogrammen, terminal, Firefox en VS Code opnieuw in – automatisch elke 2 uur. Het paneel onder in elke afbeelding laat de kleuren van precies die afbeelding zien.

### Startmenu, agenda en systeembelasting

![AnimeStage: startmenu, agenda en systeembelasting](screenshots/preview.png)

| Controlecentrum – anime en personages | Controlecentrum – achtergrond |
|---|---|
| ![Controlecentrum: anime](screenshots/control-anime.png) | ![Controlecentrum: achtergrond](screenshots/control-wallpaper.png) |

## Vereisten

- **KDE Plasma 6** (ontwikkeld en getest op Bazzite / Fedora Atomic met Plasma 6.8; andere distributies met Plasma 6 zouden ook moeten werken)
- Python 3 met **Pillow** (`python3-pillow`)
- Een internetverbinding (AniList, Konachan, Danbooru)
- Optioneel: kitty (wordt op verzoek automatisch geïnstalleerd), Homebrew voor Starship/eza/bat/zoxide, Kvantum

Alles komt in je gebruikersprofiel – **geen rootrechten nodig**. Alleen de achtergrond van het aanmeldscherm vraagt één keer om je wachtwoord.

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
./install.sh --plan          # laat zien wat er gaat gebeuren (verandert niets)
./install.sh                 # installeren (maakt eerst een back-up van je KDE-instellingen)
```

Opties:

```bash
./install.sh --anime "Frieren"   # meteen met een anime beginnen
./install.sh --lang nl           # taal voor installer en thema
./install.sh --profile core      # je huidige paneel behouden
```

Open daarna **Startmenu → AnimeStage-controlecentrum → Anime** en zoek je anime.

### Bijwerken

Eén keer per dag kijkt AnimeStage op GitHub of er een nieuwe versie is en laat het je weten met een melding. Eén klik op **Nu installeren** is genoeg – of gebruik **Controlecentrum → Systeem → Updates** of `animestage update install`. Daar kun je updates ook automatisch laten installeren. Voor elke update wordt een back-up gemaakt. Geen controle nodig? Kies daar ‘Uit’ of voer `animestage update off` uit.

Handmatig bijwerken vanuit een git-kloon:

```bash
git pull
./update.sh          # instellingen, favorieten en paneel blijven zoals ze zijn
```

### Verwijderen

**De makkelijke manier:** Controlecentrum → Systeem → **AnimeStage verwijderen…** – een venster vraagt eerst om bevestiging en zet daarna alles terug.

**In de terminal:**

```bash
./uninstall.sh            # verwijdert alles en zet je oorspronkelijke KDE-instellingen terug
./uninstall.sh --purge    # verwijdert ook gedownloade afbeeldingen en de configuratie
```

**Wat er gebeurt bij installeren en verwijderen:** voordat er iets verandert, bewaart de installer je KDE-instellingen (paneel, kleuren, vensterdecoratie, lettertypen, vergrendelscherm, opstartscherm …) in `~/.local/state/animestage/backups/original`. Bij het verwijderen gaan alle AnimeStage-bestanden en -timers weg, worden de wijzigingen aan terminal, Firefox, VS Code en aanmeldscherm teruggedraaid en wordt daarna die back-up teruggezet – je bureaublad ziet er precies zo uit als vroeger. Ook wijzigingen aan het paneel die je na de installatie hebt gemaakt, worden teruggedraaid. De back-ups zelf blijven bewaard.

## Inhoudsfilter

AnimeStage is **standaard voor alle leeftijden** (filter ‘Streng’).

- **SFW** toont alle personages van de anime.
- **Ecchi / NSFW** kun je aanzetten, maar dat toont **uitsluitend meerderjarige personages**: de leeftijd moet van AniList komen (18+) of door jou zijn gemarkeerd – en markeren kan alleen als AniList geen leeftijd geeft of alleen een fantasieleeftijd zoals ‘1000+’. Personages die volgens AniList minderjarig zijn, kunnen nooit worden vrijgegeven.
- Uitdagende afbeeldingen worden alleen gebruikt als er geen ander personage op staat en geen enkele tag op iemand jongers wijst.
- **Vergrendelscherm, aanmeldscherm, terminal en Firefox tonen altijd alleen ‘safe’-afbeeldingen.**
- Een zelftest controleert deze regels; zijn ze verwijderd of afgezwakt, dan weigert de installer te installeren.

Je kunt ook **alleen vrouwelijke personages** laten tonen (Controlecentrum → Anime).

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

## Afbeeldingsbronnen en zelf bronnen toevoegen

Al het zoeken en downloaden van afbeeldingen zit in één bestand: [`lib/animestage_sources.py`](../lib/animestage_sources.py).
Gaat een site offline of wil je een andere gebruiken, voeg die dan daar toe (`SOURCES` en `PURPOSES`) en voer `./update.sh` uit – hij verschijnt dan in het Controlecentrum onder **Systeem → Afbeeldingsbronnen**. Er zijn kant-en-klare adapters voor sites in de stijl van Moebooru (Konachan, yande.re), Danbooru en Gelbooru.

## Vertalingen

De vertalingen staan in [`i18n/`](../i18n/) – één JSON-bestand per taal (Duitse brontekst → vertaling).
`tools/i18n-extract.py` laat zien welke teksten nog ontbreken. Verbeteringen en nieuwe talen zijn van harte welkom!

## Credits

- Animegegevens: [AniList](https://anilist.co) · Achtergronden: [Konachan](https://konachan.net) · Uitsneden: [Danbooru](https://danbooru.donmai.us) (AI-afbeeldingen zijn daar verboden)
- Lettertype: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Pictogrammen: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage bevat zelf geen anime-afbeeldingen – alles wordt pas gedownload als je een anime kiest. De makers staan in het Controlecentrum (beweeg de muis over een afbeelding). Alle personages © hun rechthebbenden. Niet-commercieel fanproject, niet verbonden aan de genoemde diensten.

Gemaakt door **propanisen** samen met **Claude Opus 5.5** (Anthropic) – ontwerp, code en vertalingen zijn ontstaan in een gesprek met de AI.

## Licentie

[GPL-3.0](../LICENSE)
