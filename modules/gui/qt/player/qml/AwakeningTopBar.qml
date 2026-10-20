// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Templates as T
import VLC.MainInterface
import VLC.Player
import VLC.Style
import VLC.Menus as Menus
import VLC.Widgets as Widgets
import VLC.Util

FocusScope {
    id: root
    required property int textWidth
    property Item plListView
    property int topMargin: 0
    property int sideMargin: 0
    property string title
    property bool showCSD: false
    property bool showToolbar: false
    property bool pinControls: false
    property bool playlistVisible: false
    property alias resumeVisible: resumeDialog.visible
    readonly property int reservedHeight: height
    readonly property real uiScale: VLCStyle.scale
    readonly property ColorContext colorContext: ColorContext {
        palette: VLCStyle.darkPalette
        colorSet: ColorContext.Window
    }
    signal togglePlaylistVisibility()
    signal requestLockUnlockAutoHide(bool lock)
    signal backRequested()
    signal forceUnlock()
    onForceUnlock: contextMenu.close()

    implicitHeight: 40 * uiScale + topMargin
    height: implicitHeight
    Accessible.role: Accessible.ToolBar
    Accessible.name: qsTr("Player title bar")
    FontLoader { id: inter; source: "qrc:/awakening/Inter.ttf" }
    Rectangle { anchors.fill: parent; color: "#1b1b1b" }
    Loader {
        anchors.fill: parent
        active: root.showCSD
        source: "qrc:///qt/qml/VLC/Widgets/CSDTitlebarTapNDrapHandler.qml"
    }

    RowLayout {
        id: leftButtons
        anchors.left: parent.left
        anchors.leftMargin: 6 * root.uiScale + root.sideMargin
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0
        AwakeningButton {
            artwork: "logo"
            Layout.preferredWidth: 38 * root.uiScale
            Layout.rightMargin: 7 * root.uiScale
            description: qsTr("VLC menu")
            onClicked: contextMenu.open()
        }
        AwakeningButton {
            artwork: "more"
            Layout.preferredWidth: 28 * root.uiScale
            Layout.rightMargin: 10 * root.uiScale
            artworkSize: 18
            description: qsTr("Menu")
            onClicked: contextMenu.open()
        }
        AwakeningButton {
            artwork: "sidebar"
            Layout.preferredWidth: 28 * root.uiScale
            description: qsTr("Toggle play queue")
            checked: root.playlistVisible
            onClicked: root.togglePlaylistVisibility()
        }
        Image {
            visible: root.width > 650 * root.uiScale
            source: "qrc:/awakening/divider.svg"
            Layout.preferredWidth: 24 * root.uiScale
            Layout.preferredHeight: 24 * root.uiScale
        }
        AwakeningButton {
            artwork: "folder"
            Layout.preferredWidth: 28 * root.uiScale
            description: qsTr("Media library")
            visible: root.width > 650 * root.uiScale
            onClicked: root.backRequested()
        }
        T.Label {
            Layout.leftMargin: 4 * root.uiScale
            visible: root.width > 750 * root.uiScale
            text: qsTr("Videos")
            color: "#8f8f8f"
            font.family: inter.name
            font.pixelSize: 14 * root.uiScale
            TapHandler { onTapped: root.backRequested() }
        }
    }

    T.Label {
        anchors.centerIn: parent
        width: Math.max(0, parent.width - 2 * Math.max(leftButtons.width + 20 * root.uiScale, windowButtons.width))
        text: "VLC Awakening"
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
        color: "#8f8f8f"
        font.family: inter.name
        font.pixelSize: 14 * root.uiScale
    }

    Row {
        id: windowButtons
        anchors.right: parent.right
        anchors.rightMargin: 6 * root.uiScale + root.sideMargin
        anchors.verticalCenter: parent.verticalCenter
        visible: root.showCSD
        enabled: visible
        Repeater {
            model: MainCtx.csdButtonModel.windowCSDButtons
            Row {
                id: buttonRow
                required property var modelData
                AwakeningButton {
                    visible: buttonRow.modelData.type === CSDButton.Close
                    width: visible ? 36 * root.uiScale : 0
                    artwork: "fullscreen"
                    description: qsTr("Fullscreen (F)")
                    onClicked: Player.fullscreen = !Player.fullscreen
                }
                AwakeningButton {
                    id: windowButton
                    width: 36 * root.uiScale
                    externalHovered: buttonRow.modelData.showHovered
                    externalPressed: buttonRow.modelData.externalPressed
                    artwork: buttonRow.modelData.type === CSDButton.Minimize ? "minimize"
                           : buttonRow.modelData.type === CSDButton.MaximizeRestore ? "maximize" : "close"
                    description: buttonRow.modelData.type === CSDButton.Minimize ? qsTr("Minimize")
                               : buttonRow.modelData.type === CSDButton.MaximizeRestore ? qsTr("Maximize or restore") : qsTr("Close")
                    onClicked: buttonRow.modelData.click()
                    function updateRect() {
                        const point = mapToItem(null, 0, 0)
                        buttonRow.modelData.rect = Qt.rect(point.x, point.y, width, height)
                    }
                    Component.onCompleted: {
                        buttonRow.modelData.registerItem(windowButton)
                        Qt.callLater(updateRect)
                    }
                    onXChanged: Qt.callLater(updateRect)
                    onYChanged: Qt.callLater(updateRect)
                    onWidthChanged: Qt.callLater(updateRect)
                    onHeightChanged: Qt.callLater(updateRect)
                    onVisibleChanged: Qt.callLater(updateRect)
                    Connections {
                        target: root
                        function onWidthChanged() { Qt.callLater(windowButton.updateRect) }
                        function onHeightChanged() { Qt.callLater(windowButton.updateRect) }
                        function onSideMarginChanged() { Qt.callLater(windowButton.updateRect) }
                    }
                    Connections {
                        target: VLCStyle
                        function onAppWidthChanged() { Qt.callLater(windowButton.updateRect) }
                        function onAppHeightChanged() { Qt.callLater(windowButton.updateRect) }
                    }
                    Connections {
                        target: MainCtx.intfMainWindow
                        function onVisibilityChanged() { Qt.callLater(windowButton.updateRect) }
                    }
                }
            }
        }
    }

    AwakeningMenu {
        id: contextMenu
        x: 6 * root.uiScale
        y: root.height
        onAboutToShow: root.requestLockUnlockAutoHide(true)
        onAboutToHide: root.requestLockUnlockAutoHide(false)
    }
    ResumeDialog {
        id: resumeDialog
        x: 20 * root.uiScale
        y: root.height + 12 * root.uiScale
        maxWidth: Math.max(0, root.width - 40 * root.uiScale)
        width: maxWidth
        onVisibleChanged: root.requestLockUnlockAutoHide(visible)
    }
}
