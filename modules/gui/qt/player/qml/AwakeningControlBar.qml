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
import VLC.Widgets as Widgets

T.Pane {
    id: root
    readonly property real uiScale: VLCStyle.scale
    readonly property real sliderY: (height - 28 * uiScale) / 2
    readonly property bool compact: width < 850 * uiScale
    readonly property bool narrow: width < 660 * uiScale
    readonly property ColorContext colorContext: ColorContext {
        palette: VLCStyle.darkPalette
        colorSet: ColorContext.Window
    }
    signal requestLockUnlockAutoHide(bool lock)
    signal togglePlaylistVisibility()
    signal forceUnlock()
    onForceUnlock: tracks.close()

    implicitHeight: 54 * uiScale
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
    background: Rectangle { color: "#1b1b1b" }

    contentItem: RowLayout {
        spacing: (root.compact ? 10 : 20) * root.uiScale

        RowLayout {
            spacing: 8 * root.uiScale
            AwakeningButton {
                artwork: "previous"
                description: qsTr("Previous (P)")
                visible: !root.narrow
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
                visible: !root.narrow
                enabled: MainPlaylistController.hasNext
                onClicked: MainPlaylistController.next()
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8 * root.uiScale
            T.Label {
                Layout.preferredWidth: 76 * root.uiScale
                visible: !root.narrow
                text: Player.time.valid() ? Player.time.formatHMS() : "00:00"
                color: "#8f8f8f"
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
                    color: "#090909"
                    radius: 6 * root.uiScale
                    border.width: seek.visualFocus ? 1 : 0
                    border.color: "#d37918"
                    Rectangle {
                        x: 2 * root.uiScale
                        y: 2 * root.uiScale
                        height: parent.height - 4 * root.uiScale
                        width: Math.max(0, (parent.width - 4 * root.uiScale) * seek.visualPosition)
                        color: "#371f06"
                        radius: 4 * root.uiScale
                    }
                }
                handle: Rectangle {
                    x: seek.visualPosition * (seek.availableWidth - width)
                    y: 2 * root.uiScale
                    width: 8 * root.uiScale
                    height: 24 * root.uiScale
                    radius: 4 * root.uiScale
                    color: "#d37918"
                    visible: seek.enabled
                }
                HoverHandler { id: seekHover }
                Widgets.ToolTipExt {
                    visible: seekHover.hovered && seek.enabled
                    text: Player.length.scale(Math.max(0, Math.min(1, seekHover.point.position.x / seek.width))).formatHMS()
                    delay: 200
                }
            }
            T.Label {
                Layout.preferredWidth: 76 * root.uiScale
                visible: !root.compact
                text: Player.length.valid() ? Player.length.formatHMS() : "00:00"
                color: "#8f8f8f"
                font.family: inter.name
                font.pixelSize: 15 * root.uiScale
                horizontalAlignment: Text.AlignHCenter
            }
        }

        RowLayout {
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
                visible: !root.narrow
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
                        border.color: "#d37918"
                        border.width: volume.visualFocus ? 1 : 0
                        radius: 4 * root.uiScale
                    }
                }
                handle: Item {}
                HoverHandler { id: volumeHover }
                Widgets.ToolTipExt {
                    visible: volumeHover.hovered || volume.pressed || volume.visualFocus
                    text: qsTr("Volume %1%").arg(Math.round(Player.volume * 100))
                    delay: 200
                }
            }
        }

        RowLayout {
            spacing: 12 * root.uiScale
            AwakeningButton {
                artwork: "audio"
                description: qsTr("Audio tracks")
                visible: !root.narrow
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
                visible: !root.narrow
                onClicked: DialogsProvider.extendedDialog()
            }
        }
        AwakeningButton {
            artwork: "queue"
            description: qsTr("Play queue")
            onClicked: root.togglePlaylistVisibility()
        }
    }

    TracksMenu {
        id: tracks
        parent: root
        x: Math.max(0, root.width - width - 20 * root.uiScale)
        y: -height - 8 * root.uiScale
        onOpened: root.requestLockUnlockAutoHide(true)
        onClosed: root.requestLockUnlockAutoHide(false)
    }
}
