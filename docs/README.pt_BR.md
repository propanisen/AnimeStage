# AnimeStage

**Deixe seu KDE Plasma 6 com a cara do seu anime favorito.**
Digite o nome de um anime e o AnimeStage monta a área de trabalho inteira em volta dele: papéis de parede que vão trocando, cores combinando em todo lugar, personagens no menu iniciar e terminal, Firefox e VS Code no mesmo estilo.

🌐 [English](../README.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · [Español](README.es.md) · **Português (BR)** · [Italiano](README.it.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![Área de trabalho do AnimeStage com papel de parede de Frieren e o painel do AnimeStage](screenshots/desktop.jpg)

## Recursos

- **Qualquer anime** – busca pelo AniList; título, banner e personagens (com idade) vêm automaticamente.
- **Papéis de parede que trocam** – imagens novas do Konachan a cada 2 horas (ajustável), por personagem, filtro e clima. Guarde as favoritas e descarte as que não curtir.
- **Cores que seguem o papel de parede** – as cores de destaque de cada imagem nova vão para o Plasma, a decoração das janelas, os ícones de pasta (Papirus), o terminal, o Firefox e o VS Code.
- **Painel no estilo anime** – menu iniciar com personagem, barra de tarefas com o título das janelas como no Windows, player de música, anéis de CPU/RAM/GPU e calendário.
- **Terminal** – kitty ou Konsole nas cores do tema, saudação com imagem nova e informações do sistema, prompt do Starship e, se quiser, uma imagem de fundo.
- **Firefox** – abas e barra de endereço em cores combinando, mais uma imagem nova na página de nova aba a cada vez que ele abre.
- **Tela de bloqueio e tela de login** também mostram seu papel de parede (login: Plasma Login Manager).
- **Central de controle** – tudo é ajustado numa janela só, sem mexer em arquivos de configuração.
- **13 idiomas** – segue o idioma do sistema e pode ser trocado na Central de controle.

### Barra de tarefas como no Windows

![Barra de tarefas com o título das janelas](screenshots/taskbar.png)

Cada janela ganha seu próprio botão com o título ao lado do ícone – duas janelas do Firefox, dois botões. Os aplicativos fixados ficam onde você os colocou, e as janelas abrem bem ali. Em **Central de controle → Aparência → Barra de tarefas** você pode esconder os títulos, agrupar janelas ou escolher a largura (estreita / média / larga).

### Papéis de parede e cores

![Três papéis de parede com as cores que o AnimeStage tira de cada um](screenshots/wallpapers.jpg)

Cada papel de parede novo traz as próprias cores: o AnimeStage tira da imagem a cor de destaque e a de fundo e recolore o painel, as janelas, os ícones, o terminal, o Firefox e o VS Code – automaticamente a cada 2 horas. O painel na parte de baixo de cada imagem mostra as cores daquela imagem.

### Menu iniciar, calendário e uso do sistema

![AnimeStage: menu iniciar, calendário e uso do sistema](screenshots/preview.png)

| Central de controle – anime e personagens | Central de controle – papel de parede |
|---|---|
| ![Central de controle: anime](screenshots/control-anime.png) | ![Central de controle: papel de parede](screenshots/control-wallpaper.png) |

## Requisitos

- **KDE Plasma 6** (feito e testado no Bazzite / Fedora Atomic com Plasma 6.8; outras distribuições com Plasma 6 devem funcionar também)
- Python 3 com **Pillow** (`python3-pillow`)
- Conexão com a internet (AniList, Konachan, Danbooru)
- Opcional: kitty (instalado automaticamente se você quiser), Homebrew para Starship/eza/bat/zoxide, Kvantum

Tudo é instalado no seu perfil de usuário – **não precisa de root**. Só o papel de parede da tela de login pede sua senha uma vez.

## Instalação

**O jeito fácil (recomendado):**

1. Baixe o **AnimeStage.zip** da [versão mais recente](https://github.com/propanisen/AnimeStage/releases/latest).
2. Extraia (clique direito → *Extrair aqui*).
3. Na pasta, dê um clique duplo em **Instalar o AnimeStage** e siga as janelas: idioma, painel, anime – pronto.

**Uma linha no terminal:**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**Com git (para desenvolvedores):**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # mostra o que vai acontecer (não muda nada)
./install.sh                 # instala (antes faz backup das suas configurações do KDE)
```

Opções:

```bash
./install.sh --anime "Frieren"   # começar direto com um anime
./install.sh --lang pt_BR        # idioma do instalador e do tema
./install.sh --profile core      # manter seu painel atual
```

Depois abra **Menu iniciar → Central de controle do AnimeStage → Anime** e busque seu anime.

### Atualização

Uma vez por dia, o AnimeStage confere no GitHub se saiu uma versão nova e avisa com uma notificação. É só clicar em **Instalar agora** – ou usar **Central de controle → Sistema → Updates**, ou `animestage update install`. Lá também dá para deixar as atualizações instalarem sozinhas. Antes de cada atualização é feito um backup. Não quer a verificação? Escolha “Desligado” ou rode `animestage update off`.

Atualizar manualmente a partir de um clone git:

```bash
git pull
./update.sh          # suas configurações, favoritos e painel continuam iguais
```

### Desinstalação

**O jeito fácil:** Central de controle → Sistema → **Desinstalar o AnimeStage…** – uma janela pede confirmação e deixa tudo como era antes.

**No terminal:**

```bash
./uninstall.sh            # remove tudo e restaura suas configurações originais do KDE
./uninstall.sh --purge    # também apaga as imagens baixadas e a configuração
```

**O que acontece na instalação e na desinstalação:** antes de mudar qualquer coisa, o instalador salva suas configurações do KDE (painel, cores, decoração das janelas, fontes, tela de bloqueio, tela de abertura…) em `~/.local/state/animestage/backups/original`. A desinstalação remove todos os arquivos e timers do AnimeStage, desfaz as mudanças no terminal, no Firefox, no VS Code e na tela de login e depois restaura esse backup – sua área de trabalho fica exatamente como antes. Mudanças no painel feitas depois da instalação também são desfeitas. Os backups em si continuam guardados.

## Filtro de conteúdo

O AnimeStage é **livre para todos os públicos por padrão** (filtro “Rigoroso”).

- **SFW** mostra todos os personagens do anime.
- **Ecchi / NSFW** pode ser ligado, mas **só mostra personagens maiores de idade**: a idade precisa vir do AniList (18+) ou ser marcada por você – e isso só é possível quando o AniList não informa idade ou só tem uma idade de fantasia como “1000+”. Personagens menores de idade segundo o AniList nunca podem ser liberados.
- Imagens provocantes só são usadas se não houver outro personagem na imagem e nenhuma tag indicar alguém mais novo.
- **Tela de bloqueio, tela de login, terminal e Firefox sempre mostram só imagens “safe”.**
- Um autoteste confere essas regras; se elas forem removidas ou enfraquecidas, o instalador se recusa a instalar.

Você também pode mostrar **só personagens femininas** (Central de controle → Anime).

## Linha de comando

```bash
animestage search frieren            # buscar no AniList
animestage anime 154587 --apply      # usar um anime
animestage wall next | fav | ban     # próximo papel de parede, guardar como favorito, nunca mais mostrar
animestage set wallswitch.minutes 60 # intervalo de troca
animestage themed new terminal --tags "night, city"   # busca própria para o fundo do terminal
animestage source check              # os sites de imagens estão respondendo?
animestage status
animestage --help
```

## Origens de imagens e como adicionar as suas

Toda a busca e o download de imagens ficam num arquivo só: [`lib/animestage_sources.py`](../lib/animestage_sources.py).
Se um site sair do ar ou você quiser usar outro, adicione lá (`SOURCES` e `PURPOSES`) e rode `./update.sh` – ele aparece na Central de controle em **Sistema → Origens de imagens**. Já existem adaptadores prontos para sites do tipo Moebooru (Konachan, yande.re), Danbooru e Gelbooru.

## Traduções

As traduções ficam em [`i18n/`](../i18n/) – um arquivo JSON por idioma (texto original em alemão → tradução).
`tools/i18n-extract.py` lista os textos que faltam. Correções e novos idiomas são muito bem-vindos!

## Créditos

- Dados de anime: [AniList](https://anilist.co) · Papéis de parede: [Konachan](https://konachan.net) · Recortes: [Danbooru](https://danbooru.donmai.us) (lá imagens geradas por IA são proibidas)
- Fonte: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Ícones: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- O AnimeStage não traz nenhuma imagem de anime – tudo é baixado quando você escolhe um anime. Os artistas aparecem na Central de controle (passe o mouse sobre uma imagem). Todos os personagens © de seus respectivos donos. Projeto de fã sem fins lucrativos, sem ligação com os serviços citados.

Feito por **propanisen** junto com o **Claude Opus 5.5** (Anthropic) – design, código e traduções nasceram de uma conversa com a IA.

## Licença

[GPL-3.0](../LICENSE)
