// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Templates as T
import VLC.MainInterface

T.Popup {
    id: root
    property string title
    property string dialogName
    property real designWidth: 1048
    property real designHeight: 631
    readonly property real unit: AwakeningTheme.scale
    default property alias body: bodyItem.data
    property alias headerExtra: headerExtra.data
    property alias footer: footerItem.data
    property real headerHeight: 50
    property real footerHeight: 72
    property bool busy: false
    property color dialogColor: AwakeningTheme.panel
    width: Math.min(designWidth * unit, parent.width - 32 * unit)
    height: Math.min(designHeight * unit, parent.height - 32 * unit)
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    padding: 0
    modal: true
    focus: true
    visible: AwakeningUi.dialog === dialogName
    closePolicy: busy ? T.Popup.NoAutoClose : T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside
    onOpened: MainCtx.preferHotkeys = false
    onClosed: {
        MainCtx.preferHotkeys = MainCtx.playerView
        if (AwakeningUi.dialog === dialogName) AwakeningUi.dialog = ""
    }
    background: Rectangle { color: root.dialogColor; radius: 14 * root.unit }
    contentItem: Item {
        Rectangle {
            width: parent.width
            height: root.headerHeight * root.unit
            color: AwakeningTheme.field
            radius: 14 * root.unit
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 14 * root.unit
                color: parent.color
            }
            AwakeningText {
                x: 19 * root.unit
                width: parent.width - 80 * root.unit
                height: 50 * root.unit
                text: root.title
            }
            T.Button {
                x: parent.width - 41 * root.unit
                y: 9 * root.unit
                width: 32 * root.unit
                height: width
                padding: 4 * root.unit
                Accessible.name: qsTr("Close")
                enabled: !root.busy
                onClicked: root.close()
                contentItem: Image { source: "qrc:/awakening/design/close.svg" }
                background: Rectangle { radius: 4 * root.unit; color: parent.hovered ? AwakeningTheme.surface : "transparent" }
            }
            Item { id: headerExtra; anchors.fill: parent }
        }
        Item {
            id: bodyItem
            y: root.headerHeight * root.unit
            width: parent.width
            height: parent.height - y - root.footerHeight * root.unit
            clip: true
        }
        Item {
            id: footerItem
            anchors.bottom: parent.bottom
            width: parent.width
            height: root.footerHeight * root.unit
        }
    }
}
