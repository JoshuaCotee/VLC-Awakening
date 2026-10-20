// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Templates as T
import VLC.MainInterface

T.ComboBox {
    id: control
    readonly property real unit: AwakeningTheme.scale
    implicitWidth: 320 * unit
    implicitHeight: 36 * unit
    leftPadding: 16 * unit
    rightPadding: 42 * unit
    textRole: "text"
    valueRole: "value"
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    opacity: enabled ? 1 : 0.4
    background: Rectangle {
        color: AwakeningTheme.field
        radius: 6 * control.unit
        border.width: control.visualFocus ? 1 : 0
        border.color: AwakeningTheme.accent
        Rectangle {
            anchors.fill: parent
            anchors.margins: 2 * control.unit
            color: AwakeningTheme.surface
            radius: 4 * control.unit
        }
    }
    contentItem: AwakeningText { text: control.displayText; elide: Text.ElideRight }
    indicator: Image {
        x: control.width - 38 * control.unit
        y: (control.height - height) / 2
        width: 24 * control.unit
        height: width
        source: "qrc:/awakening/design/chevron-down.svg"
        mirror: true
    }
    delegate: C.ItemDelegate {
        required property var modelData
        width: control.width - 4 * control.unit
        height: 36 * control.unit
        highlighted: control.currentValue === modelData.value
        contentItem: AwakeningText {
            text: modelData.text
            color: parent.highlighted ? AwakeningTheme.accent : AwakeningTheme.text
            elide: Text.ElideRight
        }
        background: Rectangle {
            radius: 4 * control.unit
            color: parent.highlighted ? AwakeningTheme.accentBackground
                 : parent.hovered ? AwakeningTheme.selected : AwakeningTheme.surface
        }
    }
    popup: T.Popup {
        y: control.height + 4 * control.unit
        width: control.width
        padding: 2 * control.unit
        implicitHeight: Math.min(contentItem.implicitHeight + 2 * padding, 360 * control.unit)
        background: Rectangle {
            color: AwakeningTheme.surface
            radius: 6 * control.unit
            border.width: 2 * control.unit
            border.color: AwakeningTheme.field
        }
        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            C.ScrollBar.vertical: C.ScrollBar {}
        }
    }
}
