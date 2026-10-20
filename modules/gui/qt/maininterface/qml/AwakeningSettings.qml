// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import QtQuick.Templates as T
import VLC.MainInterface
import VLC.Dialogs
import VLC.MediaLibrary
import VLC.Player
import VLC.Playlist

T.Popup {
    id: root
    readonly property real unit: AwakeningTheme.scale
    readonly property string category: AwakeningUi.settingsCategory
    readonly property var page: AwakeningSettingsData.pages[category] || AwakeningSettingsData.pages.general
    readonly property var categories: [
        {heading: qsTr("App")},
        {id: "general", text: qsTr("General")}, {id: "interface", text: qsTr("Interface")},
        {id: "privacy", text: qsTr("Privacy")}, {id: "controls", text: qsTr("Controls")},
        {heading: qsTr("Media")},
        {id: "playback", text: qsTr("Playback")}, {id: "video", text: qsTr("Video")},
        {id: "audio", text: qsTr("Audio")}, {id: "subtitles", text: qsTr("Subtitles")},
        {id: "library", text: qsTr("Library")},
        {heading: qsTr("System")},
        {id: "network", text: qsTr("Network")}, {id: "performance", text: qsTr("Performance")},
        {id: "recording", text: qsTr("Recording")}, {id: "extensions", text: qsTr("Extensions")}
    ]
    width: Math.min(1048 * unit, parent.width - 32 * unit)
    height: Math.min(865 * unit, parent.height - 32 * unit)
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    padding: 0
    modal: true
    focus: true
    visible: AwakeningUi.dialog === "settings"
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside
    onOpened: MainCtx.preferHotkeys = false
    onClosed: {
        MainCtx.preferHotkeys = MainCtx.playerView
        AwakeningPreferences.save()
        if (AwakeningUi.dialog === "settings") AwakeningUi.dialog = ""
    }
    onCategoryChanged: contentScroll.contentY = 0
    background: Rectangle { color: AwakeningTheme.panel; radius: 14 * root.unit }

    function readSpecial(name) {
        switch (name) {
        case "theme": return AwakeningPreferences.state("theme", "dark")
        case "accent": return AwakeningPreferences.state("accent", "#d37918")
        case "repeat": return AwakeningPreferences.value("repeat") ? "one" : AwakeningPreferences.value("loop") ? "all" : "off"
        case "finishAction": return AwakeningPreferences.value("play-and-exit") ? "quit" : "stop"
        case "rememberGeometry": return AwakeningPreferences.state("rememberGeometry", true)
        case "nightMode": return AwakeningPreferences.filterEnabled("audio-filter", "compressor")
        case "snapshotSize": return AwakeningPreferences.value("snapshot-width") + "x" + AwakeningPreferences.value("snapshot-height")
        case "buffering": {
            const value = AwakeningPreferences.value("network-caching")
            return value === 1000 ? "normal" : value === 300 ? "low" : value === 3000 ? "high" : "custom"
        }
        default: return undefined
        }
    }
    function specialChoices(name) {
        switch (name) {
        case "theme": return [{text: qsTr("Dark"), value: "dark"}, {text: qsTr("Light"), value: "light"}, {text: qsTr("System"), value: "system"}]
        case "repeat": return [{text: qsTr("Off"), value: "off"}, {text: qsTr("Repeat one"), value: "one"}, {text: qsTr("Repeat all"), value: "all"}]
        case "finishAction": return [{text: qsTr("Stop"), value: "stop"}, {text: qsTr("Quit"), value: "quit"}]
        case "buffering": return [{text: qsTr("Low latency"), value: "low"}, {text: qsTr("Normal"), value: "normal"}, {text: qsTr("High latency"), value: "high"}, {text: qsTr("Custom"), value: "custom"}]
        case "snapshotSize": return [{text: qsTr("Same as video"), value: "-1x-1"}, {text: "1920 x 1080", value: "1920x1080"}, {text: "1280 x 720", value: "1280x720"}]
        default: return []
        }
    }
    function specialDescription(name) {
        if (name === "theme" || name === "accent") return qsTr("Changes apply immediately.")
        if (name === "buffering") return qsTr("Sets caching for local files, discs, network streams and live capture. New streams use these values.")
        return qsTr("Applies the next time VLC opens.")
    }
    function writeSpecial(name, value) {
        switch (name) {
        case "theme": case "accent": case "rememberGeometry":
            AwakeningPreferences.setState(name, value)
            break
        case "repeat":
            AwakeningPreferences.setValue("repeat", value === "one")
            AwakeningPreferences.setValue("loop", value === "all")
            MainPlaylistController.repeatMode = value === "one" ? PlaylistController.PLAYBACK_REPEAT_CURRENT
                : value === "all" ? PlaylistController.PLAYBACK_REPEAT_ALL : PlaylistController.PLAYBACK_REPEAT_NONE
            break
        case "finishAction":
            AwakeningPreferences.setValue("play-and-exit", value === "quit")
            break
        case "nightMode":
            if (value) {
                AwakeningPreferences.setEffectValue("compressor-threshold", -25, true)
                AwakeningPreferences.setEffectValue("compressor-ratio", 6, true)
                AwakeningPreferences.setEffectValue("compressor-makeup-gain", 6, true)
            }
            AwakeningPreferences.setFilterEnabled("audio-filter", "compressor", value)
            break
        case "snapshotSize": {
            const parts = value.split("x")
            AwakeningPreferences.setValue("snapshot-width", Number(parts[0]))
            AwakeningPreferences.setValue("snapshot-height", Number(parts[1]))
            break
        }
        case "buffering":
            if (value !== "custom") {
                const network = value === "low" ? 300 : value === "high" ? 3000 : 1000
                const local = value === "low" ? 100 : value === "high" ? 1000 : 300
                for (const key of ["file-caching", "disc-caching", "live-caching"])
                    AwakeningPreferences.setValue(key, local)
                AwakeningPreferences.setValue("network-caching", network)
            }
            break
        }
    }
    function runAction(name) {
        switch (name) {
        case "advanced": DialogsProvider.prefsDialog(); break
        case "shortcuts": AwakeningUi.dialog = "shortcuts"; break
        case "resetShortcuts":
            if (DialogsProvider.questionDialog(qsTr("Restore all keyboard shortcuts to their defaults?"), qsTr("Reset shortcuts")))
                AwakeningPreferences.resetShortcuts()
            break
        case "clearHistory":
            if (MainCtx.mediaLibraryAvailable && DialogsProvider.questionDialog(qsTr("Clear playback history?"), qsTr("Clear history")))
                recent.clearHistory()
            break
        case "resetPicture":
            for (const option of ["hue", "brightness", "contrast", "saturation", "gamma"]) {
                AwakeningPreferences.resetValue(option)
                AwakeningPreferences.setEffectValue(option, AwakeningPreferences.value(option), false)
            }
            break
        }
    }
    function matches(row) {
        return !search.text || row.label.toLowerCase().includes(search.text.toLowerCase())
    }
    MLRecentMediaModel { id: recent; ml: MainCtx.mediaLibrary }

    contentItem: Item {
        Rectangle {
            id: header
            width: parent.width
            height: 50 * root.unit
            color: AwakeningTheme.field
            radius: 14 * root.unit
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 14 * root.unit
                color: parent.color
            }
            AwakeningField {
                id: search
                x: 8 * root.unit
                y: 8 * root.unit
                width: 200 * root.unit
                height: 34 * root.unit
                leftPadding: 42 * root.unit
                placeholderText: qsTr("Search")
                Accessible.name: qsTr("Search settings")
                background: Rectangle { radius: 6 * root.unit; color: AwakeningTheme.light ? AwakeningTheme.surface : "#151515" }
                Image {
                    x: 8 * root.unit
                    y: 5 * root.unit
                    width: 24 * root.unit
                    height: width
                    source: "qrc:/awakening/design/search.svg"
                }
            }
            AwakeningText {
                x: 240 * root.unit
                width: parent.width - x - 60 * root.unit
                height: parent.height
                text: root.category === "extensions" ? qsTr("Add-ons & Scripts") : root.page.title
                font.pixelSize: 16 * root.unit
                color: AwakeningTheme.light ? AwakeningTheme.text : "#969696"
                elide: Text.ElideRight
            }
            T.Button {
                anchors.right: parent.right
                anchors.rightMargin: 14 * root.unit
                anchors.verticalCenter: parent.verticalCenter
                width: 32 * root.unit
                height: width
                Accessible.name: qsTr("Close settings")
                onClicked: root.close()
                background: Rectangle { radius: 4 * root.unit; color: parent.hovered ? AwakeningTheme.surface : "transparent" }
                contentItem: Image {
                    source: "qrc:/awakening/design/close.svg"
                    fillMode: Image.PreserveAspectFit
                    sourceSize: Qt.size(24 * root.unit, 24 * root.unit)
                }
                padding: 4 * root.unit
            }
        }
        Rectangle {
            x: 8 * root.unit
            y: 58 * root.unit
            width: 200 * root.unit
            height: parent.height - 66 * root.unit
            color: AwakeningTheme.surface
            radius: 6 * root.unit
            Flickable {
                anchors.fill: parent
                anchors.margins: 6 * root.unit
                clip: true
                contentHeight: navigation.height
                boundsBehavior: Flickable.StopAtBounds
                Column {
                    id: navigation
                    width: parent.width
                    spacing: 8 * root.unit
                    Repeater {
                        model: root.categories
                        T.Button {
                            id: categoryButton
                            required property var modelData
                            width: navigation.width
                            height: (modelData.heading ? 33 : 40) * root.unit
                            enabled: !modelData.heading
                            hoverEnabled: true
                            checked: modelData.id === root.category
                            Accessible.name: modelData.text || modelData.heading
                            onClicked: AwakeningUi.settingsCategory = modelData.id
                            background: Rectangle {
                                radius: 2 * root.unit
                                color: categoryButton.checked || categoryButton.hovered ? AwakeningTheme.selected : "transparent"
                            }
                            contentItem: Row {
                                spacing: 8 * root.unit
                                leftPadding: categoryButton.modelData.heading ? 10 * root.unit : 4 * root.unit
                                Item {
                                    visible: !categoryButton.modelData.heading
                                    width: 32 * root.unit
                                    height: parent.height
                                    Image {
                                        anchors.centerIn: parent
                                        width: 24 * root.unit
                                        height: width
                                        source: categoryButton.modelData.id ? "qrc:/awakening/design/" + categoryButton.modelData.id
                                            + (categoryButton.checked && !["network", "performance", "extensions"].includes(categoryButton.modelData.id) ? "-active" : "") + ".svg" : ""
                                    }
                                }
                                AwakeningText {
                                    height: parent.height
                                    text: categoryButton.modelData.text || categoryButton.modelData.heading
                                    color: categoryButton.modelData.heading ? AwakeningTheme.muted
                                         : categoryButton.checked ? AwakeningTheme.bright : AwakeningTheme.text
                                }
                            }
                        }
                    }
                }
            }
        }
        Flickable {
            id: contentScroll
            x: 216 * root.unit
            y: 50 * root.unit
            width: parent.width - x
            height: parent.height - y
            contentWidth: width
            contentHeight: form.height + 120 * root.unit
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            C.ScrollBar.vertical: C.ScrollBar {}
            Column {
                id: form
                x: 24 * root.unit
                y: 20 * root.unit
                width: parent.width - 48 * root.unit
                spacing: 20 * root.unit
                Repeater {
                    model: root.category === "extensions" ? [] : root.page.sections
                    Column {
                        id: section
                        required property var modelData
                        width: form.width
                        visible: modelData.action ? !search.text : (modelData.rows || []).some(row => root.matches(row))
                        AwakeningText {
                            visible: !!section.modelData.title
                            width: parent.width
                            height: visible ? 39 * root.unit : 0
                            text: section.modelData.title || ""
                            color: AwakeningTheme.heading
                            font.pixelSize: 16 * root.unit
                            font.weight: Font.Medium
                        }
                        Repeater {
                            model: section.modelData.rows || []
                            AwakeningSettingRow {
                                required property var modelData
                                width: section.width
                                setting: modelData
                                settingsView: root
                                visible: root.matches(modelData)
                            }
                        }
                        AwakeningAction {
                            visible: !!section.modelData.action
                            width: parent.width
                            height: 38 * root.unit
                            text: qsTr("Advanced Options")
                            onClicked: root.runAction(section.modelData.action)
                        }
                    }
                }
                AwakeningAction {
                    visible: root.category === "extensions"
                    width: parent.width
                    text: qsTr("Manage extensions")
                    onClicked: DialogsProvider.pluginDialog()
                }
            }
        }
        AwakeningText {
            visible: !!AwakeningPreferences.error
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            padding: 12 * root.unit
            wrapMode: Text.Wrap
            text: AwakeningPreferences.error
            color: AwakeningTheme.accent
            background: Rectangle { color: AwakeningTheme.field }
        }
    }
}
