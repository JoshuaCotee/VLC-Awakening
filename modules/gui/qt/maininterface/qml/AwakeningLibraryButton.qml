// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Templates as T
import VLC.MainInterface

T.Button {
    id: root
    property string artwork
    property string description
    readonly property real unit: AwakeningTheme.scale
    implicitWidth: 30 * unit
    implicitHeight: 32 * unit
    hoverEnabled: true
    padding: 0
    focusPolicy: Qt.StrongFocus
    Accessible.name: description
    opacity: enabled ? 1 : 0.4
    background: Rectangle {
        radius: 4 * root.unit
        color: root.checked ? AwakeningTheme.accentBackground
             : root.hovered || root.down ? AwakeningTheme.selected : "transparent"
        border.width: root.visualFocus ? 1 : 0
        border.color: AwakeningTheme.accent
    }
    contentItem: Item {
        Image {
            anchors.centerIn: parent
            width: 24 * root.unit
            height: width
            source: "qrc:/awakening/library/" + root.artwork + ".svg"
            mirror: ["home", "videos", "streaming", "recent", "back", "forward", "folder", "album", "music", "chevron"].includes(root.artwork)
        }
    }
    C.ToolTip.visible: hovered
    C.ToolTip.text: description
    C.ToolTip.delay: 700
}
