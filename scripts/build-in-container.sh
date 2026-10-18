#!/usr/bin/env bash
set -euo pipefail

mkdir -p /work/vlc /output/vlc-awakening
tar -C /source --exclude=./.git --exclude=./.local --exclude=./dist -cf - . |
    tar -C /work/vlc -xf -
cd /work/vlc
if [ "$(cat src/revision.txt 2>/dev/null || true)" != "$VLC_REVISION" ]; then
    printf '%s\n' "$VLC_REVISION" > src/revision.txt
fi

export CONFIGFLAGS="--disable-update-check --disable-skins2 ${CONFIGFLAGS:-}"
if [ ! -f win64/config.status ] || [ "${FULL_BUILD:-0}" = 1 ]; then
    extras/package/win32/build.sh -a x86_64 -p -o /work/install
else
    make -C win64 -j"$JOBS"
    make -C win64 package-win-common
fi

cp -a /work/install/. /output/vlc-awakening/
mkdir -p /output/vlc-awakening/portable
printf '%s\n' "$VLC_REVISION" > /output/vlc-awakening/BUILD.txt
printf 'Windows build ready: dist/vlc-awakening/vlc.exe\n'
