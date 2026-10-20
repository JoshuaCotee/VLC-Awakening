// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import VLC.MainInterface
import VLC.MediaLibrary
import VLC.Player

T.Popup {
    id: root
    readonly property real unit: Math.min(AwakeningTheme.scale, (parent.width - 32) / 1090, (parent.height - 32) / 759)
    property int step: 0
    width: 1090 * unit
    height: 759 * unit
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    padding: 0
    modal: true
    focus: true
    closePolicy: T.Popup.NoAutoClose
    visible: AwakeningUi.dialog === "onboarding"
    onOpened: MainCtx.preferHotkeys = false
    onClosed: MainCtx.preferHotkeys = MainCtx.playerView
    background: Rectangle { color: AwakeningTheme.panel; radius: 14 * root.unit }
    MLFoldersModel { id: folders; ctx: MainCtx }
    function finish() {
        if (folder.text.trim() && MainCtx.mediaLibraryAvailable)
            folders.add(AwakeningPreferences.localUrl(folder.text.trim()))
        AwakeningPreferences.setValue("metadata-network-access", false)
        AwakeningPreferences.setValue("qt-privacy-ask", false)
        AwakeningPreferences.setState("onboardingComplete", true)
        AwakeningPreferences.save()
        if (MainCtx.mediaLibraryAvailable) MainCtx.mediaLibrary.reload()
        AwakeningUi.dialog = ""
    }
    contentItem: Item {
        Item {
            anchors.fill: parent
            visible: root.step === 0
            Image {
                x: 475 * root.unit
                y: 116 * root.unit
                width: 141 * root.unit
                height: width
                source: "qrc:/awakening/design/welcome-logo.svg"
                fillMode: Image.PreserveAspectFit
            }
            AwakeningText {
                x: 200 * root.unit
                y: 286 * root.unit
                width: 690 * root.unit
                height: 39 * root.unit
                text: qsTr("Welcome to VLC!")
                horizontalAlignment: Text.AlignHCenter
                color: AwakeningTheme.heading
                font.pixelSize: 32 * root.unit
                font.weight: Font.Light
            }
            AwakeningText {
                x: 248 * root.unit
                y: 362 * root.unit
                width: 595 * root.unit
                height: 84 * root.unit
                text: qsTr("VLC is a free and open source cross-platform multimedia player and framework that plays most multimedia files as well as DVDs, Audio CDs, VCDs, and various streaming protocols.")
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignTop
                font.pixelSize: 16 * root.unit
                lineHeightMode: Text.FixedHeight
                lineHeight: 28 * root.unit
            }
            AwakeningText {
                x: 248 * root.unit
                y: 500 * root.unit
                height: 17 * root.unit
                text: qsTr("Choose a Media Folder to get started with")
                font.pixelSize: 14 * root.unit
            }
            AwakeningField {
                id: folder
                x: 248 * root.unit
                y: 533 * root.unit
                width: 471 * root.unit
                height: 36 * root.unit
                text: AwakeningPreferences.mediaFolder()
                font.pixelSize: 16 * root.unit
            }
            AwakeningAction {
                x: 729 * root.unit
                y: 533.5 * root.unit
                width: 114 * root.unit
                height: 35 * root.unit
                text: qsTr("Browse")
                font.pixelSize: 16 * root.unit
                onClicked: {
                    const selected = AwakeningPreferences.choosePath(folder.text, true)
                    if (selected) folder.text = selected
                }
            }
        }
        Item {
            anchors.fill: parent
            visible: root.step === 1
            Rectangle {
                x: 17 * root.unit
                y: 19 * root.unit
                width: 1056 * root.unit
                height: 594 * root.unit
                color: AwakeningTheme.window
                Image {
                    x: 7.15 * root.unit
                    y: 4.4 * root.unit
                    width: 13.2 * root.unit
                    height: width
                    source: "qrc:/awakening/logo.svg"
                }
                Row {
                    anchors.right: parent.right
                    anchors.rightMargin: 13.2 * root.unit
                    y: 4.4 * root.unit
                    Repeater {
                        model: ["minimize", "maximize", "fullscreen", "close"]
                        Item {
                            required property string modelData
                            width: 19.8 * root.unit
                            height: 13.2 * root.unit
                            Image {
                                anchors.centerIn: parent
                                width: 13.2 * root.unit
                                height: width
                                source: "qrc:/awakening/" + (AwakeningTheme.light ? "light/" : "") + parent.modelData + ".svg"
                            }
                        }
                    }
                }
                Rectangle {
                    x: 5.5 * root.unit
                    y: 22 * root.unit
                    width: parent.width - 11 * root.unit
                    height: 542.3 * root.unit
                    radius: 5.5 * root.unit
                    color: AwakeningTheme.panel
                }
                Item {
                    y: 564.3 * root.unit
                    width: 1920 * AwakeningTheme.scale
                    height: 54 * AwakeningTheme.scale
                    transform: Scale { xScale: 0.55 * root.unit / AwakeningTheme.scale; yScale: xScale }
                    AwakeningControlBar { anchors.fill: parent; enabled: false }
                }
            }
            AwakeningText {
                x: 220 * root.unit
                y: 173 * root.unit
                width: 650 * root.unit
                height: 42 * root.unit
                text: qsTr("Select your preferred theme and color.")
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 24 * root.unit
                color: AwakeningTheme.heading
            }
            Row {
                x: 331 * root.unit
                y: 286 * root.unit
                spacing: 40 * root.unit
                Repeater {
                    model: [{id: "light", label: qsTr("Light")}, {id: "dark", label: qsTr("Dark")}, {id: "system", label: qsTr("System")}]
                    T.Button {
                        id: themeChoice
                        required property var modelData
                        width: 116 * root.unit
                        height: 157 * root.unit
                        checked: AwakeningTheme.mode === modelData.id
                        Accessible.name: modelData.label
                        onClicked: AwakeningPreferences.setState("theme", modelData.id)
                        background: Item {}
                        contentItem: Item {
                            Rectangle {
                                width: parent.width
                                height: 116 * root.unit
                                radius: 8 * root.unit
                                color: themeChoice.checked ? AwakeningTheme.accentBackground : AwakeningTheme.surface
                                border.width: themeChoice.visualFocus ? 1 : 0
                                border.color: AwakeningTheme.accent
                                Rectangle {
                                    anchors.fill: parent
                                    anchors.margins: 8 * root.unit
                                    radius: 4 * root.unit
                                    color: themeChoice.modelData.id === "light" ? "#c6c6c6" : "#222222"
                                    Rectangle {
                                        visible: themeChoice.modelData.id === "system"
                                        width: parent.width / 2
                                        height: parent.height
                                        color: "#c6c6c6"
                                        radius: parent.radius
                                    }
                                }
                            }
                            AwakeningText {
                                y: 138 * root.unit
                                width: parent.width
                                height: 19 * root.unit
                                text: themeChoice.modelData.label
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 16 * root.unit
                            }
                        }
                    }
                }
            }
            Row {
                x: 41 * root.unit
                y: 655 * root.unit
                spacing: 16 * root.unit
                Repeater {
                    model: ["#d37918", "#e15032", "#c49e23", "#19a234", "#18aad3", "#185dd3", "#8e42ff", "#f052b3", "#afafaf"]
                    T.Button {
                        id: accentChoice
                        required property string modelData
                        width: 64 * root.unit
                        height: width
                        checked: Qt.colorEqual(AwakeningTheme.accent, modelData)
                        Accessible.name: qsTr("Accent color %1").arg(modelData)
                        onClicked: AwakeningPreferences.setState("accent", modelData)
                        background: Rectangle {
                            radius: 8 * root.unit
                            color: accentChoice.checked ? AwakeningTheme.accentBackground : "transparent"
                            border.width: accentChoice.visualFocus ? 1 : 0
                            border.color: AwakeningTheme.accent
                        }
                        contentItem: Item {
                            Rectangle { anchors.centerIn: parent; width: 40 * root.unit; height: width; radius: width / 2; color: accentChoice.modelData }
                        }
                    }
                }
            }
        }
        AwakeningAction {
            visible: root.step > 0
            x: 820 * root.unit; y: 671 * root.unit
            width: 100 * root.unit; height: 32 * root.unit
            text: qsTr("Back")
            font.pixelSize: 16 * root.unit
            onClicked: --root.step
        }
        AwakeningAction {
            x: 928 * root.unit; y: 671 * root.unit
            width: 100 * root.unit; height: 32 * root.unit
            text: qsTr("Next")
            font.pixelSize: 16 * root.unit
            accent: true
            onClicked: root.step === 0 ? ++root.step : root.finish()
        }
    }
}
