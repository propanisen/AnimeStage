# AnimeStage

**Zamień pulpit KDE Plasma 6 w swoje ulubione anime.**
Wpisz tytuł anime – AnimeStage zbuduje wokół niego cały pulpit: zmieniające się tapety, pasujące kolory wszędzie, postacie w menu start oraz terminal, Firefox i VS Code w motywie.

🌐 [English](../README.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · [Español](README.es.md) · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · **Polski** · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![Pulpit AnimeStage z tapetą z Frieren i panelem AnimeStage](screenshots/desktop.jpg)

## Funkcje

- **Dowolne anime** – wyszukiwanie przez AniList; tytuł, baner i postacie (z wiekiem) pobierają się same.
- **Zmieniające się tapety** – nowe obrazy z Konachan co 2 godziny (do ustawienia), według postaci, filtra i nastroju. Zapisuj ulubione albo odrzucaj obrazy.
- **Kolory podążają za tapetą** – kolory akcentu z każdego nowego obrazu trafiają do Plasmy, dekoracji okien, ikon (foldery Papirus), terminala, Firefoksa i VS Code.
- **Panel w stylu anime** – menu start z wycinkiem postaci, menedżer zadań z nazwami okien, pigułka muzyki, pierścienie CPU/RAM/GPU i kalendarz.
- **Terminal** – kitty lub Konsole w kolorach motywu, powitanie z nowym obrazem + informacjami o systemie, znak zachęty Starship i opcjonalnie obraz jako tło terminala.
- **Firefox** – karty i pasek adresu w pasujących kolorach oraz obraz na nowej karcie, zmieniany przy każdym uruchomieniu.
- **Ekran blokady i logowania** też pokazują twoją tapetę (logowanie: Plasma Login Manager).
- **Centrum sterowania** – wszystko w jednym oknie, bez edytowania plików konfiguracyjnych.
- **13 języków** – zgodnie z językiem systemu, do zmiany w Centrum sterowania.

### Pasek zadań jak w Windows

![Pasek zadań z tytułami okien](screenshots/taskbar.png)

Każde okno ma własny wpis z tytułem obok ikony – dwa okna Firefoksa to dwa wpisy. Przypięte programy zostają tam, gdzie je umieściłeś, a ich okna otwierają się właśnie tam. W **Centrum sterowania → Wygląd → Menedżer zadań** możesz wyłączyć tytuły, grupować okna lub wybrać szerokość (wąska / średnia / szeroka).

### Tapety i kolory

![Trzy tapety, każda z kolorami, które AnimeStage z niej pobiera](screenshots/wallpapers.jpg)

Każda nowa tapeta przynosi własne kolory: AnimeStage pobiera z obrazu kolor akcentu i tła, a potem przekolorowuje panel, okna, ikony, terminal, Firefoksa i VS Code – automatycznie co 2 godziny. Panel na dole każdego obrazu pokazuje kolory właśnie tego obrazu.

### Menu start, kalendarz i obciążenie systemu

![AnimeStage: menu start, kalendarz i obciążenie systemu](screenshots/preview.png)

| Centrum sterowania – anime i postacie | Centrum sterowania – tapeta |
|---|---|
| ![Centrum sterowania: anime](screenshots/control-anime.png) | ![Centrum sterowania: tapeta](screenshots/control-wallpaper.png) |

## Wymagania

- **KDE Plasma 6** (tworzone i testowane na Bazzite / Fedora Atomic z Plasma 6.8; inne dystrybucje z Plasma 6 powinny działać)
- Python 3 z **Pillow** (`python3-pillow`)
- Połączenie z internetem (AniList, Konachan, Danbooru)
- Opcjonalnie: kitty (instalowany automatycznie na życzenie), Homebrew dla Starship/eza/bat/zoxide, Kvantum

Wszystko instaluje się w twoim profilu użytkownika – **bez uprawnień roota**. Tylko tapeta ekranu logowania raz poprosi o hasło.

## Instalacja

**Prosty sposób (zalecany):**

1. Pobierz **AnimeStage.zip** z [najnowszego wydania](https://github.com/propanisen/AnimeStage/releases/latest).
2. Rozpakuj (prawy przycisk → *Rozpakuj tutaj*).
3. Kliknij dwukrotnie **Zainstaluj AnimeStage** w folderze i postępuj według okien: język, panel, anime – gotowe.

**Jedna linia w terminalu:**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**Przez git (dla programistów):**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # pokazuje, co się stanie (niczego nie zmienia)
./install.sh                 # instalacja (najpierw powstaje kopia ustawień KDE)
```

Opcje:

```bash
./install.sh --anime "Frieren"   # od razu zacznij od anime
./install.sh --lang pl           # język instalatora i motywu
./install.sh --profile core      # zachowaj obecny panel
```

Potem otwórz **Menu start → Centrum sterowania AnimeStage → Anime** i wyszukaj swoje anime.

### Aktualizacja

AnimeStage raz dziennie sprawdza na GitHubie, czy jest nowa wersja, i pokazuje powiadomienie. Zainstalujesz ją jednym kliknięciem w **Centrum sterowania → System → Updates** (albo `animestage update install`). Powiadomienie ma przycisk **Zainstaluj teraz** – albo aktualizacje mogą instalować się same (ustawienie w tym samym miejscu). Przed każdą aktualizacją tworzona jest kopia zapasowa. Nie chcesz sprawdzania? Odznacz je tam albo uruchom `animestage update off`.

Ręczna aktualizacja z klonu git:

```bash
git pull
./update.sh          # ustawienia, ulubione i panel zostają bez zmian
```

### Odinstalowanie

**Prosty sposób:** Centrum sterowania → System → **Odinstaluj AnimeStage …** – okno najpierw pyta i wszystko przywraca.

**W terminalu:**

```bash
./uninstall.sh            # usuwa wszystko i przywraca pierwotne ustawienia KDE
./uninstall.sh --purge    # usuwa też pobrane obrazy i konfigurację
```

**Co dzieje się przy instalacji i odinstalowaniu:** zanim cokolwiek zmieni, instalator zapisuje twoje ustawienia KDE (panel, kolory, dekoracje okien, czcionki, ekran blokady, ekran powitalny …) w `~/.local/state/animestage/backups/original`. Odinstalowanie usuwa wszystkie pliki i timery AnimeStage, cofa zmiany w terminalu, Firefoksie, VS Code i na ekranie logowania, a potem przywraca tę kopię – pulpit wygląda dokładnie jak wcześniej. Zmiany w panelu zrobione po instalacji również zostają cofnięte. Same kopie zapasowe zostają.

## Filtr treści

AnimeStage jest **domyślnie bezpieczny** (filtr „Ściśle”).

- **SFW** pokazuje wszystkie postacie z anime.
- **Ecchi / NSFW** można włączyć, ale **pokazuje wyłącznie pełnoletnie postacie**: wiek musi pochodzić z AniList (18+) albo oznaczasz postać sam – tylko gdy AniList nie podaje wieku lub podaje wiek fantastyczny jak „1000+”. Postaci niepełnoletnich według AniList nigdy nie da się odblokować.
- Odważne obrazy są używane tylko wtedy, gdy na obrazie nie ma innej postaci i żaden tag nie sugeruje kogoś młodszego.
- **Ekran blokady, ekran logowania, terminal i Firefox zawsze pokazują tylko obrazy „safe”.**
- Te zasady sprawdza autotest; instalator odmawia instalacji, jeśli zostały usunięte lub osłabione.

Możesz też pokazywać **tylko postacie kobiece** (Centrum sterowania → Anime).

## Wiersz poleceń

```bash
animestage search frieren            # wyszukiwanie w AniList
animestage anime 154587 --apply      # użyj anime
animestage wall next | fav | ban     # następna tapeta, zapisz w ulubionych, nigdy więcej nie pokazuj
animestage set wallswitch.minutes 60 # odstęp zmiany
animestage themed new terminal --tags "night, city"   # własne wyszukiwanie tła terminala
animestage source check              # czy strony z obrazami są osiągalne?
animestage status
animestage --help
```

## Źródła obrazów i dodawanie własnych

Całe wyszukiwanie i pobieranie obrazów znajduje się w jednym pliku: [`lib/animestage_sources.py`](../lib/animestage_sources.py).
Jeśli strona przestanie działać albo chcesz inną, dodaj ją tam (`SOURCES` i `PURPOSES`) i uruchom `./update.sh` – pojawi się w Centrum sterowania w **System → Źródła obrazów**. Gotowe adaptery są dla Moebooru (Konachan, yande.re), Danbooru i stron typu Gelbooru.

## Tłumaczenia

Tłumaczenia są w [`i18n/`](../i18n/) – jeden plik JSON na język, niemiecki tekst źródłowy → tłumaczenie.
`tools/i18n-extract.py` pokazuje brakujące teksty. Poprawki i nowe języki są mile widziane!

## Podziękowania

- Dane anime: [AniList](https://anilist.co) · Tapety: [Konachan](https://konachan.net) · Wycinki: [Danbooru](https://danbooru.donmai.us) (obrazy AI są tam zakazane)
- Czcionka: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Ikony: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage nie zawiera żadnych obrazów anime – wszystko pobiera się po wybraniu anime. Autorzy są podani w Centrum sterowania (najedź na obraz). Wszystkie postacie © ich właścicieli. Niekomercyjny projekt fanowski, niezwiązany z powyższymi serwisami.

Stworzone przez **propanisen** razem z **Claude Opus 5.5** (Anthropic) – projekt, kod i tłumaczenia powstały w rozmowie z AI.

## Licencja

[GPL-3.0](../LICENSE)
