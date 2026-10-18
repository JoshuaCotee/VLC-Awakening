# VLC Awakening

VLC Awakening is a Windows-first fork of VLC. The first milestone replaces the main player interface with a native Qt/QML implementation of Juxtopposed's VLC Redesign. Playback continues through VLC's existing engine.

## Design reference

Original design: https://www.figma.com/community/file/1691465999134370980/vlc-redesign

The player follows frame `247:445`: a 40 px title bar, 54 px control bar, 24 px icons, Inter text, dark surfaces, and the orange accent `#D37918`. The layout adapts at smaller widths so the main controls remain usable.

The Figma icons in `modules/gui/qt/pixmaps/awakening` are exported assets. Movie frames, example filenames, and library thumbnails from the mockup are sample content and are not bundled as application content.

Design copyright belongs to Juxtopposed. The design is used under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Changes include the project name, responsive sizing, and integration with VLC's playback controls. This fork is independent of VideoLAN and Juxtopposed and does not imply their endorsement.

Inter is by the Inter Project authors and is distributed under the SIL Open Font License. Its license is included alongside the font.

## First milestone

The new title bar and controls connect to VLC's native playback and playlist controllers. Audio and subtitle selection, playback settings, the media library, and the queue currently open VLC's existing interfaces. Those screens will receive their own design pass after the player is verified.

This milestone makes no performance claims and does not rewrite the playback engine.

## Build

The build uses VideoLAN's Windows cross-compilation image and matching prebuilt dependencies. The compiler runs inside a Linux Docker container and produces a Windows x64 executable.

The compiler image and dependency revision are pinned in `scripts/build-windows.sh`. Legacy skins and the upstream automatic updater are disabled for this fork. The portable package includes the compiler runtime libraries required by its plugins.

On Windows, with Ubuntu 24.04 in WSL and Docker available inside Ubuntu:

```powershell
./scripts/build-windows.ps1
```

On Linux, with Docker:

```sh
bash scripts/build-windows.sh
```

The output is `dist/vlc-awakening/vlc.exe`. Keep the entire output folder together. The adjacent `portable` folder keeps this build's settings separate from an installed VLC.

The first build downloads the compiler image and roughly 650 MB of dependencies. Later builds reuse the `vlc-awakening-build` Docker volume. Set `JOBS` to control the number of compiler processes.

GitHub Actions provides the same build through the **Windows build** workflow. Its downloadable artifact contains the complete portable folder. Only a successful workflow run confirms that an artifact has been produced.

## Validation

Before publishing a binary release, check opening local video, frame progression, pause/resume, seek, volume/mute, subtitles, fullscreen, keyboard shortcuts, resizing, and closing. Record the exact source commit and any remaining issues with the release.
