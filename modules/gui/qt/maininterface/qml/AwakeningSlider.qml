// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Templates as T
import VLC.MainInterface

T.Slider {
    id: control
    readonly property real unit: AwakeningTheme.scale
    implicitWidth: 320 * unit
    implicitHeight: 32 * unit
    leftPadding: 0
    rightPadding: 0
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    background: Rectangle {
        x: control.leftPadding
        y: (control.height - height) / 2
        width: control.availableWidth
        height: 14 * control.unit
        radius: 6 * control.unit
        color: AwakeningTheme.field
        border.color: AwakeningTheme.accent
        border.width: control.visualFocus ? 1 : 0
        Rectangle {
            x: 2 * control.unit
            y: 2 * control.unit
            height: parent.height - 4 * control.unit
            width: Math.max(0, control.visualPosition * parent.width - 2 * control.unit)
            radius: 4 * control.unit
            color: AwakeningTheme.accentBackground
        }
    }
    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: (control.height - height) / 2
        width: 8 * control.unit
        height: 24 * control.unit
        radius: 4 * control.unit
        color: AwakeningTheme.accentDim
    }
    T.ToolTip.visible: hovered || pressed
    T.ToolTip.text: Number(value.toFixed(2)).toString()
}
