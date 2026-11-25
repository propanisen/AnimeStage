# AnimeStage

**Il tuo desktop KDE Plasma 6 nello stile del tuo anime preferito.**
Scrivi il nome di un anime e AnimeStage ci costruisce attorno tutto il desktop: sfondi che cambiano, colori abbinati ovunque, personaggi nel menu di avvio e terminale, Firefox e VS Code nello stesso stile.

🌐 [English](../README.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · [Español](README.es.md) · [Português (BR)](README.pt_BR.md) · **Italiano** · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![Desktop AnimeStage con uno sfondo di Frieren e il pannello AnimeStage](screenshots/desktop.jpg)

## Funzioni

- **Qualsiasi anime** – ricerca tramite AniList; titolo, banner e personaggi (con l'età) arrivano da soli.
- **Sfondi che cambiano** – nuove immagini da Konachan ogni 2 ore (regolabile), in base a personaggio, filtro e atmosfera. Tieni le preferite, scarta quelle che non ti piacciono.
- **I colori seguono lo sfondo** – da ogni nuova immagine vengono presi i colori d'accento per Plasma, le decorazioni delle finestre, le icone delle cartelle (Papirus), il terminale, Firefox e VS Code.
- **Pannello in stile anime** – menu di avvio con personaggio, barra delle applicazioni con i titoli delle finestre come su Windows, lettore musicale, anelli CPU/RAM/GPU e calendario.
- **Terminale** – kitty o Konsole nei colori del tema, un saluto con un'immagine sempre nuova e le informazioni di sistema, prompt Starship e, se vuoi, un'immagine come sfondo.
- **Firefox** – schede e barra degli indirizzi in colori abbinati, più una nuova immagine nella pagina Nuova scheda a ogni avvio.
- **Schermata di blocco e schermata di accesso** mostrano anche loro il tuo sfondo (accesso: Plasma Login Manager).
- **Centro di controllo** – si regola tutto da un'unica finestra, senza toccare file di configurazione.
- **13 lingue** – segue la lingua di sistema e si può cambiare nel Centro di controllo.

### Barra delle applicazioni come su Windows

![Barra delle applicazioni con i titoli delle finestre](screenshots/taskbar.png)

Ogni finestra ha il suo pulsante con il titolo accanto all'icona: due finestre di Firefox, due pulsanti. Le app fissate restano dove le hai messe e le loro finestre si aprono proprio lì. In **Centro di controllo → Aspetto → Barra delle applicazioni** puoi nascondere i titoli, raggruppare le finestre o scegliere la larghezza (stretta / media / larga).

### Sfondi e colori

![Tre sfondi con i colori che AnimeStage ricava da ciascuno](screenshots/wallpapers.jpg)

Ogni nuovo sfondo porta i suoi colori: AnimeStage ricava dall'immagine il colore d'accento e quello di fondo e ricolora pannello, finestre, icone, terminale, Firefox e VS Code – in automatico ogni 2 ore. Il pannello in basso in ogni immagine mostra i colori di quell'immagine.

### Menu di avvio, calendario e carico di sistema

![AnimeStage: menu di avvio, calendario e carico di sistema](screenshots/preview.png)

| Centro di controllo – anime e personaggi | Centro di controllo – sfondo |
|---|---|
| ![Centro di controllo: anime](screenshots/control-anime.png) | ![Centro di controllo: sfondo](screenshots/control-wallpaper.png) |

## Requisiti

- **KDE Plasma 6** (sviluppato e provato su Bazzite / Fedora Atomic con Plasma 6.8; altre distribuzioni con Plasma 6 dovrebbero funzionare ugualmente)
- Python 3 con **Pillow** (`python3-pillow`)
- Una connessione a internet (AniList, Konachan, Danbooru)
- Facoltativi: kitty (installato in automatico se lo chiedi), Homebrew per Starship/eza/bat/zoxide, Kvantum

Tutto viene installato nel tuo profilo utente – **non servono permessi di root**. Solo lo sfondo della schermata di accesso chiede una volta la password.

## Installazione

**Il modo semplice (consigliato):**

1. Scarica **AnimeStage.zip** dall'[ultima versione](https://github.com/propanisen/AnimeStage/releases/latest).
2. Estrailo (clic destro → *Estrai qui*).
3. Nella cartella, fai doppio clic su **Installa AnimeStage** e segui le finestre: lingua, pannello, anime – fatto.

**Una riga nel terminale:**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**Con git (per sviluppatori):**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # mostra cosa succederà (non cambia nulla)
./install.sh                 # installa (prima crea un backup delle impostazioni KDE)
```

Opzioni:

```bash
./install.sh --anime "Frieren"   # partire subito con un anime
./install.sh --lang it           # lingua dell'installer e del tema
./install.sh --profile core      # tenere il pannello attuale
```

Poi apri **Menu di avvio → Centro di controllo AnimeStage → Anime** e cerca il tuo anime.

### Aggiornamenti

Una volta al giorno AnimeStage controlla su GitHub se c'è una nuova versione e te lo dice con una notifica. Basta un clic su **Installa ora** – oppure passa da **Centro di controllo → Sistema → Updates** o usa `animestage update install`. Lì puoi anche far installare gli aggiornamenti in automatico. Prima di ogni aggiornamento viene creato un backup. Non vuoi il controllo? Scegli «Disattivato» o esegui `animestage update off`.

Aggiornare a mano da un clone git:

```bash
git pull
./update.sh          # impostazioni, preferiti e pannello restano come sono
```

### Disinstallazione

**Il modo semplice:** Centro di controllo → Sistema → **Disinstalla AnimeStage…** – una finestra chiede conferma e rimette tutto com'era.

**Nel terminale:**

```bash
./uninstall.sh            # rimuove tutto e ripristina le impostazioni KDE originali
./uninstall.sh --purge    # elimina anche le immagini scaricate e la configurazione
```

**Cosa succede durante installazione e disinstallazione:** prima di cambiare qualsiasi cosa, l'installer salva le tue impostazioni KDE (pannello, colori, decorazioni delle finestre, caratteri, schermata di blocco, schermata iniziale…) in `~/.local/state/animestage/backups/original`. La disinstallazione rimuove tutti i file e i timer di AnimeStage, annulla le modifiche a terminale, Firefox, VS Code e schermata di accesso e poi ripristina quel backup: il desktop torna esattamente com'era. Anche le modifiche al pannello fatte dopo l'installazione vengono annullate. I backup restano conservati.

## Filtro dei contenuti

AnimeStage è **adatto a tutti per impostazione predefinita** (filtro «Rigoroso»).

- **SFW** mostra tutti i personaggi dell'anime.
- **Ecchi / NSFW** si può attivare, ma **mostra solo personaggi maggiorenni**: l'età deve venire da AniList (18+) oppure essere segnata da te – cosa possibile solo se AniList non indica un'età o ne indica solo una fantasy come «1000+». I personaggi minorenni secondo AniList non si possono mai sbloccare.
- Le immagini provocanti vengono usate solo se non c'è nessun altro personaggio e nessun tag fa pensare a qualcuno più giovane.
- **Schermata di blocco, schermata di accesso, terminale e Firefox mostrano sempre solo immagini «safe».**
- Un autotest controlla queste regole; se sono state rimosse o indebolite, l'installer si rifiuta di installare.

Puoi anche mostrare **solo personaggi femminili** (Centro di controllo → Anime).

## Riga di comando

```bash
animestage search frieren            # cerca su AniList
animestage anime 154587 --apply      # usa un anime
animestage wall next | fav | ban     # sfondo successivo, tieni tra i preferiti, non mostrare più
animestage set wallswitch.minutes 60 # intervallo di cambio
animestage themed new terminal --tags "night, city"   # ricerca libera per lo sfondo del terminale
animestage source check              # i siti di immagini rispondono?
animestage status
animestage --help
```

## Origini delle immagini e come aggiungerne altre

Tutta la ricerca e il download delle immagini stanno in un unico file: [`lib/animestage_sources.py`](../lib/animestage_sources.py).
Se un sito va offline o vuoi usarne un altro, aggiungilo lì (`SOURCES` e `PURPOSES`) ed esegui `./update.sh`: comparirà nel Centro di controllo in **Sistema → Origini delle immagini**. Ci sono adattatori pronti per siti di tipo Moebooru (Konachan, yande.re), Danbooru e Gelbooru.

## Traduzioni

Le traduzioni si trovano in [`i18n/`](../i18n/): un file JSON per lingua (testo originale in tedesco → traduzione).
`tools/i18n-extract.py` elenca i testi mancanti. Correzioni e nuove lingue sono le benvenute!

## Crediti

- Dati degli anime: [AniList](https://anilist.co) · Sfondi: [Konachan](https://konachan.net) · Ritagli: [Danbooru](https://danbooru.donmai.us) (lì le immagini generate con l'IA sono vietate)
- Carattere: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Icone: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage non contiene immagini di anime: tutto viene scaricato quando scegli un anime. Gli autori sono indicati nel Centro di controllo (passa il mouse su un'immagine). Tutti i personaggi © dei rispettivi proprietari. Progetto amatoriale senza scopo di lucro, non collegato ai servizi citati.

Realizzato da **propanisen** insieme a **Claude Opus 5.5** (Anthropic): design, codice e traduzioni sono nati da una conversazione con l'IA.

## Licenza

[GPL-3.0](../LICENSE)
