// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Window
import QtQuick.Templates as T
import VLC.Style
import VLC.MainInterface

T.Button {
    id: control
    property string artwork
    property string description
    property bool accent: false
    property bool externalHovered: false
    property bool externalPressed: false
    property real artworkSize: 24
    property bool mirroredArtwork: ["sidebar", "folder", "volume"].indexOf(artwork) !== -1
    readonly property real uiScale: VLCStyle.scale

    implicitWidth: 30 * uiScale
    implicitHeight: 32 * uiScale
    padding: 0
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    Accessible.name: description
    Accessible.onPressAction: clicked()

    background: Rectangle {
        radius: 6 * control.uiScale
        color: control.accent ? (control.down || control.externalPressed ? AwakeningTheme.accentDim : AwakeningTheme.accent)
                              : (control.down || control.externalPressed || control.checked ? AwakeningTheme.selected
                                 : control.hovered || control.externalHovered ? AwakeningTheme.surface : "transparent")
        border.width: control.visualFocus ? 1 : 0
        border.color: AwakeningTheme.accent
    }

    contentItem: Item {
        Image {
            anchors.centerIn: parent
            width: control.artworkSize * control.uiScale
            height: width
            source: "qrc:/awakening/" + (AwakeningTheme.light && !["pause", "muted"].includes(control.artwork) ? "light/" : "") + control.artwork + ".svg"
            sourceSize: Qt.size(width * Screen.devicePixelRatio, height * Screen.devicePixelRatio)
            fillMode: Image.PreserveAspectFit
            mirror: control.mirroredArtwork
            opacity: control.enabled ? 1 : 0.35
        }
    }

    T.ToolTip.visible: control.hovered || control.externalHovered || control.visualFocus
    T.ToolTip.text: control.description
    T.ToolTip.delay: VLCStyle.delayToolTipAppear
}
