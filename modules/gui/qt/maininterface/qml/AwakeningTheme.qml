// SPDX-License-Identifier: GPL-2.0-or-later
pragma Singleton
import QtQuick
import VLC.MainInterface
import VLC.Style

QtObject {
    readonly property real scale: VLCStyle.scale
    readonly property FontLoader inter: FontLoader { source: "qrc:/awakening/Inter.ttf" }
    readonly property string fontFamily: inter.name
    readonly property int revision: AwakeningPreferences.revision
    readonly property string mode: {
        revision
        return AwakeningPreferences.state("theme", "dark")
    }
    readonly property bool light: mode === "light" || (mode === "system" && Qt.styleHints.colorScheme === Qt.Light)
    readonly property color accent: {
        revision
        return AwakeningPreferences.state("accent", "#d37918")
    }
    readonly property color accentDim: Qt.darker(accent, 1.23)
    readonly property color accentBackground: light ? "#d8ba9a"
        : Qt.colorEqual(accent, "#d37918") ? "#371f06"
        : Qt.rgba(accent.r * 0.26, accent.g * 0.26, accent.b * 0.26, 1)
    readonly property color window: light ? "#acacac" : "#1b1b1b"
    readonly property color panel: light ? "#e7e7e7" : "#0e0e0e"
    readonly property color field: light ? "#dedede" : "#090909"
    readonly property color surface: light ? "#d5d5d5" : "#191919"
    readonly property color selected: light ? "#acacac" : "#222222"
    readonly property color text: light ? "#2e2e2e" : "#8f8f8f"
    readonly property color heading: light ? "#161616" : "#c6c6c6"
    readonly property color bright: light ? "#161616" : "#eaeaea"
    readonly property color muted: "#6b6b6b"
    readonly property color subtle: light ? "#888888" : "#404040"
}
