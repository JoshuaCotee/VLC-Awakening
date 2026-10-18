// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Window
import QtQuick.Templates as T
import VLC.Style
import VLC.Widgets as Widgets

T.Button {
    id: control
    property string artwork
    property string description
    property bool accent: false
    property real artworkSize: 24
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
        color: control.accent ? (control.down ? "#b56613" : "#d37918")
                              : (control.down || control.checked ? "#373737" : control.hovered ? "#292929" : "transparent")
        border.width: control.visualFocus ? 1 : 0
        border.color: "#d37918"
    }

    contentItem: Item {
        Image {
            anchors.centerIn: parent
            width: control.artworkSize * control.uiScale
            height: width
            source: "qrc:/awakening/" + control.artwork + ".svg"
            sourceSize: Qt.size(width * Screen.devicePixelRatio, height * Screen.devicePixelRatio)
            fillMode: Image.PreserveAspectFit
            opacity: control.enabled ? 1 : 0.35
        }
    }

    Widgets.ToolTipExt {
        visible: control.hovered || control.visualFocus
        text: control.description
        delay: VLCStyle.delayToolTipAppear
    }
}
