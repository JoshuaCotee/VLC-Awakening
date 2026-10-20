// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import VLC.MainInterface
import VLC.Player
import VLC.Playlist

Item {
    id: root
    required property var setting
    required property var settingsView
    readonly property real unit: AwakeningTheme.scale
    readonly property string optionName: {
        AwakeningPreferences.revision
        return setting.option === "freetype-rel-fontsize" && AwakeningPreferences.value("freetype-fontsize") > 0
            ? "freetype-fontsize" : setting.option || ""
    }
    readonly property var metadata: optionName ? AwakeningPreferences.describe(optionName) : ({})
    readonly property var currentValue: {
        AwakeningPreferences.revision
        if (setting.special)
            return settingsView.readSpecial(setting.special)
        if (setting.filter)
            return AwakeningPreferences.filterEnabled(setting.chain, setting.filter)
        return optionName ? AwakeningPreferences.value(optionName) : undefined
    }
    readonly property bool available: !!setting.action || (currentValue !== undefined && currentValue !== null)
    readonly property var choices: setting.choices || (setting.special ? settingsView.specialChoices(setting.special) : metadata.choices) || []
    readonly property string kind: {
        if (setting.action) return "action"
        if (setting.special === "theme") return "segments"
        if (setting.special === "accent") return "colors"
        if (setting.special === "startupVolume") return "startupVolume"
        if (setting.kind && setting.kind !== "auto") return setting.kind
        if (choices.length) return "select"
        return metadata.type || "text"
    }
    implicitHeight: setting.height * unit

    function commit(value) {
        if (setting.special) {
            settingsView.writeSpecial(setting.special, value)
            return
        }
        if (setting.filter) {
            AwakeningPreferences.setFilterEnabled(setting.chain, setting.filter, value)
            return
        }
        if (setting.effect) {
            AwakeningPreferences.setFilterEnabled("video-filter", setting.effect, true)
            AwakeningPreferences.setEffectValue(optionName, value, false)
        } else if (AwakeningPreferences.setValue(optionName, value)) {
            if (setting.live === "onTop") MainCtx.interfaceAlwaysOnTop = value
            if (setting.live === "pinControls") MainCtx.pinVideoControls = value
            if (setting.live === "shuffle") MainPlaylistController.random = value
        }
    }

    Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10 * root.unit
        width: Math.max(0, Math.min(implicitWidth, root.width - editor.width - 20 * root.unit))
        AwakeningText {
            text: root.setting.label
            width: Math.max(0, Math.min(implicitWidth, parent.width - (info.visible ? 28 * root.unit : 0)))
            elide: Text.ElideRight
            height: 18 * root.unit
        }
        Image {
            id: info
            visible: !!root.setting.info
            width: 18 * root.unit
            height: width
            source: "qrc:/awakening/design/info.svg"
            HoverHandler { id: infoHover }
            T.ToolTip.visible: infoHover.hovered
            T.ToolTip.text: root.available
                ? (root.metadata.description || root.settingsView.specialDescription(root.setting.special))
                : qsTr("This option is unavailable in this build.")
        }
    }

    Loader {
        id: editor
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: Math.min((root.kind === "toggle" ? 68
              : root.kind === "action" && root.setting.buttonText.length < 12 ? 100 : 320) * root.unit,
              Math.max(160 * root.unit, root.width * 0.55))
        height: (root.kind === "startupVolume" ? 88 : root.kind === "slider" && root.setting.ticks ? 57
               : root.kind === "toggle" || root.kind === "action" ? 32 : 36) * root.unit
        enabled: root.available
        sourceComponent: {
            switch (root.kind) {
            case "toggle": return toggle
            case "select": return select
            case "slider": return slider
            case "file": case "folder": return path
            case "action": return action
            case "segments": return segments
            case "colors": return colors
            case "startupVolume": return startupVolume
            default: return field
            }
        }
    }
    Component {
        id: toggle
        AwakeningSwitch {
            Accessible.name: root.setting.label
            checked: root.setting.onValue !== undefined ? root.currentValue !== root.setting.offValue
                   : root.setting.invert ? !root.currentValue : !!root.currentValue
            onClicked: root.commit(root.setting.onValue !== undefined
                ? (checked ? root.setting.onValue : root.setting.offValue)
                : root.setting.invert ? !checked : checked)
        }
    }
    Component {
        id: select
        AwakeningSelect {
            Accessible.name: root.setting.label
            model: root.choices
            currentIndex: {
                for (let i = 0; i < root.choices.length; ++i)
                    if (root.choices[i].value == root.currentValue) return i
                return -1
            }
            displayText: currentIndex >= 0 ? currentText : String(root.currentValue ?? "")
            onActivated: root.commit(currentValue)
        }
    }
    Component {
        id: field
        AwakeningField {
            Accessible.name: root.setting.label
            echoMode: root.setting.password ? TextInput.Password : TextInput.Normal
            text: root.kind === "color" ? "#" + Number(root.currentValue || 0).toString(16).padStart(6, "0").toUpperCase()
                : String(root.currentValue ?? "")
            inputMethodHints: root.kind === "integer" || root.kind === "number" ? Qt.ImhFormattedNumbersOnly : Qt.ImhNone
            onEditingFinished: {
                if (root.kind === "color") {
                    if (/^#[0-9a-fA-F]{6}$/.test(text)) root.commit(parseInt(text.substring(1), 16))
                } else root.commit(text)
            }
            Rectangle {
                visible: root.kind === "color"
                anchors.right: parent.right
                anchors.rightMargin: 6 * root.unit
                anchors.verticalCenter: parent.verticalCenter
                width: 22 * root.unit
                height: width
                radius: 3 * root.unit
                color: visible && /^#[0-9a-fA-F]{6}$/.test(parent.text) ? parent.text : "transparent"
                border.width: 1
                border.color: AwakeningTheme.subtle
            }
        }
    }
    Component {
        id: slider
        Column {
            AwakeningSlider {
                width: parent.width
                Accessible.name: root.setting.label
                from: root.setting.minimum ?? root.metadata.minimum ?? 0
                to: root.setting.maximum ?? root.metadata.maximum ?? 10
                stepSize: root.setting.step ?? 1
                value: Number(root.currentValue || 0)
                onMoved: root.commit(value)
            }
            Item {
                visible: !!root.setting.ticks
                width: parent.width
                height: 25 * root.unit
                Repeater {
                    model: root.setting.ticks || []
                    AwakeningText {
                        required property int index
                        required property string modelData
                        text: modelData
                        font.pixelSize: 12 * root.unit
                        color: AwakeningTheme.muted
                        x: index === 0 ? 0 : index === root.setting.ticks.length - 1 ? parent.width - width
                           : parent.width * index / (root.setting.ticks.length - 1) - width / 2
                        y: 8 * root.unit
                    }
                }
            }
        }
    }
    Component {
        id: path
        RowLayout {
            spacing: 10 * root.unit
            AwakeningField {
                id: pathInput
                Layout.fillWidth: true
                Accessible.name: root.setting.label
                text: String(root.currentValue ?? "")
                onEditingFinished: root.commit(text)
            }
            AwakeningAction {
                text: qsTr("Browse")
                Layout.preferredWidth: 100 * root.unit
                onClicked: {
                    const selected = AwakeningPreferences.choosePath(pathInput.text,
                        root.kind === "folder", root.setting.option === "logfile")
                    if (selected) root.commit(selected)
                }
            }
        }
    }
    Component {
        id: action
        AwakeningAction {
            text: root.setting.buttonText
            onClicked: root.settingsView.runAction(root.setting.action)
        }
    }
    Component {
        id: segments
        Rectangle {
            radius: 6 * root.unit
            color: AwakeningTheme.field
            Row {
                anchors.fill: parent
                anchors.margins: 2 * root.unit
                spacing: 2 * root.unit
                Repeater {
                    model: root.choices
                    AwakeningAction {
                        required property var modelData
                        width: (parent.width - 4 * root.unit) / 3
                        height: parent.height
                        text: modelData.text
                        accent: modelData.value === root.currentValue
                        onClicked: root.commit(modelData.value)
                        contentItem: AwakeningText {
                            text: parent.text
                            horizontalAlignment: Text.AlignHCenter
                            color: parent.accent ? AwakeningTheme.accent : AwakeningTheme.muted
                        }
                    }
                }
            }
        }
    }
    Component {
        id: startupVolume
        Column {
            spacing: 10 * root.unit
            RowLayout {
                width: parent.width
                AwakeningText { text: qsTr("Remember last volume"); Layout.fillWidth: true }
                AwakeningSwitch {
                    checked: root.currentValue < 0
                    onClicked: root.commit(checked ? -1 : 100)
                }
            }
            RowLayout {
                width: parent.width
                AwakeningSlider {
                    Layout.fillWidth: true
                    from: 0; to: 125; stepSize: 1
                    enabled: root.currentValue >= 0
                    value: Math.max(0, root.currentValue)
                    onMoved: root.commit(value)
                }
                AwakeningText {
                    Layout.preferredWidth: 45 * root.unit
                    horizontalAlignment: Text.AlignRight
                    text: root.currentValue < 0 ? "" : Math.round(root.currentValue) + "%"
                }
            }
        }
    }
    Component {
        id: colors
        Rectangle {
            radius: 6 * root.unit
            color: AwakeningTheme.field
            Row {
                anchors.fill: parent
                anchors.margins: 2 * root.unit
                spacing: 4 * root.unit
                Repeater {
                    model: ["#d37918", "#e15032", "#c49e23", "#19a234", "#18aad3", "#185dd3", "#8e42ff", "#f052b3", "#afafaf"]
                    T.Button {
                        id: colorButton
                        required property string modelData
                        width: (parent.width - 32 * root.unit) / 9
                        height: parent.height
                        padding: 6 * root.unit
                        Accessible.name: qsTr("Accent color %1").arg(modelData)
                        checked: Qt.colorEqual(modelData, root.currentValue || AwakeningTheme.accent)
                        onClicked: root.commit(modelData)
                        background: Rectangle {
                            radius: 4 * root.unit
                            color: colorButton.checked ? AwakeningTheme.accentBackground : "transparent"
                            border.width: colorButton.visualFocus ? 1 : 0
                            border.color: AwakeningTheme.accent
                        }
                        contentItem: Rectangle {
                            radius: root.unit
                            color: colorButton.modelData
                            opacity: colorButton.checked ? 1 : 0.7
                        }
                    }
                }
            }
        }
    }
}
