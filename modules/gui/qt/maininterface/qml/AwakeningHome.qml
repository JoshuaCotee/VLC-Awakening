// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Window
import VLC.MainInterface
import VLC.Player
import VLC.Playlist
import VLC.Dialogs

FocusScope {
    id: root
    readonly property real unit: AwakeningTheme.scale
    Component.onCompleted: AwakeningUi.sidebarVisible = true
    Rectangle { anchors.fill: parent; color: AwakeningTheme.window }
    AwakeningTopBar {
        id: titleBar
        anchors.top: parent.top
        width: parent.width
        textWidth: width
        showCSD: MainCtx.clientSideDecoration && MainCtx.intfMainWindow.visibility !== Window.FullScreen
        playlistVisible: AwakeningUi.sidebarVisible
        onTogglePlaylistVisibility: AwakeningUi.sidebarVisible = !AwakeningUi.sidebarVisible
        onBackRequested: { AwakeningUi.librarySection = "videos"; AwakeningUi.sidebarVisible = true }
    }
    AwakeningLibrary {
        id: library
        anchors.top: titleBar.bottom
        anchors.bottom: controls.top
        width: Math.min(427 * root.unit, root.width - 180 * root.unit)
        visible: AwakeningUi.sidebarVisible
    }
    Item {
        anchors.left: library.visible ? library.right : parent.left
        anchors.right: parent.right
        anchors.top: titleBar.bottom
        anchors.bottom: controls.top
        Rectangle {
            anchors.fill: parent
            anchors.margins: 10 * root.unit
            color: AwakeningTheme.field
            radius: 10 * root.unit
        }
        Column {
            anchors.centerIn: parent
            spacing: 24 * root.unit
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 100 * root.unit; height: width
                source: "qrc:/awakening/design/welcome-logo.svg"
                opacity: 0.25
            }
            AwakeningText { text: qsTr("Drop media here to play"); color: AwakeningTheme.muted }
            AwakeningAction {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Open File(s)")
                onClicked: DialogsProvider.simpleOpenDialog()
            }
        }
    }
    AwakeningControlBar {
        id: controls
        anchors.bottom: parent.bottom
        width: parent.width
        height: implicitHeight
        onTogglePlaylistVisibility: {
            AwakeningUi.librarySection = "queue"
            AwakeningUi.sidebarVisible = true
        }
    }
}
