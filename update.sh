#!/usr/bin/env bash
# Update AnimeStage: installs the current project version (control program,
# widgets, Control Center, theme files) and re-applies the theme.
#
# Kept as is: panel layout, character, colors, image selection, favorites,
# wallpaper rotation, terminal and login screen settings.
# A backup is created first (./install.sh --uninstall still restores
# the original state).
#
#   ./update.sh              update
#   ./update.sh --no-fetch   don't download missing default images
exec "$(dirname "$0")/install.sh" --profile core --yes "$@"
