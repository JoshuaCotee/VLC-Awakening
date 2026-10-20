// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Templates as T
import VLC.MainInterface
import VLC.Dialogs

T.Popup {
    id: root
    readonly property real unit: AwakeningTheme.scale
    width: 375 * unit
    height: Math.min(585 * unit, parent.height > 100 ? parent.height : MainCtx.intfMainWindow.height - 52 * unit)
    padding: 4 * unit
    focus: true
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside
    background: Rectangle {
        radius: 6 * root.unit
        color: AwakeningTheme.panel
        border.width: root.unit
        border.color: AwakeningTheme.selected
    }
    function activate(action) {
        close()
        switch (action) {
        case "file": DialogsProvider.simpleOpenDialog(); break
        case "folder": DialogsProvider.PLOpenDir(); break
        case "stream": AwakeningUi.dialog = "network"; break
        case "disc": DialogsProvider.openDiscDialog(); break
        case "capture": DialogsProvider.openCaptureDialog(); break
        case "convert": DialogsProvider.openAndTranscodingDialogs(); break
        case "recent": AwakeningUi.librarySection = "recent"; AwakeningUi.sidebarVisible = true; break
        case "settings": AwakeningUi.showSettings(); break
        case "about": DialogsProvider.aboutDialog(); break
        default: AwakeningUi.dialog = action
        }
    }
    contentItem: Flickable {
        clip: true
        contentHeight: entries.height
        boundsBehavior: Flickable.StopAtBounds
        C.ScrollBar.vertical: C.ScrollBar {}
        Column {
            id: entries
            width: parent.width
            Repeater {
                model: [
                    {id: "file", label: qsTr("Open File(s)"), key: "Ctrl + O"},
                    {id: "folder", label: qsTr("Open Folder"), key: "Ctrl + F"},
                    {id: "stream", label: qsTr("Open Network Stream"), key: "Ctrl + N"},
                    {id: "disc", label: qsTr("Open Disc"), key: "Ctrl + D"},
                    {id: "capture", label: qsTr("Open Capture Device"), key: "Ctrl + C"},
                    {id: "convert", label: qsTr("Convert"), key: "Ctrl + R"},
                    {id: "recent", label: qsTr("Open Recent")},
                    {id: "separator"},
                    {id: "profile", label: qsTr("Profile (%1)").arg(AwakeningPreferences.state("profile", qsTr("Default")))},
                    {id: "shortcuts", label: qsTr("Keyboard Shortcuts")},
                    {id: "customize", label: qsTr("Customize Player")},
                    {id: "settings", label: qsTr("Settings"), key: "Ctrl + P"},
                    {id: "about", label: qsTr("About VLC"), key: "Shift + F1"}
                ]
                T.Button {
                    id: entry
                    required property var modelData
                    width: entries.width
                    height: (modelData.id === "separator" ? 1 : 48) * root.unit
                    enabled: modelData.id !== "separator"
                    hoverEnabled: true
                    Accessible.name: modelData.label || ""
                    onClicked: root.activate(modelData.id)
                    background: Rectangle {
                        radius: 4 * root.unit
                        color: entry.modelData.id === "separator" ? AwakeningTheme.selected
                             : entry.hovered || entry.visualFocus ? AwakeningTheme.surface : "transparent"
                    }
                    contentItem: Item {
                        visible: entry.modelData.id !== "separator"
                        Image {
                            x: 14 * root.unit
                            anchors.verticalCenter: parent.verticalCenter
                            width: 24 * root.unit
                            height: width
                            source: visible ? "qrc:/awakening/design/menu-" + entry.modelData.id + ".svg" : ""
                            mirror: ["folder", "stream", "recent", "customize"].includes(entry.modelData.id)
                            rotation: entry.modelData.id === "convert" ? 90 : 0
                        }
                        AwakeningText {
                            x: 48 * root.unit
                            height: parent.height
                            text: entry.modelData.label || ""
                        }
                        AwakeningText {
                            anchors.right: parent.right
                            anchors.rightMargin: 14 * root.unit
                            height: parent.height
                            text: entry.modelData.key || ""
                            color: AwakeningTheme.muted
                        }
                        Image {
                            anchors.right: parent.right
                            anchors.rightMargin: 14 * root.unit
                            anchors.verticalCenter: parent.verticalCenter
                            visible: !entry.modelData.key
                            width: 24 * root.unit
                            height: width
                            source: "qrc:/awakening/design/chevron-right.svg"
                        }
                    }
                }
            }
        }
    }
}
