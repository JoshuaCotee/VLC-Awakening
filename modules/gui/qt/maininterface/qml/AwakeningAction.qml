// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Templates as T
import VLC.MainInterface

T.Button {
    id: control
    property bool accent: false
    readonly property real unit: AwakeningTheme.scale
    implicitWidth: 100 * unit
    implicitHeight: 32 * unit
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    Accessible.name: text
    opacity: enabled ? 1 : 0.4
    background: Rectangle {
        radius: 6 * control.unit
        color: control.accent ? AwakeningTheme.accentBackground
             : control.down || control.checked ? AwakeningTheme.selected
             : control.hovered ? Qt.lighter(AwakeningTheme.surface, 1.3) : AwakeningTheme.surface
        border.width: control.visualFocus ? 1 : 0
        border.color: AwakeningTheme.accent
    }
    contentItem: AwakeningText {
        text: control.text
        color: control.accent ? AwakeningTheme.accent : AwakeningTheme.text
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
    }
}
