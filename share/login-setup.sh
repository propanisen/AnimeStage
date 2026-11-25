#!/bin/bash
# AnimeStage – wallpaper on the login screen too (Plasma Login Manager).
# Runs once as root via pkexec:  animestage login setup | remove
#
# The login screen runs as user "plasmalogin" and may not read your home
# directory. So AnimeStage puts every new wallpaper into
# /var/lib/animestage-login (owned by you), and a small systemd path unit
# copies it from there into plasmalogin's wallpaper directory.
set -euo pipefail

action="${1:?install|remove}"
user="${2:?Benutzername}"
id "$user" >/dev/null

SRC=/var/lib/animestage-login
HOME_PL="$(getent passwd plasmalogin | cut -d: -f6)"
[[ -n "$HOME_PL" ]] || { echo "Benutzer plasmalogin fehlt" >&2; exit 1; }
DEST_DIR="$HOME_PL/wallpapers"
DEST="$DEST_DIR/animestage.jpg"
CONF=/etc/plasmalogin.conf.d/90-animestage.conf
UNIT=/etc/systemd/system/animestage-login-wallpaper

# remove leftovers of the previous version (VocaStage)
systemctl disable --now vocastage-login-wallpaper.path 2>/dev/null || true
rm -f /etc/systemd/system/vocastage-login-wallpaper.service /etc/systemd/system/vocastage-login-wallpaper.path \
      /etc/plasmalogin.conf.d/90-vocastage.conf "$DEST_DIR/vocastage.jpg"
rm -rf /var/lib/vocastage-login

if [[ "$action" == install ]]; then
    install -d -o "$user" -g "$(id -gn "$user")" -m 755 "$SRC"
    install -d -o plasmalogin -g plasmalogin -m 755 "$DEST_DIR"

    cat > "$UNIT.service" <<EOF
[Unit]
Description=AnimeStage: copy wallpaper for the login screen
ConditionPathExists=$SRC/wallpaper.jpg

[Service]
Type=oneshot
ExecStart=/usr/bin/install -o plasmalogin -g plasmalogin -m 644 $SRC/wallpaper.jpg $DEST
ExecStartPost=-/usr/sbin/restorecon $DEST
EOF
    cat > "$UNIT.path" <<EOF
[Unit]
Description=AnimeStage: Anmelde-Hintergrund beobachten

[Path]
PathChanged=$SRC/wallpaper.jpg
Unit=animestage-login-wallpaper.service

[Install]
WantedBy=multi-user.target
EOF
    mkdir -p /etc/plasmalogin.conf.d
    cat > "$CONF" <<EOF
# AnimeStage – remove with: animestage login remove
[Greeter]
WallpaperPlugin=org.kde.image
WallpaperPluginId=org.kde.image

[Greeter][Wallpaper][org.kde.image][General]
Image=file://$DEST
PreviewImage=file://$DEST
EOF
    systemctl daemon-reload
    systemctl enable --now animestage-login-wallpaper.path
    echo "eingerichtet"
else
    systemctl disable --now animestage-login-wallpaper.path 2>/dev/null || true
    rm -f "$UNIT.service" "$UNIT.path" "$CONF" "$DEST"
    rm -rf "$SRC"
    systemctl daemon-reload
    echo "entfernt"
fi
