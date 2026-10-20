// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Controls.Basic as C
import VLC.MainInterface
import VLC.MediaLibrary
import VLC.Playlist

AwakeningDialog {
    id: root
    title: qsTr("Open Network Stream")
    dialogName: "network"
    property string error: ""
    property var pendingLinks: []
    function save() {
        const links = urls.text.split(/[\r\n]+/).map(line => line.trim()).filter(line => !!line)
        if (!links.length || links.some(link => !/^[a-zA-Z][a-zA-Z0-9+.-]*:/.test(link))) {
            error = qsTr("Enter a complete stream URL on each line.")
            return
        }
        if (playlistName.text.trim() && MainCtx.mediaLibraryAvailable) {
            pendingLinks = links
            busy = true
            playlists.create(playlistName.text.trim(), links)
        } else {
            MainPlaylistController.append(links, true)
            close()
        }
    }
    MLPlaylistListModel {
        id: playlists
        ml: MainCtx.mediaLibrary
        onCreated: {
            root.busy = false
            MainPlaylistController.append(root.pendingLinks, true)
            root.close()
        }
        onCreationFailed: message => { root.busy = false; root.error = message }
    }
    Flickable {
        anchors.fill: parent
        contentHeight: 509 * root.unit
        clip: true
        C.ScrollBar.vertical: C.ScrollBar {}
        Column {
            x: 20 * root.unit
            y: 22 * root.unit
            width: parent.width - 40 * root.unit
            AwakeningText { text: qsTr("Network URL"); height: 33 * root.unit; font.pixelSize: 16 * root.unit; color: AwakeningTheme.heading }
            AwakeningText { text: qsTr("You can enter multiple links to load."); height: 45 * root.unit }
            C.ScrollView {
                width: parent.width
                height: 194 * root.unit
                C.TextArea {
                    id: urls
                    placeholderText: qsTr("e.g., https://www.example.com/stream.avi")
                    color: AwakeningTheme.text
                    placeholderTextColor: AwakeningTheme.subtle
                    font.family: AwakeningTheme.fontFamily
                    font.pixelSize: 14 * root.unit
                    padding: 14 * root.unit
                    selectByMouse: true
                    wrapMode: TextEdit.Wrap
                    background: Rectangle {
                        radius: 6 * root.unit
                        color: AwakeningTheme.field
                        border.width: 2 * root.unit
                        border.color: urls.activeFocus ? AwakeningTheme.accent : AwakeningTheme.surface
                    }
                }
            }
            Item { width: 1; height: 20 * root.unit }
            Rectangle { width: parent.width; height: root.unit; color: AwakeningTheme.selected }
            Item { width: 1; height: 19 * root.unit }
            AwakeningText { text: qsTr("Playlist Name (optional)"); height: 33 * root.unit; font.pixelSize: 16 * root.unit; color: AwakeningTheme.heading }
            AwakeningText { text: qsTr("The playlist will be saved and displayed with this title."); height: 45 * root.unit }
            AwakeningField {
                id: playlistName
                width: parent.width
                height: 37 * root.unit
                placeholderText: qsTr("e.g., Favorite TV Channels")
                enabled: MainCtx.mediaLibraryAvailable
            }
            AwakeningText { text: root.error; color: AwakeningTheme.accent; height: 40 * root.unit }
        }
    }
    footer: [
        AwakeningAction { x: 20 * root.unit; y: 20 * root.unit; text: qsTr("Cancel"); enabled: !root.busy; onClicked: root.close() },
        AwakeningAction {
            anchors.right: parent.right
            anchors.rightMargin: 20 * root.unit
            y: 20 * root.unit
            text: qsTr("Save")
            accent: true
            enabled: !root.busy
            onClicked: root.save()
        }
    ]
}
