// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Templates as T
import VLC.MainInterface
import VLC.MediaLibrary

AwakeningDialog {
    id: root
    title: qsTr("New Playlist")
    dialogName: "newPlaylist"
    designWidth: 713
    designHeight: 589
    property var files: []
    property url artwork: ""
    property string error: ""
    property bool saving: false
    busy: saving
    dialogColor: AwakeningTheme.surface
    function addFiles(urls) {
        const result = files.slice()
        for (let i = 0; i < urls.length; ++i) {
            const url = String(urls[i])
            if (!result.includes(url)) result.push(url)
        }
        files = result
    }
    function save() {
        if (!playlistName.text.trim()) {
            error = qsTr("Enter a playlist name.")
            playlistName.forceActiveFocus()
            return
        }
        if (!MainCtx.mediaLibraryAvailable) {
            error = qsTr("Enable the media library in Settings to save playlists.")
            return
        }
        saving = true
        playlists.create(playlistName.text.trim(), files)
    }
    MLPlaylistListModel {
        id: playlists
        ml: MainCtx.mediaLibrary
        onCreated: playlistId => {
            if (String(root.artwork))
                AwakeningPreferences.setState("playlistArtwork/" + playlistId.toString(), String(root.artwork))
            root.saving = false
            AwakeningUi.openLibrary("playlists")
            root.close()
        }
        onCreationFailed: message => { root.saving = false; root.error = message }
    }
    Flickable {
        anchors.fill: parent
        contentHeight: 467 * root.unit
        clip: true
        C.ScrollBar.vertical: C.ScrollBar {}
        Item {
            x: 20 * root.unit
            y: 22 * root.unit
            width: parent.width - 40 * root.unit
            height: 119 * root.unit
            AwakeningText {
                width: parent.width - 132 * root.unit; height: 28 * root.unit
                text: qsTr("Playlist Details"); font.pixelSize: 16 * root.unit; color: AwakeningTheme.heading
            }
            AwakeningText {
                y: 33 * root.unit; width: parent.width - 132 * root.unit; height: 25 * root.unit
                text: qsTr("The playlist will be saved and displayed with this title and thumbnail.")
                color: AwakeningTheme.muted
                elide: Text.ElideRight
            }
            AwakeningField {
                id: playlistName
                y: 80 * root.unit; width: parent.width - 132 * root.unit; height: 37 * root.unit
                placeholderText: qsTr("e.g., Favorite Videos")
                onAccepted: root.save()
            }
            T.Button {
                anchors.right: parent.right
                y: 7 * root.unit; width: 112 * root.unit; height: width
                Accessible.name: qsTr("Choose thumbnail")
                onClicked: {
                    const selected = AwakeningPreferences.chooseArtwork()
                    if (String(selected)) root.artwork = selected
                }
                background: Rectangle { color: AwakeningTheme.field; radius: 6 * root.unit }
                contentItem: Item {
                    Image { anchors.fill: parent; source: root.artwork; fillMode: Image.PreserveAspectCrop }
                    Rectangle {
                        anchors.centerIn: parent; width: 30 * root.unit; height: width
                        color: AwakeningTheme.surface; radius: 4 * root.unit
                        visible: !String(root.artwork)
                        Image { anchors.centerIn: parent; width: 24 * root.unit; height: width; source: "qrc:/awakening/library/add.svg" }
                    }
                }
            }
        }
        Rectangle { x: 20 * root.unit; y: 161 * root.unit; width: parent.width - 40 * root.unit; height: root.unit; color: AwakeningTheme.selected }
        AwakeningText {
            x: 20 * root.unit; y: 181 * root.unit; height: 28 * root.unit
            text: qsTr("Select Files"); font.pixelSize: 16 * root.unit; color: AwakeningTheme.heading
        }
        AwakeningText {
            x: 20 * root.unit; y: 214 * root.unit; height: 25 * root.unit
            text: qsTr("These files will be added to the playlist.")
            color: AwakeningTheme.muted
        }
        Rectangle {
            x: 20 * root.unit; y: 259 * root.unit
            width: parent.width - 40 * root.unit; height: 186 * root.unit
            color: AwakeningTheme.field; radius: 6 * root.unit
            border.width: drop.containsDrag ? 2 * root.unit : 0
            border.color: AwakeningTheme.accent
            T.Button {
                anchors.fill: parent
                visible: !root.files.length
                Accessible.name: qsTr("Select media files")
                onClicked: root.addFiles(AwakeningPreferences.chooseMediaFiles())
                contentItem: Item {
                    AwakeningText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 59.5 * root.unit
                        text: qsTr("Drag files into the box or click here to select files.")
                        color: AwakeningTheme.subtle
                    }
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 96.5 * root.unit; width: 84 * root.unit; height: 30 * root.unit
                        color: AwakeningTheme.surface; radius: 4 * root.unit
                        Image { anchors.centerIn: parent; width: 24 * root.unit; height: width; source: "qrc:/awakening/library/add.svg" }
                    }
                }
                background: Item {}
            }
            ListView {
                anchors.fill: parent
                anchors.margins: 10 * root.unit
                visible: root.files.length > 0
                clip: true
                model: root.files
                C.ScrollBar.vertical: C.ScrollBar {}
                delegate: Row {
                    required property string modelData
                    required property int index
                    width: ListView.view.width; height: 32 * root.unit
                    AwakeningText {
                        width: parent.width - 32 * root.unit; height: parent.height
                        text: decodeURIComponent(modelData.split("/").pop()); elide: Text.ElideMiddle
                    }
                    AwakeningLibraryButton {
                        width: 32 * root.unit; artwork: "add"; rotation: 45
                        description: qsTr("Remove file")
                        onClicked: { const next = root.files.slice(); next.splice(index, 1); root.files = next }
                    }
                }
                footer: AwakeningAction { text: qsTr("Add files"); onClicked: root.addFiles(AwakeningPreferences.chooseMediaFiles()) }
            }
            DropArea {
                id: drop
                anchors.fill: parent
                onDropped: event => {
                    if (event.hasUrls) { root.addFiles(event.urls); event.acceptProposedAction() }
                }
            }
        }
    }
    footer: [
        AwakeningAction { x: 20 * root.unit; y: 20 * root.unit; text: qsTr("Cancel"); enabled: !root.saving; onClicked: root.close() },
        AwakeningText {
            x: 135 * root.unit; y: 12 * root.unit; width: parent.width - 270 * root.unit; height: 48 * root.unit
            text: root.error; wrapMode: Text.Wrap; color: AwakeningTheme.accent
        },
        AwakeningAction {
            anchors.right: parent.right; anchors.rightMargin: 20 * root.unit; y: 20 * root.unit
            text: root.saving ? qsTr("Saving...") : qsTr("Save")
            enabled: !root.saving && !!playlistName.text.trim(); accent: true; onClicked: root.save()
        }
    ]
}
