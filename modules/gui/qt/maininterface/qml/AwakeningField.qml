// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Templates as T
import VLC.MainInterface

T.TextField {
    id: control
    readonly property real unit: AwakeningTheme.scale
    implicitWidth: 320 * unit
    implicitHeight: 36 * unit
    leftPadding: 14 * unit
    rightPadding: 14 * unit
    color: AwakeningTheme.text
    selectionColor: AwakeningTheme.accentBackground
    selectedTextColor: AwakeningTheme.bright
    placeholderTextColor: AwakeningTheme.subtle
    font.family: AwakeningTheme.fontFamily
    font.pixelSize: 14 * unit
    selectByMouse: true
    opacity: enabled ? 1 : 0.4
    AwakeningText {
        x: control.leftPadding
        width: control.availableWidth
        height: parent.height
        text: control.placeholderText
        color: control.placeholderTextColor
        visible: !control.text && !control.preeditText
        elide: Text.ElideRight
    }
    background: Rectangle {
        radius: 6 * control.unit
        color: AwakeningTheme.field
        border.width: 2 * control.unit
        border.color: control.activeFocus ? AwakeningTheme.accent : AwakeningTheme.surface
    }
}
