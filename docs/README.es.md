# AnimeStage

**Tu escritorio KDE Plasma 6 con el estilo de tu anime favorito.**
Escribe el nombre de un anime y AnimeStage viste todo el escritorio a su alrededor: fondos que van cambiando, colores a juego en todas partes, personajes en el menú de inicio y un terminal, Firefox y VS Code con el mismo estilo.

🌐 [English](../README.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · **Español** · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![Escritorio de AnimeStage con un fondo de Frieren y el panel de AnimeStage](screenshots/desktop.jpg)

## Funciones

- **Cualquier anime** – búsqueda en AniList; el título, el banner y los personajes (con su edad) se cargan solos.
- **Fondos que cambian** – imágenes nuevas de Konachan cada 2 horas (ajustable), según personaje, filtro y ambiente. Guarda tus favoritas y descarta las que no te gusten.
- **Los colores siguen al fondo** – de cada imagen nueva se sacan los colores de acento para Plasma, la decoración de ventanas, los iconos de carpeta (Papirus), el terminal, Firefox y VS Code.
- **Panel con estilo anime** – menú de inicio con personaje, barra de tareas con el título de las ventanas como en Windows, reproductor de música, anillos de CPU/RAM/GPU y calendario.
- **Terminal** – kitty o Konsole con los colores del tema, un saludo con imagen nueva e información del sistema, prompt de Starship y, si quieres, una imagen de fondo.
- **Firefox** – pestañas y barra de direcciones a juego, y una imagen nueva en la página de nueva pestaña cada vez que lo abres.
- **La pantalla de bloqueo y la de inicio de sesión** también muestran tu fondo (inicio de sesión: Plasma Login Manager).
- **Centro de control** – todo se ajusta en una sola ventana, sin tocar archivos de configuración.
- **13 idiomas** – sigue el idioma del sistema y se puede cambiar en el Centro de control.

### Barra de tareas como en Windows

![Barra de tareas con el título de las ventanas](screenshots/taskbar.png)

Cada ventana tiene su propio botón con el título junto al icono: dos ventanas de Firefox, dos botones. Las aplicaciones ancladas se quedan donde las pusiste y sus ventanas se abren justo ahí. En **Centro de control → Apariencia → Barra de tareas** puedes ocultar los títulos, agrupar ventanas o elegir el ancho (estrecho / medio / ancho).

### Fondos y colores

![Tres fondos con los colores que AnimeStage saca de cada uno](screenshots/wallpapers.jpg)

Cada fondo nuevo trae sus propios colores: AnimeStage saca de la imagen el color de acento y el de fondo, y vuelve a colorear el panel, las ventanas, los iconos, el terminal, Firefox y VS Code, automáticamente cada 2 horas. El panel de la parte de abajo de cada imagen muestra los colores de esa imagen.

### Menú de inicio, calendario y carga del sistema

![AnimeStage: menú de inicio, calendario y carga del sistema](screenshots/preview.png)

| Centro de control – anime y personajes | Centro de control – fondo |
|---|---|
| ![Centro de control: anime](screenshots/control-anime.png) | ![Centro de control: fondo](screenshots/control-wallpaper.png) |

## Requisitos

- **KDE Plasma 6** (desarrollado y probado en Bazzite / Fedora Atomic con Plasma 6.8; otras distribuciones con Plasma 6 deberían funcionar igual)
- Python 3 con **Pillow** (`python3-pillow`)
- Conexión a internet (AniList, Konachan, Danbooru)
- Opcional: kitty (se instala solo si lo pides), Homebrew para Starship/eza/bat/zoxide, Kvantum

Todo se instala en tu perfil de usuario: **no hacen falta permisos de root**. Solo el fondo de la pantalla de inicio de sesión te pide la contraseña una vez.

## Instalación

**La forma fácil (recomendada):**

1. Descarga **AnimeStage.zip** de la [última versión](https://github.com/propanisen/AnimeStage/releases/latest).
2. Descomprímelo (clic derecho → *Extraer aquí*).
3. Dentro de la carpeta, haz doble clic en **Instalar AnimeStage** y sigue las ventanas: idioma, panel, anime… y listo.

**Una línea en el terminal:**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**Con git (para desarrolladores):**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # muestra lo que va a hacer (no cambia nada)
./install.sh                 # instala (antes hace una copia de seguridad de tu configuración de KDE)
```

Opciones:

```bash
./install.sh --anime "Frieren"   # empezar directamente con un anime
./install.sh --lang es           # idioma del instalador y del tema
./install.sh --profile core      # mantener tu panel actual
```

Después abre **Menú de inicio → Centro de control de AnimeStage → Anime** y busca tu anime.

### Actualizar

Una vez al día, AnimeStage mira en GitHub si hay una versión nueva y te avisa con una notificación. Basta con pulsar **Instalar ahora**; también puedes hacerlo desde **Centro de control → Sistema → Updates** o con `animestage update install`. Ahí mismo puedes hacer que las actualizaciones se instalen solas. Antes de cada actualización se hace una copia de seguridad. ¿No quieres que lo compruebe? Elige «Desactivado» o ejecuta `animestage update off`.

Actualizar a mano desde un clon de git:

```bash
git pull
./update.sh          # tus ajustes, favoritos y panel se quedan como están
```

### Desinstalar

**La forma fácil:** Centro de control → Sistema → **Desinstalar AnimeStage…**: una ventana te pide confirmación y lo deja todo como estaba.

**En el terminal:**

```bash
./uninstall.sh            # lo quita todo y restaura tu configuración original de KDE
./uninstall.sh --purge    # además borra las imágenes descargadas y la configuración
```

**Qué pasa al instalar y desinstalar:** antes de cambiar nada, el instalador guarda tu configuración de KDE (panel, colores, decoración de ventanas, fuentes, pantalla de bloqueo, pantalla de bienvenida…) en `~/.local/state/animestage/backups/original`. Al desinstalar se borran todos los archivos y temporizadores de AnimeStage, se deshacen los cambios en el terminal, Firefox, VS Code y la pantalla de inicio de sesión, y después se restaura esa copia: tu escritorio queda exactamente como antes. Los cambios que hayas hecho en el panel después de instalar también se deshacen. Las copias de seguridad se conservan.

## Filtro de contenido

AnimeStage es **apto para todos los públicos por defecto** (filtro «Estricto»).

- **SFW** muestra todos los personajes del anime.
- **Ecchi / NSFW** se puede activar, pero **solo muestra personajes mayores de edad**: la edad tiene que venir de AniList (18+) o la marcas tú, y eso solo se puede hacer si AniList no da ninguna edad o solo una edad de fantasía como «1000+». Los personajes que según AniList son menores de edad no se pueden desbloquear nunca.
- Las imágenes insinuantes solo se usan si no aparece ningún otro personaje y ninguna etiqueta sugiere a alguien más joven.
- **La pantalla de bloqueo, la de inicio de sesión, el terminal y Firefox muestran siempre solo imágenes «safe».**
- Una autoprueba comprueba estas reglas; si se han quitado o suavizado, el instalador se niega a instalar.

También puedes mostrar **solo personajes femeninos** (Centro de control → Anime).

## Línea de órdenes

```bash
animestage search frieren            # buscar en AniList
animestage anime 154587 --apply      # usar un anime
animestage wall next | fav | ban     # siguiente fondo, guardar como favorito, no volver a mostrar
animestage set wallswitch.minutes 60 # intervalo de cambio
animestage themed new terminal --tags "night, city"   # búsqueda propia para el fondo del terminal
animestage source check              # ¿responden los sitios de imágenes?
animestage status
animestage --help
```

## Orígenes de imágenes y cómo añadir los tuyos

Toda la búsqueda y descarga de imágenes está en un solo archivo: [`lib/animestage_sources.py`](../lib/animestage_sources.py).
Si un sitio deja de funcionar o quieres usar otro, añádelo ahí (`SOURCES` y `PURPOSES`) y ejecuta `./update.sh`: aparecerá en el Centro de control en **Sistema → Orígenes de imágenes**. Hay adaptadores listos para sitios tipo Moebooru (Konachan, yande.re), Danbooru y Gelbooru.

## Traducciones

Las traducciones están en [`i18n/`](../i18n/): un archivo JSON por idioma (texto original en alemán → traducción).
`tools/i18n-extract.py` muestra los textos que faltan. ¡Las correcciones y los idiomas nuevos son muy bienvenidos!

## Créditos

- Datos de anime: [AniList](https://anilist.co) · Fondos: [Konachan](https://konachan.net) · Recortes: [Danbooru](https://danbooru.donmai.us) (allí están prohibidas las imágenes generadas por IA)
- Fuente: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Iconos: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage no incluye ninguna imagen de anime: todo se descarga cuando eliges un anime. Los autores se muestran en el Centro de control (pasa el ratón por encima de una imagen). Todos los personajes © de sus respectivos titulares. Proyecto de fans sin ánimo de lucro, sin relación con los servicios mencionados.

Hecho por **propanisen** junto con **Claude Opus 5.5** (Anthropic): el diseño, el código y las traducciones salieron de una conversación con la IA.

## Licencia

[GPL-3.0](../LICENSE)
