# AnimeStage

**Votre bureau KDE Plasma 6 aux couleurs de votre anime préféré.**
Tapez le nom d'un anime : AnimeStage habille tout le bureau autour de lui – fonds d'écran qui changent, couleurs assorties partout, personnages dans le menu de démarrage, et un terminal, Firefox et VS Code dans le même style.

🌐 [English](../README.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · **Français** · [Español](README.es.md) · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![Bureau AnimeStage avec un fond d'écran Frieren et le panneau AnimeStage](screenshots/desktop.jpg)

## Fonctionnalités

- **N'importe quel anime** – recherche via AniList ; titre, bannière et personnages (avec leur âge) sont récupérés automatiquement.
- **Des fonds d'écran qui changent** – de nouvelles images de Konachan toutes les 2 heures (réglable), selon le personnage, le filtre et l'ambiance. Gardez vos préférées, écartez les autres.
- **Des couleurs qui suivent le fond d'écran** – les couleurs d'accent de chaque nouvelle image sont appliquées à Plasma, aux décorations de fenêtres, aux icônes de dossiers (Papirus), au terminal, à Firefox et à VS Code.
- **Un panneau façon anime** – menu de démarrage avec personnage, barre des tâches avec le titre des fenêtres comme sous Windows, lecteur de musique, anneaux CPU/RAM/GPU et calendrier.
- **Terminal** – kitty ou Konsole aux couleurs du thème, accueil avec une image fraîche et les infos système, invite Starship et, si vous le souhaitez, une image en arrière-plan.
- **Firefox** – onglets et barre d'adresse aux couleurs assorties, et une nouvelle image sur la page Nouvel onglet à chaque lancement.
- **L'écran de verrouillage et l'écran de connexion** affichent aussi votre fond d'écran (connexion : Plasma Login Manager).
- **Centre de contrôle** – tout se règle dans une seule fenêtre, sans toucher aux fichiers de configuration.
- **13 langues** – suit la langue du système, modifiable dans le Centre de contrôle.

### Une barre des tâches comme sous Windows

![Barre des tâches avec le titre des fenêtres](screenshots/taskbar.png)

Chaque fenêtre a son propre bouton avec son titre à côté de l'icône – deux fenêtres Firefox, deux boutons. Les applications épinglées restent à leur place et leurs fenêtres s'ouvrent juste là. Dans **Centre de contrôle → Apparence → Barre des tâches**, vous pouvez masquer les titres, regrouper les fenêtres ou choisir la largeur (étroite / moyenne / large).

### Fonds d'écran et couleurs

![Trois fonds d'écran avec les couleurs qu'AnimeStage en tire](screenshots/wallpapers.jpg)

Chaque nouveau fond d'écran apporte ses propres couleurs : AnimeStage en extrait l'accent et l'arrière-plan, puis recolore le panneau, les fenêtres, les icônes, le terminal, Firefox et VS Code – automatiquement toutes les 2 heures. Le panneau en bas de chaque image montre les couleurs tirées de celle-ci.

### Menu de démarrage, calendrier et charge du système

![AnimeStage : menu de démarrage, calendrier et charge du système](screenshots/preview.png)

| Centre de contrôle – anime et personnages | Centre de contrôle – fond d'écran |
|---|---|
| ![Centre de contrôle : anime](screenshots/control-anime.png) | ![Centre de contrôle : fond d'écran](screenshots/control-wallpaper.png) |

## Prérequis

- **KDE Plasma 6** (développé et testé sur Bazzite / Fedora Atomic avec Plasma 6.8 ; les autres distributions avec Plasma 6 devraient fonctionner aussi)
- Python 3 avec **Pillow** (`python3-pillow`)
- Une connexion Internet (AniList, Konachan, Danbooru)
- Facultatif : kitty (installé automatiquement si vous le souhaitez), Homebrew pour Starship/eza/bat/zoxide, Kvantum

Tout s'installe dans votre profil utilisateur – **aucun droit root nécessaire**. Seul le fond de l'écran de connexion demande une fois votre mot de passe.

## Installation

**La méthode simple (recommandée) :**

1. Téléchargez **AnimeStage.zip** depuis la [dernière version](https://github.com/propanisen/AnimeStage/releases/latest).
2. Décompressez-le (clic droit → *Extraire ici*).
3. Dans le dossier, double-cliquez sur **Installer AnimeStage** et laissez-vous guider : langue, panneau, anime – c'est prêt.

**En une ligne dans le terminal :**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**Avec git (pour les développeurs) :**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # montre ce qui va se passer (ne modifie rien)
./install.sh                 # installe (sauvegarde d'abord vos réglages KDE)
```

Options :

```bash
./install.sh --anime "Frieren"   # commencer directement avec un anime
./install.sh --lang fr           # langue de l'installateur et du thème
./install.sh --profile core      # garder votre panneau actuel
```

Ouvrez ensuite **Menu de démarrage → Centre de contrôle AnimeStage → Anime** et cherchez votre anime.

### Mise à jour

Une fois par jour, AnimeStage vérifie sur GitHub si une nouvelle version est sortie et vous prévient par une notification. Un clic sur **Installer maintenant** suffit – ou passez par **Centre de contrôle → Système → Updates**, ou par `animestage update install`. Au même endroit, vous pouvez aussi laisser les mises à jour s'installer automatiquement. Une sauvegarde est faite avant chaque mise à jour. Pas de vérification ? Choisissez « Désactivé » ou lancez `animestage update off`.

Mise à jour manuelle depuis un clone git :

```bash
git pull
./update.sh          # vos réglages, favoris et panneau restent intacts
```

### Désinstallation

**La méthode simple :** Centre de contrôle → Système → **Désinstaller AnimeStage…** – une fenêtre demande confirmation, puis rétablit tout.

**Dans le terminal :**

```bash
./uninstall.sh            # supprime tout et rétablit vos réglages KDE d'origine
./uninstall.sh --purge    # supprime aussi les images téléchargées et la configuration
```

**Ce qui se passe à l'installation et à la désinstallation :** avant toute modification, l'installateur sauvegarde vos réglages KDE (panneau, couleurs, décoration des fenêtres, polices, écran de verrouillage, écran de démarrage…) dans `~/.local/state/animestage/backups/original`. La désinstallation supprime tous les fichiers et minuteurs d'AnimeStage, annule les changements apportés au terminal, à Firefox, à VS Code et à l'écran de connexion, puis restaure cette sauvegarde – votre bureau redevient exactement comme avant. Les modifications du panneau faites après l'installation sont elles aussi annulées. Les sauvegardes, elles, sont conservées.

## Filtre de contenu

AnimeStage est **tout public par défaut** (filtre « Strict »).

- **SFW** affiche tous les personnages de l'anime.
- **Ecchi / NSFW** peut être activé, mais **n'affiche que des personnages majeurs** : l'âge doit venir d'AniList (18 ans et plus) ou être indiqué par vous – ce qui n'est possible que si AniList ne donne pas d'âge ou seulement un âge fantaisiste comme « 1000+ ». Les personnages mineurs selon AniList ne peuvent jamais être débloqués.
- Les images suggestives ne sont utilisées que si aucun autre personnage n'apparaît et qu'aucune étiquette ne laisse penser à quelqu'un de plus jeune.
- **L'écran de verrouillage, l'écran de connexion, le terminal et Firefox n'affichent toujours que des images « safe ».**
- Un autotest vérifie ces règles ; si elles ont été supprimées ou affaiblies, l'installateur refuse d'installer.

Vous pouvez aussi n'afficher **que des personnages féminins** (Centre de contrôle → Anime).

## Ligne de commande

```bash
animestage search frieren            # chercher sur AniList
animestage anime 154587 --apply      # utiliser un anime
animestage wall next | fav | ban     # fond suivant, garder en favori, ne plus jamais afficher
animestage set wallswitch.minutes 60 # intervalle de changement
animestage themed new terminal --tags "night, city"   # recherche libre pour le fond du terminal
animestage source check              # les sites d'images répondent-ils ?
animestage status
animestage --help
```

## Sources d'images et ajout de vos propres sources

Toute la recherche et le téléchargement d'images tiennent dans un seul fichier : [`lib/animestage_sources.py`](../lib/animestage_sources.py).
Si un site est hors ligne ou si vous voulez en utiliser un autre, ajoutez-le ici (`SOURCES` et `PURPOSES`) puis lancez `./update.sh` – il apparaîtra dans le Centre de contrôle sous **Système → Sources d'images**. Des adaptateurs sont prêts pour les sites de type Moebooru (Konachan, yande.re), Danbooru et Gelbooru.

## Traductions

Les traductions se trouvent dans [`i18n/`](../i18n/) – un fichier JSON par langue (texte source allemand → traduction).
`tools/i18n-extract.py` liste les textes manquants. Corrections et nouvelles langues bienvenues !

## Crédits

- Données des animes : [AniList](https://anilist.co) · Fonds d'écran : [Konachan](https://konachan.net) · Images détourées : [Danbooru](https://danbooru.donmai.us) (les images générées par IA y sont interdites)
- Police : [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Icônes : [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage ne contient aucune image d'anime – tout est téléchargé au moment où vous choisissez un anime. Les auteurs sont indiqués dans le Centre de contrôle (survolez une image). Tous les personnages © leurs ayants droit. Projet de fan non commercial, sans lien avec les services cités.

Créé par **propanisen** avec **Claude Opus 5.5** (Anthropic) – design, code et traductions sont nés d'une conversation avec l'IA.

## Licence

[GPL-3.0](../LICENSE)
