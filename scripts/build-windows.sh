#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE="registry.videolan.org/vlc-debian-win64-posix:20260611225331"
VOLUME="vlc-awakening-build"
JOBS="${JOBS:-4}"

git_source() { git -c safe.directory="$ROOT" -C "$ROOT" "$@"; }
CONTRIB_SHA="${VLC_CONTRIB_REVISION:-7ee44ffc93821fee267b5d35fa2b1719bb790880}"
REVISION="$(git_source rev-parse --short=12 HEAD)-awakening"
CONTRIB_URL="https://artifacts.videolan.org/vlc/win64/vlc-contrib-x86_64-w64-mingw32-${CONTRIB_SHA}.tar.zst"

mkdir -p "$ROOT/dist"
docker volume create "$VOLUME" >/dev/null
docker run --rm --user root --name vlc-awakening-builder \
    --mount "type=volume,source=$VOLUME,target=/work" \
    --mount "type=bind,source=$ROOT,target=/source,readonly" \
    --mount "type=bind,source=$ROOT/dist,target=/output" \
    -e "JOBS=$JOBS" -e "VLC_REVISION=$REVISION" -e "FULL_BUILD=${FULL_BUILD:-0}" \
    -e "VLC_PREBUILT_CONTRIBS_URL=$CONTRIB_URL" \
    "$IMAGE" bash /source/scripts/build-in-container.sh
