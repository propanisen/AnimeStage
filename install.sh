#!/usr/bin/env bash
# AnimeStage – anime theme for KDE Plasma 6 (anime via AniList, images from Konachan/Danbooru)
#
#   ./install.sh --plan            show what would happen (changes nothing)
#   ./install.sh                   full installation incl. panel layout
#   ./install.sh --profile core    without panel layout
#   ./install.sh --anime "Frieren" start right away with this anime
#   ./install.sh --lang ja         installer and theme language (default: system language)
#   ./install.sh --status          show status
#   ./install.sh --uninstall       remove everything and restore the original state
#   ./install.sh --gui             graphical installer (windows instead of the terminal)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
BIN="$HOME/.local/bin"
PROFILE="full"
MODE="install"
YES=0
FETCH=1
TERMINAL=1
PURGE=0
ANIME=""
LANG_OPT=""
GUI=0
WIDGETS=(launcher media system clock control)
# widgets shipped by older versions, removed on update/uninstall
RETIRED=(focus weather calendar notes character showdesktop)

c_acc=$'\e[38;2;57;197;187m'; c_pink=$'\e[38;2;225;40;133m'; c_dim=$'\e[2m'; c_off=$'\e[0m'
say()  { printf '%s▸%s %s\n' "$c_acc" "$c_off" "$*"; }
warn() { printf '%s!%s %s\n' "$c_pink" "$c_off" "$*" >&2; }
die()  { warn "$*"; exit 1; }

# Translation: t "German source text with %s" value  (dictionary from i18n/<lang>.json)
declare -A TR=()
load_lang() {
    local code
    code="$(python3 "$ROOT/lib/animestage_i18n.py" --bash ${LANG_OPT:+"$LANG_OPT"} 2>/dev/null)" && eval "$code" || true
}
t() {
    local s="${TR[$1]:-$1}"; shift
    # shellcheck disable=SC2059
    if [[ $# -gt 0 ]]; then printf -- "$s" "$@"; else printf '%s' "$s"; fi
}

usage() {
    sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'
    cat <<USAGE

$(t "Optionen:")
  --profile core|full   $(t "full (Standard) setzt zusätzlich das Panel-Layout")
  --anime "TITLE"       $(t "mit diesem Anime starten (erster AniList-Treffer)")
  --lang CODE           $(t "Sprache, z. B. en, de, ja, fr, es, pt_BR, it, pl, nl, ru, zh_CN, zh_TW, ko")
  --no-fetch            $(t "keine Schrift herunterladen")
  --no-terminal         $(t "Terminal-Begrüßung und Bash-Prompt unverändert lassen")
  --yes                 $(t "ohne Rückfrage")
  --purge               $(t "bei --uninstall auch Bilder und Config löschen")
USAGE
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --plan) MODE="plan" ;;
        --status) MODE="status" ;;
        --uninstall) MODE="uninstall" ;;
        --profile) PROFILE="${2:?}"; shift ;;
        --anime) ANIME="${2:?}"; shift ;;
        --lang) LANG_OPT="${2:?}"; shift ;;
        --no-fetch) FETCH=0 ;;
        --no-terminal) TERMINAL=0 ;;
        --yes|-y) YES=1 ;;
        --purge) PURGE=1 ;;
        --gui) GUI=1 ;;
        -h|--help) load_lang; usage; exit 0 ;;
        *) load_lang; usage; die "$(t "Unbekannte Option: %s" "$1")" ;;
    esac
    shift
done
load_lang
[[ "$PROFILE" == core || "$PROFILE" == full ]] || die "$(t "Profil muss core oder full sein")"

