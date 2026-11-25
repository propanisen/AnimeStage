# AnimeStage

**Transforme ton bureau KDE Plasma 6 en ton anime préféré.**
Tape le nom d'un anime – AnimeStage construit tout le bureau autour : fonds d'écran qui changent, couleurs assorties partout, personnages dans le menu de démarrage, terminal, Firefox et VS Code à thème.

🌐 [English](../README.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · **Français** · [Español](README.es.md) · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![Bureau AnimeStage avec un fond d'écran Frieren et le panneau AnimeStage](screenshots/desktop.jpg)

## Fonctionnalités

- **N'importe quel anime** – recherche via AniList ; titre, bannière et personnages (avec âge) sont chargés automatiquement.
- **Fonds d'écran en rotation** – nouvelles images de Konachan toutes les 2 heures (réglable), selon personnage, filtre et ambiance. Garde tes favoris ou écarte des images.
- **Les couleurs suivent le fond d'écran** – les couleurs d'accent de chaque nouvelle image s'appliquent à Plasma, aux décorations de fenêtres, aux icônes (dossiers Papirus), au terminal, à Firefox et à VS Code.
- **Panneau style anime** – menu de démarrage avec un détourage de personnage, gestionnaire de tâches avec titres de fenêtres, pilule musique, anneaux CPU/RAM/GPU et calendrier.
- **Terminal** – kitty ou Konsole aux couleurs du thème, accueil avec une nouvelle image + infos système, invite Starship et, en option, une image en fond du terminal.
- **Firefox** – onglets et barre d'adresse assortis, plus une image de nouvel onglet qui change à chaque démarrage.
- **Écran de verrouillage et de connexion** affichent aussi ton fond d'écran (connexion : Plasma Login Manager).
- **Centre de contrôle** – tout dans une seule fenêtre, aucun fichier de configuration à modifier.
- **13 langues** – suit la langue du système, modifiable dans le Centre de contrôle.

### Barre des tâches comme sous Windows

![Barre des tâches avec les titres des fenêtres](screenshots/taskbar.png)

Chaque fenêtre a sa propre entrée avec son titre à côté de l'icône – deux fenêtres Firefox font deux entrées. Les applications épinglées restent à leur place et leurs fenêtres s'ouvrent juste là. Dans **Centre de contrôle → Apparence → Gestionnaire de tâches**, vous pouvez masquer les titres, regrouper les fenêtres ou choisir la largeur (étroite / moyenne / large).

### Fonds d'écran & couleurs

![Trois fonds d'écran, chacun avec les couleurs qu'AnimeStage en tire](screenshots/wallpapers.jpg)

Chaque nouveau fond d'écran apporte ses propres couleurs : AnimeStage prend les couleurs d'accent et de fond dans l'image et recolore le panneau, les fenêtres, les icônes, le terminal, Firefox et VS Code – automatiquement toutes les 2 heures. Le panneau en bas de chaque image montre les couleurs de cette image.

### Menu de démarrage, calendrier & charge système

![AnimeStage : menu de démarrage, calendrier et charge système](screenshots/preview.png)

| Centre de contrôle – anime & personnages | Centre de contrôle – fond d'écran |
|---|---|
| ![Centre de contrôle : anime](screenshots/control-anime.png) | ![Centre de contrôle : fond d'écran](screenshots/control-wallpaper.png) |

## Prérequis

- **KDE Plasma 6** (conçu et testé sur Bazzite / Fedora Atomic avec Plasma 6.8 ; les autres distributions avec Plasma 6 devraient fonctionner)
- Python 3 avec **Pillow** (`python3-pillow`)
- Une connexion Internet (AniList, Konachan, Danbooru)
- Optionnel : kitty (installé automatiquement sur demande), Homebrew pour Starship/eza/bat/zoxide, Kvantum

Tout s'installe dans ton profil utilisateur – **aucun droit root nécessaire**. Seul le fond de l'écran de connexion demande une fois ton mot de passe.

## Installation

**La méthode simple (recommandée) :**

1. Téléchargez **AnimeStage.zip** depuis la [dernière version](https://github.com/propanisen/AnimeStage/releases/latest).
2. Décompressez-le (clic droit → *Extraire ici*).
3. Double-cliquez sur **Installer AnimeStage** dans le dossier et suivez les fenêtres : langue, panneau, anime – c'est fini.

**Une ligne dans le terminal :**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**Avec git (pour les développeurs) :**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # montre ce qui va se passer (ne change rien)
./install.sh                 # installer (une sauvegarde de tes réglages KDE est faite avant)
```

Options :

```bash
./install.sh --anime "Frieren"   # démarrer directement avec un anime
./install.sh --lang fr           # langue de l'installateur et du thème
./install.sh --profile core      # garder ton panneau actuel
```

Ensuite, ouvre **Menu de démarrage → Centre de contrôle AnimeStage → Anime** et cherche ton anime.

### Mise à jour

AnimeStage vérifie une fois par jour sur GitHub si une nouvelle version existe et affiche une notification. Installez-la en un clic dans **Centre de contrôle → Système → Updates** (ou `animestage update install`). La notification a un bouton **Installer maintenant** – ou laissez les mises à jour s'installer automatiquement (réglage au même endroit). Une sauvegarde est faite avant chaque mise à jour. Vous ne voulez pas de vérification ? Décochez-la là-bas ou lancez `animestage update off`.

Mise à jour manuelle depuis un clone git :

```bash
git pull
./update.sh          # réglages, favoris et panneau restent inchangés
```

### Désinstallation

**La méthode simple :** Centre de contrôle → Système → **Désinstaller AnimeStage …** – une fenêtre demande confirmation et restaure tout.

**Dans le terminal :**

```bash
./uninstall.sh            # supprime tout et restaure tes réglages KDE d'origine
./uninstall.sh --purge    # supprime aussi les images téléchargées et la configuration
```

**Ce qui se passe à l'installation et à la désinstallation :** avant de modifier quoi que ce soit, l'installateur sauvegarde vos réglages KDE (panneau, couleurs, décoration des fenêtres, polices, écran de verrouillage, écran de démarrage …) dans `~/.local/state/animestage/backups/original`. La désinstallation supprime tous les fichiers et minuteurs d'AnimeStage, annule les modifications du terminal, de Firefox, de VS Code et de l'écran de connexion, puis restaure cette sauvegarde – votre bureau redevient exactement comme avant. Les modifications du panneau faites après l'installation sont aussi réinitialisées. Les sauvegardes elles-mêmes sont conservées.

## Filtre de contenu

AnimeStage est **tout public par défaut** (filtre « Strict »).

- **SFW** affiche tous les personnages de l'anime.
- **Ecchi / NSFW** peut être activé, mais **n'affiche jamais que des personnages adultes** : l'âge doit venir d'AniList (18+), ou tu marques toi-même un personnage – uniquement possible si AniList n'indique pas d'âge ou un âge fantastique comme « 1000+ ». Les personnages mineurs selon AniList ne peuvent jamais être débloqués.
- Les images osées ne sont utilisées que si aucun autre personnage n'est sur l'image et qu'aucun tag ne suggère quelqu'un de plus jeune.
- **L'écran de verrouillage, l'écran de connexion, le terminal et Firefox n'affichent toujours que des images « safe ».**
- Un auto-test vérifie ces règles ; l'installateur refuse d'installer si elles ont été supprimées ou affaiblies.

Tu peux aussi n'afficher **que les personnages féminins** (Centre de contrôle → Anime).

## Ligne de commande

```bash
animestage search frieren            # recherche AniList
animestage anime 154587 --apply      # utiliser un anime
animestage wall next | fav | ban     # fond suivant, garder en favori, ne plus jamais afficher
animestage set wallswitch.minutes 60 # intervalle de rotation
animestage themed new terminal --tags "night, city"   # recherche perso pour le fond du terminal
animestage source check              # les sites d'images sont-ils joignables ?
animestage status
animestage --help
```

## Sources d'images & ajouter les tiennes

Toute la recherche et le téléchargement d'images se trouvent dans un seul fichier : [`lib/animestage_sources.py`](../lib/animestage_sources.py).
Si un site tombe ou si tu en veux un autre, ajoute-le là (`SOURCES` et `PURPOSES`) puis lance `./update.sh` – il apparaît alors dans le Centre de contrôle sous **Système → Sources d'images**. Des adaptateurs prêts existent pour Moebooru (Konachan, yande.re), Danbooru et les sites de type Gelbooru.

## Traductions

Les traductions se trouvent dans [`i18n/`](../i18n/) – un fichier JSON par langue, texte source allemand → traduction.
`tools/i18n-extract.py` liste les textes manquants. Corrections et nouvelles langues bienvenues !

## Crédits

- Données d'anime : [AniList](https://anilist.co) · Fonds d'écran : [Konachan](https://konachan.net) · Détourages : [Danbooru](https://danbooru.donmai.us) (images IA interdites)
- Police : [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Icônes : [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage ne contient aucune image d'anime – tout est téléchargé quand tu choisis un anime. Les artistes sont indiqués dans le Centre de contrôle (survole une image). Tous les personnages © leurs ayants droit. Projet de fan non commercial, sans lien avec les services ci-dessus.

Réalisé par **propanisen** avec **Claude Opus 5.5** (Anthropic) – design, code et traductions ont été créés en dialogue avec l'IA.

## Licence

[GPL-3.0](../LICENSE)
