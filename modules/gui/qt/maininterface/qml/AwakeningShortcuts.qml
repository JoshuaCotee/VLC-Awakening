// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import QtQuick.Templates as T
import VLC.MainInterface

AwakeningDialog {
    id: root
    title: qsTr("Keyboard Shortcuts")
    dialogName: "shortcuts"
    designHeight: 800
    headerHeight: 96
    property var shortcuts: AwakeningPreferences.shortcuts()
    property var edits: ({})
    property string recording: ""
    property string error: ""
    readonly property var groups: [
        {label: qsTr("Basic"), keys: ["key-toggle-fullscreen", "key-leave-fullscreen", "key-position", "key-intf-show"]},
        {label: qsTr("Playback"), keys: ["key-play-pause", "key-stop", "key-next", "key-prev", "key-program-sid-next"]},
        {label: qsTr("More shortcuts"), keys: []}
    ]
    function groupRows(group) {
        const firstKeys = groups[0].keys.concat(groups[1].keys)
        let rows = group.keys.length ? group.keys.map(key => shortcuts.find(row => row.option === key)).filter(row => !!row)
            : shortcuts.filter(row => !firstKeys.includes(row.option))
        const query = search.text.toLowerCase()
        return rows.filter(row => {
            const field = filter.currentValue
            return !query || (field !== "local" && field !== "global" && row.label.toLowerCase().includes(query))
                || (field !== "action" && field !== "global" && String(row.local || "").toLowerCase().includes(query))
                || (field !== "action" && field !== "local" && String(row.global || "").toLowerCase().includes(query))
        })
    }
    function shortcut(option, fallback) { return edits[option] !== undefined ? edits[option] : fallback || "" }
    function edit(option, value) {
        const next = Object.assign({}, edits)
        next[option] = value
        edits = next
        recording = ""
    }
    function save() {
        for (const global of [false, true]) {
            const used = {}
            for (const row of shortcuts) {
                const option = (global ? "global-" : "") + row.option
                const value = shortcut(option, global ? row.global : row.local)
                for (const key of value.split("\t").filter(key => key)) {
                    if (used[key] && (edits[option] !== undefined || edits[used[key].option] !== undefined)) {
                        error = qsTr("%1 is assigned to both %2 and %3.").arg(key).arg(used[key].label).arg(row.label)
                        return
                    }
                    used[key] = {option: option, label: row.label}
                }
            }
        }
        for (const option in edits)
            if (!AwakeningPreferences.setValue(option, edits[option])) {
                error = AwakeningPreferences.error
                return
            }
        AwakeningPreferences.save()
        close()
    }
    headerExtra: RowLayout {
        x: 9 * root.unit
        y: 53 * root.unit
        width: parent.width - 18 * root.unit
        height: 34 * root.unit
        spacing: 10 * root.unit
        AwakeningField {
            id: search
            Layout.fillWidth: true
            Layout.fillHeight: true
            leftPadding: 42 * root.unit
            placeholderText: qsTr("Search Keyboard Shortcuts...")
            Image { x: 8 * root.unit; y: 5 * root.unit; width: 24 * root.unit; height: width; source: "qrc:/awakening/design/search.svg" }
        }
        AwakeningSelect {
            id: filter
            Layout.preferredWidth: 200 * root.unit
            Layout.fillHeight: true
            model: [
                {text: qsTr("All Fields"), value: "all"}, {text: qsTr("Actions"), value: "action"},
                {text: qsTr("Hotkeys"), value: "local"}, {text: qsTr("Global Hotkeys"), value: "global"}
            ]
        }
    }
    Flickable {
        anchors.fill: parent
        contentHeight: rows.height + 40 * root.unit
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        C.ScrollBar.vertical: C.ScrollBar {}
        Column {
            id: rows
            x: 20 * root.unit
            y: 20 * root.unit
            width: parent.width - 40 * root.unit
            Item {
                width: parent.width
                height: 65 * root.unit
                AwakeningText { text: qsTr("Action"); height: 25 * root.unit; color: AwakeningTheme.heading }
                AwakeningText { x: parent.width * 0.484; text: qsTr("Hotkey"); height: 25 * root.unit; color: AwakeningTheme.heading }
                AwakeningText { x: parent.width * 0.813; text: qsTr("Global Hotkey"); height: 25 * root.unit; color: AwakeningTheme.heading }
                Rectangle { y: 45 * root.unit; width: parent.width; height: root.unit; color: AwakeningTheme.selected }
            }
            Repeater {
                model: root.groups
                Column {
                    id: group
                    required property var modelData
                    readonly property var entries: root.groupRows(modelData)
                    width: rows.width
                    visible: entries.length > 0
                    AwakeningText {
                        text: group.modelData.label
                        height: 48 * root.unit
                        font.pixelSize: 16 * root.unit
                        color: AwakeningTheme.heading
                        verticalAlignment: Text.AlignTop
                    }
                    Repeater {
                        model: group.entries
                        Item {
                            id: actionRow
                            required property var modelData
                            width: group.width
                            height: 47 * root.unit
                            AwakeningText {
                                width: parent.width * 0.32
                                height: 33 * root.unit
                                text: actionRow.modelData.label
                                elide: Text.ElideRight
                            }
                            Repeater {
                                model: ["local", "global"]
                                T.Button {
                                    id: keyButton
                                    required property string modelData
                                    required property int index
                                    readonly property string option: (index ? "global-" : "") + actionRow.modelData.option
                                    x: actionRow.width * (index ? 0.732 : 0.376)
                                    width: actionRow.width * 0.268
                                    height: 33 * root.unit
                                    hoverEnabled: true
                                    focusPolicy: Qt.StrongFocus
                                    Accessible.name: actionRow.modelData.label + " " + modelData
                                    onClicked: { root.recording = option; forceActiveFocus() }
                                    Keys.onPressed: event => {
                                        if (root.recording !== option) return
                                        event.accepted = true
                                        if ([Qt.Key_Control, Qt.Key_Shift, Qt.Key_Alt, Qt.Key_Meta].includes(event.key)) return
                                        if (event.key === Qt.Key_Escape) { root.recording = ""; return }
                                        root.edit(option, event.key === Qt.Key_Delete || event.key === Qt.Key_Backspace ? ""
                                            : AwakeningPreferences.shortcutText(event.key, event.modifiers))
                                    }
                                    background: Rectangle {
                                        color: AwakeningTheme.field
                                        radius: 4 * root.unit
                                        border.width: root.recording === keyButton.option || keyButton.visualFocus ? 1 : 0
                                        border.color: AwakeningTheme.accent
                                    }
                                    contentItem: AwakeningText {
                                        text: root.recording === keyButton.option ? qsTr("Press a key...")
                                            : root.shortcut(keyButton.option, actionRow.modelData[keyButton.modelData]).replace(/\t/g, ", ")
                                        horizontalAlignment: Text.AlignHCenter
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }
                    Item {
                        width: parent.width
                        height: 40 * root.unit
                        Rectangle { y: 20 * root.unit; width: parent.width; height: root.unit; color: AwakeningTheme.selected }
                    }
                }
            }
        }
    }
    footer: [
        AwakeningAction { x: 20 * root.unit; y: 20 * root.unit; text: qsTr("Cancel"); onClicked: root.close() },
        AwakeningText {
            x: 136 * root.unit
            width: parent.width - 272 * root.unit
            height: parent.height
            text: root.error || (Object.keys(root.edits).length ? qsTr("Restart VLC to apply changed shortcuts.") : "")
            wrapMode: Text.Wrap
            color: root.error ? AwakeningTheme.accent : AwakeningTheme.muted
        },
        AwakeningAction {
            anchors.right: parent.right; anchors.rightMargin: 20 * root.unit
            y: 20 * root.unit; text: qsTr("Save"); accent: true; onClicked: root.save()
        }
    ]
}
