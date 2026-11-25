# AnimeStage

**Twój pulpit KDE Plasma 6 w klimacie ulubionego anime.**
Wpisz tytuł anime, a AnimeStage dopasuje do niego cały pulpit: zmieniające się tapety, pasujące kolory wszędzie, postacie w menu start oraz terminal, Firefox i VS Code w tym samym stylu.

🌐 [English](../README.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · [Español](README.es.md) · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · **Polski** · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![Pulpit AnimeStage z tapetą z Frieren i panelem AnimeStage](screenshots/desktop.jpg)

## Możliwości

- **Dowolne anime** – wyszukiwanie w AniList; tytuł, baner i postacie (z wiekiem) pobierają się same.
- **Zmieniające się tapety** – nowe obrazy z Konachan co 2 godziny (można zmienić), dobrane do postaci, filtra i nastroju. Ulubione możesz zapisać, a nietrafione odrzucić.
- **Kolory podążają za tapetą** – z każdego nowego obrazu brane są kolory akcentu dla Plasmy, dekoracji okien, ikon folderów (Papirus), terminala, Firefoksa i VS Code.
- **Panel w stylu anime** – menu start z postacią, pasek zadań z tytułami okien jak w Windows, odtwarzacz muzyki, pierścienie CPU/RAM/GPU i kalendarz.
- **Terminal** – kitty lub Konsole w kolorach motywu, powitanie ze świeżym obrazem i informacjami o systemie, znak zachęty Starship, a jeśli chcesz – obraz jako tło.
- **Firefox** – karty i pasek adresu w pasujących kolorach, a przy każdym uruchomieniu nowy obraz na stronie nowej karty.
- **Ekran blokady i ekran logowania** też pokazują twoją tapetę (logowanie: Plasma Login Manager).
- **Centrum sterowania** – wszystko ustawiasz w jednym oknie, bez grzebania w plikach konfiguracyjnych.
- **13 języków** – zgodnie z językiem systemu, z możliwością zmiany w Centrum sterowania.

### Pasek zadań jak w Windows

![Pasek zadań z tytułami okien](screenshots/taskbar.png)

Każde okno ma własny przycisk z tytułem obok ikony – dwa okna Firefoksa to dwa przyciski. Przypięte aplikacje zostają tam, gdzie je umieściłeś, a ich okna otwierają się dokładnie w tym miejscu. W **Centrum sterowania → Wygląd → Pasek zadań** możesz ukryć tytuły, grupować okna albo wybrać szerokość (wąskie / średnie / szerokie).

### Tapety i kolory

![Trzy tapety z kolorami, które AnimeStage z nich pobiera](screenshots/wallpapers.jpg)

Każda nowa tapeta przynosi własne kolory: AnimeStage pobiera z obrazu kolor akcentu i tła, po czym przemalowuje panel, okna, ikony, terminal, Firefoksa i VS Code – automatycznie co 2 godziny. Panel na dole każdego obrazu pokazuje kolory właśnie tego obrazu.

### Menu start, kalendarz i obciążenie systemu

![AnimeStage: menu start, kalendarz i obciążenie systemu](screenshots/preview.png)

| Centrum sterowania – anime i postacie | Centrum sterowania – tapeta |
|---|---|
| ![Centrum sterowania: anime](screenshots/control-anime.png) | ![Centrum sterowania: tapeta](screenshots/control-wallpaper.png) |

## Wymagania

- **KDE Plasma 6** (tworzone i testowane na Bazzite / Fedora Atomic z Plasmą 6.8; inne dystrybucje z Plasmą 6 też powinny działać)
- Python 3 z **Pillow** (`python3-pillow`)
- Połączenie z internetem (AniList, Konachan, Danbooru)
- Opcjonalnie: kitty (na życzenie instalowany automatycznie), Homebrew dla Starship/eza/bat/zoxide, Kvantum

Wszystko trafia do twojego profilu użytkownika – **uprawnienia roota nie są potrzebne**. Tylko tapeta ekranu logowania raz poprosi o hasło.

## Instalacja

**Prosty sposób (zalecany):**

1. Pobierz **AnimeStage.zip** z [najnowszego wydania](https://github.com/propanisen/AnimeStage/releases/latest).
2. Rozpakuj (prawy przycisk → *Rozpakuj tutaj*).
3. W folderze kliknij dwukrotnie **Zainstaluj AnimeStage** i postępuj według okien: język, panel, anime – gotowe.

**Jedna linia w terminalu:**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**Przez git (dla programistów):**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # pokazuje, co się stanie (niczego nie zmienia)
./install.sh                 # instaluje (najpierw robi kopię zapasową ustawień KDE)
```

Opcje:

```bash
./install.sh --anime "Frieren"   # od razu zacznij od wybranego anime
./install.sh --lang pl           # język instalatora i motywu
./install.sh --profile core      # zachowaj obecny panel
```

Następnie otwórz **Menu start → Centrum sterowania AnimeStage → Anime** i wyszukaj swoje anime.

### Aktualizacja

Raz dziennie AnimeStage sprawdza na GitHubie, czy jest nowa wersja, i daje znać powiadomieniem. Wystarczy kliknąć **Zainstaluj teraz** – albo użyć **Centrum sterowania → System → Updates** lub polecenia `animestage update install`. Tam też możesz włączyć automatyczne instalowanie aktualizacji. Przed każdą aktualizacją tworzona jest kopia zapasowa. Nie chcesz sprawdzania? Wybierz „Wyłączone” albo uruchom `animestage update off`.

Ręczna aktualizacja z klonu git:

```bash
git pull
./update.sh          # ustawienia, ulubione i panel zostają bez zmian
```

### Odinstalowanie

**Prosty sposób:** Centrum sterowania → System → **Odinstaluj AnimeStage…** – okno najpierw zapyta, a potem wszystko przywróci.

**W terminalu:**

```bash
./uninstall.sh            # usuwa wszystko i przywraca pierwotne ustawienia KDE
./uninstall.sh --purge    # dodatkowo usuwa pobrane obrazy i konfigurację
```

**Co się dzieje przy instalacji i odinstalowaniu:** zanim cokolwiek zmieni, instalator zapisuje twoje ustawienia KDE (panel, kolory, dekoracje okien, czcionki, ekran blokady, ekran powitalny…) w `~/.local/state/animestage/backups/original`. Odinstalowanie usuwa wszystkie pliki i timery AnimeStage, cofa zmiany w terminalu, Firefoksie, VS Code i na ekranie logowania, a potem przywraca tę kopię – pulpit wygląda dokładnie tak jak wcześniej. Zmiany w panelu wprowadzone po instalacji również zostają cofnięte. Same kopie zapasowe zostają.

## Filtr treści

AnimeStage jest **domyślnie bezpieczny dla wszystkich** (filtr „Ścisły”).

- **SFW** pokazuje wszystkie postacie z anime.
- **Ecchi / NSFW** można włączyć, ale **pokazuje wyłącznie pełnoletnie postacie**: wiek musi pochodzić z AniList (18+) albo zostać oznaczony przez ciebie – co jest możliwe tylko wtedy, gdy AniList nie podaje wieku lub podaje tylko wiek fantastyczny, np. „1000+”. Postaci niepełnoletnich według AniList nie da się nigdy odblokować.
- Odważne obrazy są używane tylko wtedy, gdy nie ma na nich innej postaci i żaden tag nie wskazuje na kogoś młodszego.
- **Ekran blokady, ekran logowania, terminal i Firefox zawsze pokazują tylko obrazy „safe”.**
- Te reguły sprawdza autotest; jeśli zostały usunięte lub osłabione, instalator odmawia instalacji.

Możesz też pokazywać **tylko postacie kobiece** (Centrum sterowania → Anime).

## Wiersz poleceń

```bash
animestage search frieren            # szukaj w AniList
animestage anime 154587 --apply      # użyj wybranego anime
animestage wall next | fav | ban     # następna tapeta, zapisz w ulubionych, nigdy więcej nie pokazuj
animestage set wallswitch.minutes 60 # odstęp między zmianami
animestage themed new terminal --tags "night, city"   # własne wyszukiwanie tła terminala
animestage source check              # czy strony z obrazami odpowiadają?
animestage status
animestage --help
```

## Źródła obrazów i dodawanie własnych

Całe wyszukiwanie i pobieranie obrazów mieści się w jednym pliku: [`lib/animestage_sources.py`](../lib/animestage_sources.py).
Jeśli jakaś strona przestanie działać albo chcesz użyć innej, dopisz ją tam (`SOURCES` i `PURPOSES`) i uruchom `./update.sh` – pojawi się w Centrum sterowania w **System → Źródła obrazów**. Gotowe adaptery są dla stron typu Moebooru (Konachan, yande.re), Danbooru i Gelbooru.

## Tłumaczenia

Tłumaczenia znajdują się w [`i18n/`](../i18n/) – jeden plik JSON na język (niemiecki tekst źródłowy → tłumaczenie).
`tools/i18n-extract.py` pokazuje brakujące teksty. Poprawki i nowe języki są mile widziane!

## Podziękowania

- Dane anime: [AniList](https://anilist.co) · Tapety: [Konachan](https://konachan.net) · Wycinki: [Danbooru](https://danbooru.donmai.us) (obrazy generowane przez AI są tam zabronione)
- Czcionka: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Ikony: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage nie zawiera żadnych obrazów anime – wszystko pobiera się dopiero po wybraniu anime. Autorzy są podani w Centrum sterowania (najedź kursorem na obraz). Wszystkie postacie © ich właścicieli. Niekomercyjny projekt fanowski, niezwiązany z wymienionymi serwisami.

Stworzone przez **propanisen** razem z **Claude Opus 5.5** (Anthropic) – projekt, kod i tłumaczenia powstały w rozmowie z AI.

## Licencja

[GPL-3.0](../LICENSE)