banner() {
    printf '%s' "$c_acc"
    cat <<'ART'
      ___          _                _____ __
     /   |  ____  (_)___ ___  ___  / ___// /_____ _____ ____
    / /| | / __ \/ / __ `__ \/ _ \ \__ \/ __/ __ `/ __ `/ _ \
   / ___ |/ / / / / / / / / /  __/___/ / /_/ /_/ / /_/ /  __/
  /_/  |_/_/ /_/_/_/ /_/ /_/\___//____/\__/\__,_/\__, /\___/
                                                /____/
ART
    printf '%s        アニメ · 好きな作品で、デスクトップを。%s\n\n' "$c_pink" "$c_off"
}

confirm() {
    [[ $YES -eq 1 ]] && return 0
    read -r -p "$1 $(t "[j/N]") " answer
    [[ "$answer" =~ ^[jJyYoOsStTдДтТ是はい예]$ ]] || [[ "$answer" =~ ^(si|sí|tak|ja|yes|oui|sim|да|是|はい|예)$ ]]
}

check_tools() {
    local missing=()
    for t in python3 kpackagetool6 kwriteconfig6 kreadconfig6 plasma-apply-colorscheme plasma-apply-desktoptheme plasma-apply-wallpaperimage plasmawindowed; do
        command -v "$t" >/dev/null || missing+=("$t")
    done
    command -v qdbus6 >/dev/null || command -v qdbus-qt6 >/dev/null || command -v qdbus >/dev/null || missing+=("qdbus")
    python3 -c "import PIL" 2>/dev/null || missing+=("python3-pillow")
    [[ ${#missing[@]} -eq 0 ]] || die "$(t "Fehlende Programme: %s" "${missing[*]}")"
    local v; v="$(plasmashell --version 2>/dev/null | awk '{print $2}')"
    [[ "${v%%.*}" == 6 ]] || warn "$(t "Plasma 6 erwartet, gefunden: %s" "${v:-?}")"
}

plan() {
    printf '%s%s%s\n' "$c_acc" "$(t "Plan (Profil: %s)" "$PROFILE${ANIME:+, Anime: $ANIME}")" "$c_off"
    echo "  1. $(t "Backup deiner KDE-Einstellungen nach %s" "~/.local/state/animestage/backups/")"
    echo "     $(t "(der allererste Stand bleibt als „original“ erhalten)")"
    echo "  2. $(t "Steuerprogramm") → $BIN/animestage"
    echo "     $(t "Daten & Logos") → $DATA/animestage/"
    echo "     $(t "Kontrollzentrum") → $(t "Startmenü „AnimeStage Kontrollzentrum“")"
    echo "  3. $(t "%s Plasmoids" "${#WIDGETS[@]}") → $DATA/plasma/plasmoids/org.animestage.* (${WIDGETS[*]})"
    echo "  4. $(t "Look-and-Feel + Startbildschirm") → $DATA/plasma/look-and-feel/org.animestage.desktop"
    [[ -d "$CONFIG/vocastage" || -d "$DATA/plasma/plasmoids/org.vocastage.launcher" ]] && \
        echo "  4b. $(t "VocaStage gefunden: Einstellungen, Backups, Favoriten und Panel werden übernommen, Reste entfernt")"
    if [[ $FETCH -eq 1 ]]; then
        echo "  5. $(t "Download: Schrift M PLUS Rounded 1c (OFL); Bilder lädt AnimeStage, sobald du einen Anime wählst")"
    else
        echo "  5. $(t "(kein Download)")"
    fi
    echo "  6. $(t "Erzeugen & anwenden: Farbschema, Plasma-Stil, Papirus-Icons (~230 MB, Ordner in Akzentfarbe), Fensterrahmen, Terminal, Hintergrund, Sperrbildschirm, Startbildschirm")"
    [[ $TERMINAL -eq 1 ]] && echo "  6b. $(t "Terminal: AnimeStage-Begrüßung, Prompt in Theme-Farben (%s)" "~/.bashrc.d/animestage.sh")"
    if [[ $PROFILE == full ]]; then
        echo "  7. ${c_pink}$(t "Panel wird ERSETZT")${c_off} $(t "durch das AnimeStage-Panel (Launcher, Taskleiste, Musik, Auslastung, Uhr)")"
    else
        echo "  7. $(t "Panel bleibt unverändert (Widgets per „Miniprogramme hinzufügen“)")"
    fi
    echo
    echo "$(t "Alles liegt in deinem Benutzerprofil – keine Root-Rechte nötig.")"
    echo "$(t "Rückgängig:") ./install.sh --uninstall"
}

# Installs or updates a KPackage. Whether it already exists is decided by the
# target folder: `kpackagetool6 -s` reports success even for missing packages (falls back to Breeze).
kpkg() {
    local type="$1" src="$2" dest="$3"
    if [[ -d "$dest" ]]; then
        kpackagetool6 -t "$type" -u "$src" >/dev/null 2>&1 || { rm -rf "$dest"; kpackagetool6 -t "$type" -i "$src" >/dev/null; }
    else
        kpackagetool6 -t "$type" -i "$src" >/dev/null
    fi
}

install_files() {
    say "$(t "Installiere Steuerprogramm und Daten")"
    mkdir -p "$BIN" "$DATA/animestage" "$DATA/applications" "$DATA/icons/hicolor/scalable/apps"
    install -m 755 "$ROOT/bin/animestage" "$BIN/animestage"
    install -m 644 "$ROOT/VERSION" "$DATA/animestage/VERSION"
    # keep a copy of the installer, so uninstall/repair work even after the
    # downloaded folder was deleted (Control Center → System → Uninstall)
    local srccopy="$DATA/animestage/source"
    if [[ "$(realpath -m "$ROOT")" != "$(realpath -m "$srccopy")" ]]; then
        rm -rf "$srccopy"; mkdir -p "$srccopy"
        tar -C "$ROOT" --exclude=./.git --exclude=./build --exclude=./dist --exclude=./docs \
            --exclude='__pycache__' -cf - . | tar -C "$srccopy" -xf -
    fi
    install -m 755 "$ROOT/share/login-setup.sh" "$DATA/animestage/login-setup.sh"
    install -D -m 644 "$ROOT/lib/animestage_sources.py" "$DATA/animestage/lib/animestage_sources.py"
    install -D -m 644 "$ROOT/lib/animestage_i18n.py" "$DATA/animestage/lib/animestage_i18n.py"
    rm -rf "$DATA/animestage/i18n"
    mkdir -p "$DATA/animestage/i18n"
    for f in "$ROOT"/i18n/*.json; do [[ "$(basename "$f")" == template.json ]] || install -m 644 "$f" "$DATA/animestage/i18n/"; done
    rm -rf "$DATA/animestage/logos"
    cp -r "$ROOT/share/logos" "$DATA/animestage/logos"
    install -m 644 "$ROOT/share/logos/animestage.svg" "$DATA/icons/hicolor/scalable/apps/animestage.svg"
    # Absolute icon path: otherwise Plasma only sees a freshly created hicolor dir after a cache rebuild.
    "$BIN/animestage" apply colors >/dev/null 2>&1 || true   # also creates the Control Center icon
    sed "s|^Icon=.*|Icon=$DATA/icons/hicolor/scalable/apps/animestage-control.svg|" \
        "$ROOT/share/applications/org.animestage.control.desktop" > "$DATA/applications/org.animestage.control.desktop"
    # clean up old shortcuts (start menu entries)
    rm -f "$DATA/applications/org.animestage.wall-next.desktop" "$DATA/applications/org.animestage.wall-fav.desktop"
    command -v update-desktop-database >/dev/null && update-desktop-database "$DATA/applications" 2>/dev/null || true
    # Without a fresh application index the taskbar shows the Control Center as "?".
    command -v kbuildsycoca6 >/dev/null && kbuildsycoca6 >/dev/null 2>&1 || true

    say "$(t "Installiere Plasmoids")"
    local out; out="$("$ROOT/tools/build-plasmoids.sh")"
    for w in "${WIDGETS[@]}"; do
        local pkg="$out/org.animestage.$w"
        kpkg Plasma/Applet "$pkg" "$DATA/plasma/plasmoids/org.animestage.$w"
        printf '   %s✓%s %s\n' "$c_acc" "$c_off" "org.animestage.$w"
    done

    for w in "${RETIRED[@]}"; do
        kpackagetool6 -t Plasma/Applet -r "org.animestage.$w" >/dev/null 2>&1 || true
    done

    say "$(t "Installiere Look-and-Feel")"
    local lnf="$ROOT/plasma/look-and-feel/org.animestage.desktop"
    kpkg Plasma/LookAndFeel "$lnf" "$DATA/plasma/look-and-feel/org.animestage.desktop"
}

# Restart Plasma via systemd so the shell (and everything later started from
# the panel) does not inherit this terminal's environment.
restart_plasmashell() {
    kquitapp6 plasmashell >/dev/null 2>&1 || true
    for _ in $(seq 20); do pgrep -x plasmashell >/dev/null || break; sleep 0.5; done
    pkill -x plasmashell 2>/dev/null || true
    systemctl --user reset-failed plasma-plasmashell.service >/dev/null 2>&1 || true
    if ! systemctl --user start plasma-plasmashell.service >/dev/null 2>&1; then
        (setsid kstart plasmashell >/dev/null 2>&1 &)
    fi
}

do_install() {
    banner
    check_tools
    # Minor-protection rules must be complete – otherwise nothing gets installed
    "$ROOT/bin/animestage" selftest >/dev/null 2>&1 || {
        "$ROOT/bin/animestage" selftest || true
        die "$(t "Schutzregeln fehlen oder wurden verändert – Installation abgebrochen (bin/animestage prüfen)")"
    }
    plan
    echo
    confirm "$(t "Installation starten?")" || { say "$(t "Abgebrochen.")"; exit 0; }

    install_files
    # Migrate the previous version – before the first backup, so "original" stays
    # the state before the very first VocaStage installation
    if [[ -d "$CONFIG/vocastage" || -d "$DATA/plasma/plasmoids/org.vocastage.launcher" || -x "$BIN/vocastage" ]]; then
        say "$(t "Übernehme VocaStage")"
        "$BIN/animestage" migrate || warn "$(t "Übernahme unvollständig – Details: %s" "~/.local/state/animestage/animestage.log")"
    fi
    "$BIN/animestage" backup >/dev/null
    say "$(t "Backup angelegt")"

    # Update: existing config (anime, colors, image selection) is kept
    "$BIN/animestage" init >/dev/null
    [[ -n "$LANG_OPT" ]] && "$BIN/animestage" set language "$LANG_OPT" >/dev/null
    if [[ $FETCH -eq 1 ]]; then
        say "$(t "Lade Schrift")"
        "$BIN/animestage" fonts || warn "$(t "Schrift konnte nicht geladen werden")"
    fi
    if [[ -n "$ANIME" ]]; then
        say "$(t "Suche „%s“ auf AniList" "$ANIME")"
        local aid
        aid="$("$BIN/animestage" search "$ANIME" | python3 -c 'import json,sys; r=json.load(sys.stdin); print(r[0]["id"] if r else "")')"
        if [[ -n "$aid" ]]; then
            "$BIN/animestage" anime "$aid" || warn "$(t "Anime konnte nicht eingerichtet werden")"
        else
            warn "$(t "Kein Anime zu „%s“ gefunden – später im Kontrollzentrum suchen" "$ANIME")"
        fi
    fi

    # wallpaper first (colors come from the image), then apply everything
    if [[ "$("$BIN/animestage" get wallswitch.enabled)" == "true" ]]; then
        say "$(t "Starte Hintergrund-Wechsel")"
        "$BIN/animestage" wall on >/dev/null 2>&1 || warn "$(t "Hintergrund-Wechsel: später im Kontrollzentrum starten")"
    elif [[ -n "$ANIME" ]]; then
        "$BIN/animestage" wall next >/dev/null 2>&1 || true
    fi
    say "$(t "Wende Theme an")"
    "$BIN/animestage" apply all
    # daily update check (only if enabled in the config; can be switched off in the Control Center)
    "$BIN/animestage" update sync >/dev/null 2>&1 || true
    if pgrep -x plasmashell >/dev/null; then
        say "$(t "Starte Plasma-Oberfläche neu (lädt aktualisierte Widgets)")"
        restart_plasmashell
        local qd; qd="$(command -v qdbus6 || command -v qdbus-qt6 || echo qdbus)"
        for _ in $(seq 40); do "$qd" org.kde.plasmashell /PlasmaShell >/dev/null 2>&1 && break; sleep 0.5; done
        sleep 2
    fi
    if [[ $TERMINAL -eq 1 ]]; then
        say "$(t "Richte Terminal ein (Begrüßung, Prompt, Aliase)")"
        "$BIN/animestage" terminal on || warn "$(t "Terminal-Einrichtung fehlgeschlagen")"
    fi
    if [[ $PROFILE == full ]]; then
        say "$(t "Setze Panel-Layout")"
        "$BIN/animestage" layout || warn "$(t "Layout fehlgeschlagen – später: %s" "animestage layout")"
    fi

    echo
    printf '%s✓ %s%s\n\n' "$c_acc" "$(t "AnimeStage ist installiert!")" "$c_off"
    echo "  $(t "Los geht's:")       $(t "Startmenü → „AnimeStage Kontrollzentrum“ → Anime → z. B. „Frieren“ suchen")"
    echo "  $(t "Kontrollzentrum:")  plasmawindowed org.animestage.control"
    echo "  $(t "Kommandozeile:")    animestage --help"
    echo "  Status:           ./install.sh --status"
    echo
    echo "  ${c_dim}$(t "Hinweise:")"
    echo "  · $(t "Für Schrift und Fensterrahmen in allen Programmen einmal ab- und wieder anmelden.")"
    echo "  · $(t "Anmeldebildschirm (Plasma Login Manager): Kontrollzentrum → Hintergrund → „Einrichten (einmalig Passwort)“.")"
    echo "  · $(t "Kvantum (optional): über die Paketverwaltung installieren, dann im Kontrollzentrum aktivieren.")${c_off}"
}

do_uninstall() {
    banner
    say "$(t "Entfernt alle AnimeStage-Komponenten und stellt das Original-Backup wieder her.")"
    [[ $PURGE -eq 1 ]] && warn "$(t "--purge: Bilder und Config werden ebenfalls gelöscht.")"
    confirm "$(t "Fortfahren?")" || exit 0

    if [[ -x "$BIN/animestage" ]]; then
        "$BIN/animestage" apps firefox off >/dev/null 2>&1 || true
        "$BIN/animestage" apps vscode off >/dev/null 2>&1 || true
        "$BIN/animestage" unrule >/dev/null 2>&1 || true
        "$BIN/animestage" wall off >/dev/null 2>&1 || true
        "$BIN/animestage" update remove-timer >/dev/null 2>&1 || true
        "$BIN/animestage" terminal off >/dev/null 2>&1 || true
        if [[ -d /var/lib/animestage-login ]]; then
            "$BIN/animestage" login remove || warn "$(t "Anmeldebildschirm: %s manuell ausführen" "animestage login remove")"
        fi
    fi
    if [[ -d "${XDG_STATE_HOME:-$HOME/.local/state}/animestage/backups/original" ]] && [[ -x "$BIN/animestage" ]]; then
        say "$(t "Stelle Originalzustand wieder her")"
        "$BIN/animestage" restore original || warn "$(t "Wiederherstellen fehlgeschlagen")"
    fi
    for w in "${WIDGETS[@]}" "${RETIRED[@]}"; do
        kpackagetool6 -t Plasma/Applet -r "org.animestage.$w" >/dev/null 2>&1 || true
    done
    kpackagetool6 -t Plasma/LookAndFeel -r org.animestage.desktop >/dev/null 2>&1 || true
    if [[ -f "$DATA/icons/Papirus/.animestage" ]]; then
        rm -rf "$DATA/icons/Papirus" "$DATA/icons/Papirus-Dark"
        /usr/libexec/plasma-changeicons breeze-dark >/dev/null 2>&1 || true
    fi
    rm -rf "$DATA/plasma/desktoptheme/AnimeStage" "$DATA/aurorae/themes/AnimeStage" "$CONFIG/Kvantum/AnimeStage" \
           "$DATA/fonts/animestage"
    rm -f "$DATA/color-schemes/AnimeStage.colors" "$DATA/konsole/AnimeStage.colorscheme" "$DATA/konsole/AnimeStage.profile" \
          "$DATA/applications/org.animestage.control.desktop" "$DATA/applications/org.animestage.wall-next.desktop" "$DATA/applications/org.animestage.wall-fav.desktop" "$DATA/icons/hicolor/scalable/apps/animestage.svg" "$DATA/icons/hicolor/scalable/apps/animestage-control.svg"
    if [[ $PURGE -eq 1 ]]; then
        rm -rf "$DATA/animestage" "$CONFIG/animestage" "${XDG_CACHE_HOME:-$HOME/.cache}/animestage"
    else
        rm -rf "$DATA/animestage/logos" "$DATA/animestage/wallpapers" "$DATA/animestage/term-konachan" "$DATA/animestage/themed" "$DATA/animestage/lib" "$DATA/animestage/i18n" "$DATA/animestage/VERSION" "$DATA/animestage/source" \
               "${XDG_CACHE_HOME:-$HOME/.cache}/animestage/update"
    fi
    rm -f "$BIN/animestage"
    say "$(t "Deinstalliert. Backups bleiben unter %s erhalten." "~/.local/state/animestage/")"
}


# ---------------------------------------------------------------- graphical installer
# Windows via kdialog (part of every KDE Plasma). Runs this script in terminal mode
# in the background and shows its steps (lines starting with ▸) as a progress bar.
QDBUS="$(command -v qdbus6 || command -v qdbus-qt6 || command -v qdbus || true)"

gui_terminal_fallback() {
    # no kdialog: open the normal installer in a terminal window
    local cmd=("$ROOT/install.sh" "${@}")
    for term in konsole kitty xterm; do
        if command -v "$term" >/dev/null; then
            case "$term" in
                konsole) exec konsole --hold -e "${cmd[@]}" ;;
                kitty)   exec kitty --hold "${cmd[@]}" ;;
                *)       exec xterm -hold -e "${cmd[@]}" ;;
            esac
        fi
    done
    die "kdialog / konsole not found"
}

gui_pick_language() {
    [[ -n "$LANG_OPT" ]] && return 0
    local cur items choice
    cur="$(python3 -c 'import sys; sys.path.insert(0, sys.argv[1]); import animestage_i18n as i; print(i.system_language())' "$ROOT/lib" 2>/dev/null || echo en)"
    mapfile -t items < <(python3 -c 'import sys; sys.path.insert(0, sys.argv[1]); import animestage_i18n as i
for c, (n, _e) in i.LANGUAGES.items(): print(c + "\t" + n)' "$ROOT/lib")
    local names=() def=""
    for it in "${items[@]}"; do
        names+=("${it#*$'\t'}")
        [[ "${it%%$'\t'*}" == "$cur" ]] && def="${it#*$'\t'}"
    done
    choice="$(kdialog --title "AnimeStage" --combobox "Language · Sprache · 言語" "${names[@]}" --default "${def:-English}")" || exit 0
    for it in "${items[@]}"; do
        [[ "${it#*$'\t'}" == "$choice" ]] && LANG_OPT="${it%%$'\t'*}"
    done
    load_lang
}

# progress window: gui_progress_start TEXT MAX, gui_progress VALUE TEXT, gui_progress_end
gui_progress_start() {
    PROG="$(kdialog --title "AnimeStage" --progressbar "$1" "$2" 2>/dev/null || true)"
}
gui_progress() {
    [[ -n "${PROG:-}" && -n "$QDBUS" ]] || return 0
    # shellcheck disable=SC2086
    "$QDBUS" $PROG Set "" value "$1" >/dev/null 2>&1 || true
    # shellcheck disable=SC2086
    "$QDBUS" $PROG setLabelText "$2" >/dev/null 2>&1 || true
}
gui_progress_end() {
    # shellcheck disable=SC2086
    [[ -n "${PROG:-}" && -n "$QDBUS" ]] && "$QDBUS" $PROG close >/dev/null 2>&1 || true
}

# runs the installer in terminal mode and mirrors its "▸" steps in the progress bar
gui_run() {
    local total="$1"; shift
    local log; log="$(mktemp --tmpdir animestage-install.XXXXXX.log)"
    gui_progress_start "$(t "Bitte warten …")" "$total"
    "$ROOT/install.sh" --yes "$@" >"$log" 2>&1 &
    local pid=$! step=0 seen=0 line
    while kill -0 "$pid" 2>/dev/null; do
        sleep 0.4
        local n; n="$(grep -c '▸' "$log" 2>/dev/null || true)"
        if [[ "${n:-0}" -gt "$seen" ]]; then
            seen="$n"; step=$(( step < total - 1 ? seen : total - 1 ))
            line="$(grep '▸' "$log" | tail -1 | sed 's/\x1b\[[0-9;]*m//g; s/^▸ //')"
            gui_progress "$step" "$line"
        fi
    done
    local rc=0; wait "$pid" || rc=$?
    gui_progress "$total" "$(t "Fertig")"
    gui_progress_end
    GUI_LOG="$log"
    return "$rc"
}

gui_install() {
    command -v kdialog >/dev/null || gui_terminal_fallback
    gui_pick_language
    # language = system language → keep "auto" in the config (follows later system changes)
    local lang_arg="$LANG_OPT"
    [[ "$LANG_OPT" == "$(python3 -c 'import sys; sys.path.insert(0, sys.argv[1]); import animestage_i18n as i; print(i.system_language())' "$ROOT/lib" 2>/dev/null)" ]] && lang_arg="auto"
    local missing
    if ! missing="$(check_tools 2>&1)"; then
        kdialog --title "AnimeStage" --error "$(printf '%s' "$missing" | sed 's/\x1b\[[0-9;]*m//g')"
        exit 1
    fi
    local update=0
    [[ -x "$BIN/animestage" ]] && update=1

    local args=(--lang "$lang_arg")
    if [[ $update -eq 1 ]]; then
        kdialog --title "AnimeStage" --yes-label "$(t "Aktualisieren")" --no-label "$(t "Abbrechen")" \
            --yesno "$(t "AnimeStage ist schon installiert. Auf diese Version aktualisieren?")"$'\n\n'"$(t "Einstellungen, Favoriten und Panel bleiben erhalten; vorher wird ein Backup angelegt.")" || exit 0
        args+=(--profile core)
    else
        kdialog --title "AnimeStage" --yes-label "$(t "Weiter")" --no-label "$(t "Abbrechen")" --yesno \
            "$(t "Willkommen bei AnimeStage!")"$'\n\n'"$(t "AnimeStage macht deinen KDE-Plasma-6-Desktop zu deinem Lieblings-Anime: Hintergründe, Farben, Startmenü, Terminal und Firefox.")"$'\n\n'"$(t "Vorher werden deine KDE-Einstellungen gesichert – die Deinstallation stellt alles wieder her.")" || exit 0
        local panel
        panel="$(kdialog --title "AnimeStage" --radiolist "$(t "Panel (Leiste unten):")" \
            full "$(t "AnimeStage-Panel verwenden (ersetzt dein aktuelles Panel)")" on \
            core "$(t "Mein Panel behalten (Widgets später selbst hinzufügen)")" off)" || exit 0
        args+=(--profile "${panel:-full}")
        local anime
        anime="$(kdialog --title "AnimeStage" --inputbox "$(t "Mit welchem Anime starten? (leer lassen = später im Kontrollzentrum wählen)")" "Frieren")" || exit 0
        [[ -n "$anime" ]] && args+=(--anime "$anime")
        PROFILE="${panel:-full}"; ANIME="$anime"
        kdialog --title "AnimeStage" --yes-label "$(t "Installieren")" --no-label "$(t "Abbrechen")" \
            --yesno "$(plan | sed 's/\x1b\[[0-9;]*m//g')" || exit 0
    fi

    if gui_run 16 "${args[@]}"; then
        local msg
        msg="$(t "AnimeStage ist installiert!")"$'\n\n'"$(t "Für Schrift und Fensterrahmen in allen Programmen einmal ab- und wieder anmelden.")"
        [[ $update -eq 1 ]] && msg="$(t "Update installiert: {version}" | sed "s/{version}/$(cat "$ROOT/VERSION")/")"
        if kdialog --title "AnimeStage" --yes-label "$(t "Kontrollzentrum öffnen")" --no-label "$(t "Schließen")" --yesno "$msg"; then
            (setsid plasmawindowed org.animestage.control >/dev/null 2>&1 &)
        fi
        rm -f "$GUI_LOG"
    else
        kdialog --title "AnimeStage" --detailederror "$(t "Installation fehlgeschlagen.")" \
            "$(sed 's/\x1b\[[0-9;]*m//g' "$GUI_LOG" | tail -40)"
        exit 1
    fi
}

gui_uninstall() {
    command -v kdialog >/dev/null || gui_terminal_fallback --uninstall
    local args=(--uninstall)
    kdialog --title "AnimeStage" --yes-label "$(t "Deinstallieren")" --no-label "$(t "Abbrechen")" --yesno \
        "$(t "AnimeStage entfernen und deine KDE-Einstellungen von vor der Installation wiederherstellen?")" || exit 0
    if kdialog --title "AnimeStage" --yes-label "$(t "Behalten")" --no-label "$(t "Löschen")" --yesno \
        "$(t "Heruntergeladene Bilder, Favoriten und Einstellungen behalten (für eine spätere Neuinstallation)?")"; then :; else
        args+=(--purge)
    fi
    if gui_run 8 "${args[@]}"; then
        kdialog --title "AnimeStage" --msgbox "$(t "AnimeStage wurde entfernt. Danke fürs Ausprobieren!")"
        rm -f "$GUI_LOG"
    else
        kdialog --title "AnimeStage" --detailederror "$(t "Deinstallation fehlgeschlagen.")" \
            "$(sed 's/\x1b\[[0-9;]*m//g' "$GUI_LOG" | tail -40)"
        exit 1
    fi
}

if [[ $GUI -eq 1 ]]; then
    case "$MODE" in
        uninstall) gui_uninstall ;;
        *) gui_install ;;
    esac
    exit 0
fi

case "$MODE" in
    plan) banner; check_tools; plan ;;
    status) if [[ -x "$BIN/animestage" ]]; then "$BIN/animestage" status; else say "$(t "Nicht installiert.")"; fi ;;
    install) do_install ;;
    uninstall) do_uninstall ;;
esac
