// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import VLC.MainInterface
import VLC.Player
import VLC.Playlist
import VLC.Dialogs
import VLC.Style
import VLC.Util

T.Pane {
    id: root
    readonly property real uiScale: VLCStyle.scale
    readonly property real sliderY: narrow ? topPadding : (height - 28 * uiScale) / 2
    readonly property bool compact: width < 850 * uiScale
    readonly property bool narrow: width < 900 * uiScale
    readonly property ColorContext colorContext: ColorContext {
        palette: VLCStyle.darkPalette
        colorSet: ColorContext.Window
    }
    signal requestLockUnlockAutoHide(bool lock)
    signal togglePlaylistVisibility()
    signal forceUnlock()
    onForceUnlock: tracks.close()

    implicitHeight: (narrow ? 94 : 54) * uiScale
    implicitWidth: 580 * uiScale
    leftPadding: (narrow ? 10 : 20) * uiScale
    rightPadding: leftPadding
    topPadding: 11 * uiScale
    bottomPadding: topPadding
    hoverEnabled: true
    enabled: visible
    Accessible.name: qsTr("Player controls")
    AccessibleCompat.id: "playerControlBar"

    FontLoader { id: inter; source: "qrc:/awakening/Inter.ttf" }
    background: Rectangle { color: AwakeningTheme.window }

    contentItem: GridLayout {
        columns: root.narrow ? 4 : 5
        rowSpacing: 8 * root.uiScale
        columnSpacing: (root.compact ? 10 : 20) * root.uiScale

        RowLayout {
            Layout.row: root.narrow ? 1 : 0
            Layout.column: 0
            spacing: 8 * root.uiScale
            AwakeningButton {
                artwork: "previous"
                description: qsTr("Previous (P)")
                enabled: !MainPlaylistController.empty
                onClicked: MainPlaylistController.prevOrReset()
            }
            AwakeningButton {
                id: playButton
                Layout.preferredWidth: 54 * root.uiScale
                Layout.preferredHeight: 28 * root.uiScale
                artwork: Player.playingState === Player.PLAYING_STATE_PLAYING ? "pause" : "play"
                description: Player.playingState === Player.PLAYING_STATE_PLAYING ? qsTr("Pause (Space)") : qsTr("Play (Space)")
                accent: true
                focus: true
                AccessibleCompat.id: "awakeningPlayButton"
                onClicked: {
                    if (MainPlaylistController.empty)
                        DialogsProvider.simpleOpenDialog(true)
                    else
                        MainPlaylistController.togglePlayPause()
                }
            }
            AwakeningButton {
                artwork: "next"
                description: qsTr("Next (N)")
                enabled: MainPlaylistController.hasNext
                onClicked: MainPlaylistController.next()
            }
        }

        RowLayout {
            Layout.row: 0
            Layout.column: root.narrow ? 0 : 1
            Layout.columnSpan: root.narrow ? 4 : 1
            Layout.fillWidth: true
            spacing: 8 * root.uiScale
            T.Label {
                Layout.preferredWidth: 76 * root.uiScale
                text: Player.time.valid() ? Player.time.formatHMS() : "00:00"
                color: AwakeningTheme.text
                font.family: inter.name
                font.pixelSize: 15 * root.uiScale
                horizontalAlignment: Text.AlignHCenter
            }
            T.Slider {
                id: seek
                Layout.fillWidth: true
                Layout.minimumWidth: 65 * root.uiScale
                Layout.preferredHeight: 28 * root.uiScale
                from: 0
                to: 1
                padding: 0
                enabled: Player.seekable
                focusPolicy: Qt.StrongFocus
                Accessible.name: qsTr("Playback position")
                AccessibleCompat.id: "awakeningSeekSlider"
                onMoved: Player.position = value
                Keys.onLeftPressed: Player.jumpBwd()
                Keys.onRightPressed: Player.jumpFwd()
                Binding {
                    target: seek
                    property: "value"
                    value: Player.position
                    when: !seek.pressed
                }
                background: Rectangle {
                    color: AwakeningTheme.field
                    radius: 6 * root.uiScale
                    border.width: seek.visualFocus ? 1 : 0
                    border.color: AwakeningTheme.accent
                    Rectangle {
                        x: 2 * root.uiScale
                        y: 2 * root.uiScale
                        height: parent.height - 4 * root.uiScale
                        width: Math.max(0, (parent.width - 4 * root.uiScale) * seek.visualPosition)
                        color: AwakeningTheme.accentBackground
                        radius: 4 * root.uiScale
                    }
                }
                handle: Rectangle {
                    x: seek.visualPosition * (seek.availableWidth - width)
                    y: 2 * root.uiScale
                    width: 8 * root.uiScale
                    height: 24 * root.uiScale
                    radius: 4 * root.uiScale
                    color: AwakeningTheme.accent
                    visible: seek.enabled
                }
                HoverHandler { id: seekHover }
                T.ToolTip.visible: seekHover.hovered && seek.enabled
                T.ToolTip.text: Player.length.scale(Math.max(0, Math.min(1, seekHover.point.position.x / seek.width))).formatHMS(0)
                T.ToolTip.delay: 200
            }
            T.Label {
                Layout.preferredWidth: 76 * root.uiScale
                text: Player.length.valid() ? Player.length.formatHMS() : "00:00"
                color: AwakeningTheme.text
                font.family: inter.name
                font.pixelSize: 15 * root.uiScale
                horizontalAlignment: Text.AlignHCenter
            }
        }

        RowLayout {
            Layout.row: root.narrow ? 1 : 0
            Layout.column: root.narrow ? 1 : 2
            spacing: 8 * root.uiScale
            AwakeningButton {
                artwork: "volume"
                Layout.preferredWidth: 24 * root.uiScale
                description: Player.muted ? qsTr("Unmute (M)") : qsTr("Mute (M)")
                checked: Player.muted
                onClicked: Player.muted = !Player.muted
            }
            T.Slider {
                id: volume
                Layout.preferredWidth: 88 * root.uiScale
                Layout.preferredHeight: 28 * root.uiScale
                from: 0
                to: 2
                stepSize: 0.01
                padding: 0
                focusPolicy: Qt.StrongFocus
                Accessible.name: qsTr("Volume")
                AccessibleCompat.id: "awakeningVolumeSlider"
                onMoved: {
                    Player.muted = false
                    Player.volume = value
                }
                Binding { target: volume; property: "value"; value: Player.volume; when: !volume.pressed }
                background: Item {
                    Image {
                        anchors.centerIn: parent
                        width: 89 * root.uiScale
                        height: 28 * root.uiScale
                        source: "qrc:/awakening/volume-base.svg"
                        fillMode: Image.PreserveAspectFit
                    }
                    Item {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width * (Player.muted ? 0 : volume.visualPosition)
                        height: parent.height
                        clip: true
                        Image {
                            x: 1.5 * root.uiScale
                            anchors.verticalCenter: parent.verticalCenter
                            width: 86 * root.uiScale
                            height: 25 * root.uiScale
                            source: "qrc:/awakening/volume-fill.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: AwakeningTheme.accent
                        border.width: volume.visualFocus ? 1 : 0
                        radius: 4 * root.uiScale
                    }
                }
                handle: Item {}
                HoverHandler { id: volumeHover }
                T.ToolTip.visible: volumeHover.hovered || volume.pressed || volume.visualFocus
                T.ToolTip.text: qsTr("Volume %1%").arg(Math.round(Player.volume * 100))
                T.ToolTip.delay: 200
            }
        }

        RowLayout {
            Layout.row: root.narrow ? 1 : 0
            Layout.column: root.narrow ? 2 : 3
            spacing: 12 * root.uiScale
            AwakeningButton {
                artwork: "audio"
                description: qsTr("Audio tracks")
                onClicked: tracks.open()
            }
            AwakeningButton {
                artwork: "subtitles"
                description: qsTr("Subtitles")
                onClicked: tracks.open()
            }
            AwakeningButton {
                artwork: "settings"
                description: qsTr("Playback settings")
                onClicked: DialogsProvider.extendedDialog()
            }
        }
        AwakeningButton {
            Layout.row: root.narrow ? 1 : 0
            Layout.column: root.narrow ? 3 : 4
            artwork: "queue"
            description: qsTr("Play queue")
            onClicked: root.togglePlaylistVisibility()
        }
    }

    TracksMenu {
        id: tracks
        parent: root
        width: Math.min(760 * root.uiScale, root.width - 20 * root.uiScale)
        colorContext.palette: VLCStyle.darkPalette
        x: Math.max(0, root.width - width - 20 * root.uiScale)
        y: -height - 8 * root.uiScale
        onOpened: root.requestLockUnlockAutoHide(true)
        onClosed: root.requestLockUnlockAutoHide(false)
    }
}
