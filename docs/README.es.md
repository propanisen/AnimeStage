# AnimeStage

**Convierte tu escritorio KDE Plasma 6 en tu anime favorito.**
Escribe un anime y AnimeStage construye todo el escritorio a su alrededor: fondos que cambian, colores a juego en todas partes, personajes en el menú de inicio y un terminal, Firefox y VS Code con el tema.

🌐 [English](../README.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · **Español** · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![Escritorio AnimeStage con fondo de Frieren y el panel de AnimeStage](screenshots/desktop.jpg)

## Funciones

- **Cualquier anime** – búsqueda en AniList; título, banner y personajes (con edad) se cargan solos.
- **Fondos que rotan** – imágenes nuevas de Konachan cada 2 horas (ajustable), según personaje, filtro y ambiente. Guarda favoritos o descarta imágenes.
- **Los colores siguen al fondo** – los colores de acento de cada imagen nueva se aplican a Plasma, decoración de ventanas, iconos (carpetas Papirus), terminal, Firefox y VS Code.
- **Panel estilo anime** – menú de inicio con un recorte del personaje, gestor de tareas con títulos de ventana, píldora de música, anillos de CPU/RAM/GPU y calendario.
- **Terminal** – kitty o Konsole con los colores del tema, saludo con una imagen nueva + info del sistema, prompt de Starship y, si quieres, una imagen de fondo en el terminal.
- **Firefox** – pestañas y barra de direcciones a juego, más una imagen en la nueva pestaña que cambia en cada inicio.
- **Pantalla de bloqueo y de inicio de sesión** también muestran tu fondo (inicio de sesión: Plasma Login Manager).
- **Centro de control** – todo en una ventana, sin editar archivos de configuración.
- **13 idiomas** – sigue el idioma del sistema y se puede cambiar en el Centro de control.

### Barra de tareas como en Windows

![Barra de tareas con los títulos de las ventanas](screenshots/taskbar.png)

Cada ventana tiene su propia entrada con su título junto al icono: dos ventanas de Firefox son dos entradas. Las aplicaciones ancladas se quedan donde las pusiste y sus ventanas se abren justo ahí. En **Centro de control → Apariencia → Gestor de tareas** puedes ocultar los títulos, agrupar ventanas o elegir el ancho (estrecho / medio / ancho).

### Fondos y colores

![Tres fondos, cada uno con los colores que AnimeStage toma de él](screenshots/wallpapers.jpg)

Cada fondo nuevo trae sus propios colores: AnimeStage toma los colores de acento y de fondo de la imagen y vuelve a colorear el panel, las ventanas, los iconos, el terminal, Firefox y VS Code, automáticamente cada 2 horas. El panel de la parte inferior de cada imagen muestra los colores de esa imagen.

### Menú de inicio, calendario y carga del sistema

![AnimeStage: menú de inicio, calendario y carga del sistema](screenshots/preview.png)

| Centro de control – anime y personajes | Centro de control – fondo |
|---|---|
| ![Centro de control: anime](screenshots/control-anime.png) | ![Centro de control: fondo](screenshots/control-wallpaper.png) |

## Requisitos

- **KDE Plasma 6** (hecho y probado en Bazzite / Fedora Atomic con Plasma 6.8; otras distribuciones con Plasma 6 deberían funcionar)
- Python 3 con **Pillow** (`python3-pillow`)
- Conexión a internet (AniList, Konachan, Danbooru)
- Opcional: kitty (se instala solo si lo pides), Homebrew para Starship/eza/bat/zoxide, Kvantum

Todo se instala en tu perfil de usuario – **sin permisos de root**. Solo el fondo de la pantalla de inicio de sesión pide una vez tu contraseña.

## Instalación

**La forma fácil (recomendada):**

1. Descarga **AnimeStage.zip** de la [última versión](https://github.com/propanisen/AnimeStage/releases/latest).
2. Descomprímelo (clic derecho → *Extraer aquí*).
3. Haz doble clic en **Instalar AnimeStage** dentro de la carpeta y sigue las ventanas: idioma, panel, anime – listo.

**Una línea en el terminal:**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**Con git (para desarrolladores):**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # muestra lo que va a pasar (no cambia nada)
./install.sh                 # instalar (antes se hace una copia de tus ajustes de KDE)
```

Opciones:

```bash
./install.sh --anime "Frieren"   # empezar directamente con un anime
./install.sh --lang es           # idioma del instalador y del tema
./install.sh --profile core      # mantener tu panel actual
```

Después abre **Menú de inicio → Centro de control de AnimeStage → Anime** y busca tu anime.

### Actualizar

AnimeStage busca una vez al día en GitHub si hay una versión nueva y muestra una notificación. Instálala con un clic en **Centro de control → Sistema → Updates** (o `animestage update install`). La notificación tiene un botón **Instalar ahora**, o deja que las actualizaciones se instalen solas (ajuste en el mismo sitio). Antes de cada actualización se hace una copia de seguridad. ¿No quieres la comprobación? Desmárcala allí o ejecuta `animestage update off`.

Actualizar a mano desde un clon de git:

```bash
git pull
./update.sh          # tus ajustes, favoritos y panel se mantienen
```

### Desinstalar

**La forma fácil:** Centro de control → Sistema → **Desinstalar AnimeStage …** – una ventana pregunta antes y lo restaura todo.

**En el terminal:**

```bash
./uninstall.sh            # lo quita todo y restaura tus ajustes originales de KDE
./uninstall.sh --purge    # además borra las imágenes descargadas y la configuración
```

**Qué pasa al instalar y desinstalar:** antes de cambiar nada, el instalador guarda tu configuración de KDE (panel, colores, decoración de ventanas, fuentes, pantalla de bloqueo, pantalla de inicio …) en `~/.local/state/animestage/backups/original`. Al desinstalar se eliminan todos los archivos y temporizadores de AnimeStage, se deshacen los cambios en el terminal, Firefox, VS Code y la pantalla de inicio de sesión, y después se restaura esa copia: tu escritorio queda exactamente como antes. Los cambios en el panel hechos después de instalar también se restablecen. Las copias de seguridad se conservan.

## Filtro de contenido

AnimeStage es **apto para todos por defecto** (filtro «Estricto»).

- **SFW** muestra todos los personajes del anime.
- **Ecchi / NSFW** se puede activar, pero **solo muestra personajes adultos**: la edad debe venir de AniList (18+), o marcas tú un personaje – solo es posible si AniList no da edad o da una edad fantástica como «1000+». Los personajes menores según AniList nunca se pueden desbloquear.
- Las imágenes atrevidas solo se usan si no hay otro personaje en la imagen y ninguna etiqueta sugiere a alguien más joven.
- **La pantalla de bloqueo, el inicio de sesión, el terminal y Firefox siempre muestran solo imágenes «safe».**
- Una autoprueba comprueba estas reglas; el instalador se niega a instalar si se quitaron o debilitaron.

También puedes mostrar **solo personajes femeninos** (Centro de control → Anime).

## Línea de comandos

```bash
animestage search frieren            # búsqueda en AniList
animestage anime 154587 --apply      # usar un anime
animestage wall next | fav | ban     # siguiente fondo, guardar como favorito, no volver a mostrar
animestage set wallswitch.minutes 60 # intervalo de cambio
animestage themed new terminal --tags "night, city"   # búsqueda propia para el fondo del terminal
animestage source check              # ¿están accesibles los sitios de imágenes?
animestage status
animestage --help
```

## Fuentes de imágenes y añadir las tuyas

Toda la búsqueda y descarga de imágenes está en un solo archivo: [`lib/animestage_sources.py`](../lib/animestage_sources.py).
Si un sitio cae o quieres otro, añádelo ahí (`SOURCES` y `PURPOSES`) y ejecuta `./update.sh` – aparecerá en el Centro de control en **Sistema → Fuentes de imágenes**. Hay adaptadores listos para Moebooru (Konachan, yande.re), Danbooru y sitios tipo Gelbooru.

## Traducciones

Las traducciones están en [`i18n/`](../i18n/) – un archivo JSON por idioma, texto original en alemán → traducción.
`tools/i18n-extract.py` muestra los textos que faltan. ¡Correcciones e idiomas nuevos son bienvenidos!

## Créditos

- Datos de anime: [AniList](https://anilist.co) · Fondos: [Konachan](https://konachan.net) · Recortes: [Danbooru](https://danbooru.donmai.us) (imágenes de IA prohibidas)
- Fuente: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · Iconos: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage no incluye imágenes de anime – todo se descarga cuando eliges un anime. Los artistas aparecen en el Centro de control (pasa el ratón por una imagen). Todos los personajes © de sus propietarios. Proyecto fan sin ánimo de lucro, sin relación con los servicios mencionados.

Hecho por **propanisen** junto con **Claude Opus 5.5** (Anthropic) – el diseño, el código y las traducciones se crearon conversando con la IA.

## Licencia

[GPL-3.0](../LICENSE)
