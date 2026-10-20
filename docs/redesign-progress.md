# Redesign progress

The complete VLC Redesign interface is being implemented on the
`redesign/full-interface` branch. This is development work, not a finished release.

The reference is the [VLC Redesign Figma file](https://www.figma.com/design/zijws3jGCtz66kKpRdv6Jo/VLC-Redesign--Community-).
The local design export contains 11,613 layers. Measurements and exported icons
are being used for the implementation.

Implemented in the current source:

- Native player playback with the redesigned title bar and transport controls.
- Window-button registration and persistent title buttons outside fullscreen.
- Correct dark foreground for the orange pause button.
- Shared Inter typography, colors, fields, switches, sliders, buttons and dialogs.
- Settings navigation and measured layouts for 12 settings pages.
- A typed bridge to VLC configuration and live audio/video filters.
- The main menu, network-stream dialog and keyboard-shortcut editor.

Still required before a final release:

- Complete the special settings, extension manager and remaining dialog actions.
- Finish the library, queue, onboarding, profiles and player customization.
- Finish the audio, video, subtitle and effects panels.
- Compare every implemented screen with its Figma reference at matching scale.
- Compile and test the complete Windows application, including portrait and
  rotated media, keyboard controls, maximize/restore and fullscreen.
- Package the verified binaries and matching source with release checksums.

Validation so far:

- The settings categories, shortcut editor and network dialog load in an
  isolated Qt 6.8.3 render harness with no QML warnings.
- That harness uses mock media/configuration data and does not establish native
  playback or configuration correctness. Windows integration validation remains
  necessary.

No final release has been published.
