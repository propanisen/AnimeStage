#!/usr/bin/env bash
# AnimeStage one-line install (downloads the latest release and starts the installer):
#   curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
# Extra options are passed to install.sh, e.g.  … | bash -s -- --gui   or   --lang ja
set -euo pipefail
REPO="propanisen/AnimeStage"
tag="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$REPO/releases/latest")"
tag="${tag##*/}"
[[ "$tag" == v* ]] || { echo "AnimeStage: no release found" >&2; exit 1; }
dir="$(mktemp -d --tmpdir animestage-get.XXXXXX)"
echo "▸ AnimeStage $tag"
curl -fsSL "https://github.com/$REPO/archive/refs/tags/$tag.tar.gz" | tar -xz -C "$dir"
cd "$dir"/*/
# the installer copies itself to ~/.local/share/animestage/source, the download can go away
trap 'rm -rf "$dir"' EXIT
if [[ -r /dev/tty ]] && [[ " $* " != *" --gui "* ]]; then
    bash ./install.sh "$@" </dev/tty
else
    bash ./install.sh --gui "$@"
fi
