// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Templates as T
import VLC.MainInterface

T.AbstractButton {
    id: control
    readonly property real unit: AwakeningTheme.scale
    implicitWidth: 68 * unit
    implicitHeight: 32 * unit
    checkable: true
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    Accessible.role: Accessible.CheckBox
    Accessible.checked: checked
    opacity: enabled ? 1 : 0.4
    background: Rectangle {
        color: AwakeningTheme.field
        radius: 6 * control.unit
        border.color: AwakeningTheme.accent
        border.width: control.visualFocus ? 1 : 0
    }
    contentItem: Item {
        Rectangle {
            x: (control.checked ? 3 : 32) * control.unit
            y: 3 * control.unit
            width: 33 * control.unit
            height: 26 * control.unit
            radius: 3 * control.unit
            color: control.checked ? AwakeningTheme.accentBackground : AwakeningTheme.surface
        }
        Rectangle {
            x: (control.checked ? 39 : 3) * control.unit
            y: 3 * control.unit
            width: 26 * control.unit
            height: width
            radius: 3 * control.unit
            color: control.checked ? AwakeningTheme.accentDim : AwakeningTheme.subtle
        }
        AwakeningText {
            x: (control.checked ? 10 : 36) * control.unit
            height: parent.height
            text: control.checked ? qsTr("ON") : qsTr("OFF")
            font.pixelSize: 12 * control.unit
            color: control.checked ? AwakeningTheme.accent : AwakeningTheme.muted
        }
    }
}
