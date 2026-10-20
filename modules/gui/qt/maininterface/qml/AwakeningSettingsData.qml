// SPDX-License-Identifier: GPL-2.0-or-later
pragma Singleton
import QtQuick

QtObject {
    readonly property var pages: ({
    "general": {
        "title": "Global Settings",
        "sections": [
            {
                "title": "Appearance",
                "rows": [
                    {
                        "id": "3046:9860",
                        "label": "Interface language",
                        "height": 46,
                        "info": false,
                        "special": "language",
                        "kind": "select"
                    },
                    {
                        "id": "3046:9868",
                        "label": "Theme",
                        "height": 46,
                        "info": false,
                        "special": "theme",
                        "kind": "auto"
                    },
                    {
                        "id": "3046:9871",
                        "label": "Accent color",
                        "height": 46,
                        "info": false,
                        "special": "accent",
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "Startup",
                "rows": [
                    {
                        "id": "3046:9895",
                        "label": "Show confirmation and error dialogs",
                        "height": 42,
                        "info": false,
                        "option": "qt-error-dialogs",
                        "kind": "toggle"
                    },
                    {
                        "id": "3046:9901",
                        "label": "Check for updates automatically",
                        "height": 42,
                        "info": false,
                        "option": "qt-updates-notif",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "Diagnostics",
                "rows": [
                    {
                        "id": "3062:10941",
                        "label": "Developer mode",
                        "height": 42,
                        "info": false,
                        "option": "qt-verbose",
                        "kind": "toggle"
                    },
                    {
                        "id": "3062:10947",
                        "label": "Save a log",
                        "height": 42,
                        "info": false,
                        "option": "file-logging",
                        "kind": "toggle"
                    },
                    {
                        "id": "3062:10953",
                        "label": "Log file",
                        "height": 46,
                        "info": false,
                        "option": "logfile",
                        "kind": "file"
                    },
                    {
                        "id": "3062:10962",
                        "label": "Log details",
                        "height": 46,
                        "info": false,
                        "option": "log-verbose",
                        "kind": "select"
                    }
                ]
            },
            {
                "title": "",
                "action": "advanced",
                "height": 38
            }
        ]
    },
    "interface": {
        "title": "Interface Settings",
        "sections": [
            {
                "title": "Skin",
                "rows": [
                    {
                        "id": "3062:11308",
                        "label": "Use a custom skin",
                        "height": 42,
                        "info": false,
                        "special": "skin",
                        "kind": "toggle"
                    },
                    {
                        "id": "3062:11321",
                        "label": "Skin file",
                        "height": 46,
                        "info": false,
                        "option": "skins2-last",
                        "kind": "file"
                    }
                ]
            },
            {
                "title": "Window",
                "rows": [
                    {
                        "id": "3051:10601",
                        "label": "Play video inside main window",
                        "height": 42,
                        "info": false,
                        "option": "embedded-video",
                        "kind": "toggle"
                    },
                    {
                        "id": "3051:10607",
                        "label": "Resize window to fit video",
                        "height": 46,
                        "info": false,
                        "option": "qt-video-autoresize",
                        "kind": "select",
                        "choices": [
                            {
                                "text": "Never",
                                "value": false
                            },
                            {
                                "text": "Always",
                                "value": true
                            }
                        ]
                    },
                    {
                        "id": "3054:10686",
                        "label": "Remember window size and position",
                        "height": 42,
                        "info": false,
                        "special": "rememberGeometry",
                        "kind": "toggle"
                    },
                    {
                        "id": "3051:10617",
                        "label": "Keep window above other windows",
                        "height": 42,
                        "info": false,
                        "option": "video-on-top",
                        "live": "onTop",
                        "kind": "toggle"
                    },
                    {
                        "id": "3051:10623",
                        "label": "Show window decorations",
                        "height": 42,
                        "info": false,
                        "option": "qt-titlebar",
                        "invert": true,
                        "kind": "toggle"
                    },
                    {
                        "id": "3051:10629",
                        "label": "Show the file name in the title bar",
                        "height": 42,
                        "info": false,
                        "option": "qt-name-in-title",
                        "kind": "toggle"
                    },
                    {
                        "id": "3051:10635",
                        "label": "Open fullscreen on",
                        "height": 46,
                        "info": false,
                        "option": "qt-fullscreen-screennumber",
                        "kind": "select"
                    }
                ]
            },
            {
                "title": "Playback Controls",
                "rows": [
                    {
                        "id": "3055:10783",
                        "label": "Start in compact mode",
                        "height": 42,
                        "info": false,
                        "option": "qt-minimal-view",
                        "kind": "toggle"
                    },
                    {
                        "id": "3055:10789",
                        "label": "Auto-hide the controls",
                        "height": 46,
                        "info": false,
                        "option": "qt-pin-controls",
                        "kind": "select",
                        "live": "pinControls",
                        "choices": [
                            {
                                "text": "In fullscreen only",
                                "value": true
                            },
                            {
                                "text": "Always",
                                "value": false
                            }
                        ]
                    },
                    {
                        "id": "3056:10871",
                        "label": "Hide after",
                        "height": 57,
                        "info": false,
                        "option": "mouse-hide-timeout",
                        "kind": "slider",
                        "minimum": 0,
                        "maximum": 10000,
                        "ticks": [
                            "0 s",
                            "5 s",
                            "10s"
                        ]
                    },
                    {
                        "id": "3056:10922",
                        "label": "Show controls in fullscreen",
                        "height": 42,
                        "info": false,
                        "option": "qt-fs-controller",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "Notifications and System Tray",
                "rows": [
                    {
                        "id": "3062:11131",
                        "label": "Show a system tray icon",
                        "height": 42,
                        "info": false,
                        "option": "qt-system-tray",
                        "kind": "toggle"
                    },
                    {
                        "id": "3062:11210",
                        "label": "Start minimized to the tray",
                        "height": 42,
                        "info": false,
                        "option": "qt-start-minimized",
                        "kind": "toggle"
                    },
                    {
                        "id": "3062:11137",
                        "label": "Show a popup when the track changes",
                        "height": 46,
                        "info": false,
                        "option": "qt-notification",
                        "kind": "select"
                    },
                    {
                        "id": "3062:11147",
                        "label": "Popup duration",
                        "height": 57,
                        "info": false,
                        "special": "notificationDuration",
                        "kind": "slider",
                        "ticks": [
                            "0 s",
                            "5 s",
                            "10s"
                        ]
                    }
                ]
            },
            {
                "title": "Playlist",
                "rows": [
                    {
                        "id": "3062:11229",
                        "label": "Show the playlist as a tree",
                        "height": 42,
                        "info": false,
                        "special": "playlistTree",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "",
                "action": "advanced",
                "height": 38
            }
        ]
    },
    "privacy": {
        "title": "Privacy Settings",
        "sections": [
            {
                "title": "History",
                "rows": [
                    {
                        "id": "3062:11946",
                        "label": "Save recently played items",
                        "height": 42,
                        "info": false,
                        "option": "save-recentplay",
                        "kind": "toggle"
                    },
                    {
                        "id": "3062:11952",
                        "label": "Remember the playback position",
                        "height": 42,
                        "info": false,
                        "option": "restore-playback-pos",
                        "kind": "toggle",
                        "onValue": 2,
                        "offValue": 0
                    },
                    {
                        "id": "3062:12466",
                        "label": "Never remember items matching",
                        "height": 46,
                        "info": false,
                        "special": "historyExclude",
                        "kind": "auto"
                    },
                    {
                        "id": "3062:12481",
                        "label": "Clear history now",
                        "height": 42,
                        "info": false,
                        "action": "clearHistory",
                        "buttonText": "Clear",
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "Network",
                "rows": [
                    {
                        "id": "3062:11964",
                        "label": "Fetch titles and cover art from the internet",
                        "height": 42,
                        "info": false,
                        "option": "metadata-network-access",
                        "kind": "toggle"
                    },
                    {
                        "id": "3062:12496",
                        "label": "Submit played tracks to last.fm",
                        "height": 42,
                        "info": false,
                        "special": "lastfm",
                        "kind": "toggle"
                    },
                    {
                        "id": "3062:12521",
                        "label": "Last.fm username",
                        "height": 46,
                        "info": false,
                        "option": "lastfm-username",
                        "kind": "auto"
                    },
                    {
                        "id": "3062:12542",
                        "label": "Last.fm password",
                        "height": 46,
                        "info": false,
                        "option": "lastfm-password",
                        "password": true,
                        "kind": "auto"
                    },
                    {
                        "id": "3062:12532",
                        "label": "Last.fm submission URL",
                        "height": 46,
                        "info": false,
                        "option": "scrobbler-url",
                        "kind": "auto"
                    }
                ]
            }
        ]
    },
    "controls": {
        "title": "Mouse, Keyboard & Remote Controls",
        "sections": [
            {
                "title": "Keyboard Shortcuts",
                "rows": [
                    {
                        "id": "6540:15087",
                        "label": "Defaults",
                        "height": 42,
                        "info": false,
                        "action": "shortcuts",
                        "buttonText": "Edit Keyboard Shortcuts",
                        "kind": "auto"
                    },
                    {
                        "id": "6536:14523",
                        "label": "Reset all shortcuts",
                        "height": 42,
                        "info": false,
                        "action": "resetShortcuts",
                        "buttonText": "Reset",
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "Skip Amounts",
                "rows": [
                    {
                        "id": "6540:15097",
                        "label": "Very short skip",
                        "height": 48,
                        "info": false,
                        "option": "extrashort-jump-size",
                        "kind": "auto"
                    },
                    {
                        "id": "6540:15109",
                        "label": "Short skip",
                        "height": 48,
                        "info": false,
                        "option": "short-jump-size",
                        "kind": "auto"
                    },
                    {
                        "id": "6540:15121",
                        "label": "Medium skip",
                        "height": 48,
                        "info": false,
                        "option": "medium-jump-size",
                        "kind": "auto"
                    },
                    {
                        "id": "6540:15127",
                        "label": "Long skip",
                        "height": 48,
                        "info": false,
                        "option": "long-jump-size",
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "Mouse",
                "rows": [
                    {
                        "id": "6540:15133",
                        "label": "Single click on the video",
                        "height": 46,
                        "info": false,
                        "option": "mouse-click-action",
                        "kind": "select"
                    },
                    {
                        "id": "6540:15145",
                        "label": "Double click on the video",
                        "height": 46,
                        "info": false,
                        "option": "mouse-doubleclick-action",
                        "kind": "select"
                    },
                    {
                        "id": "6540:15156",
                        "label": "Scroll wheel",
                        "height": 46,
                        "info": false,
                        "option": "hotkeys-y-wheel-mode",
                        "kind": "select"
                    },
                    {
                        "id": "6540:15167",
                        "label": "Horizontal scroll",
                        "height": 46,
                        "info": false,
                        "option": "hotkeys-x-wheel-mode",
                        "kind": "select"
                    },
                    {
                        "id": "6536:14587",
                        "label": "Reverse scroll direction",
                        "height": 42,
                        "info": false,
                        "special": "reverseScroll",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "Remotes",
                "rows": [
                    {
                        "id": "6540:15235",
                        "label": "Web remote control",
                        "height": 42,
                        "info": false,
                        "special": "httpRemote",
                        "kind": "toggle"
                    },
                    {
                        "id": "6540:15244",
                        "label": "Port",
                        "height": 48,
                        "info": false,
                        "option": "http-port",
                        "kind": "auto"
                    },
                    {
                        "id": "6540:15201",
                        "label": "Scroll wheel",
                        "height": 46,
                        "info": false,
                        "option": "hotkeys-y-wheel-mode",
                        "kind": "select"
                    },
                    {
                        "id": "6540:15210",
                        "label": "Horizontal scroll",
                        "height": 46,
                        "info": false,
                        "option": "hotkeys-x-wheel-mode",
                        "kind": "select"
                    },
                    {
                        "id": "6540:15219",
                        "label": "Reverse scroll direction",
                        "height": 42,
                        "info": false,
                        "special": "reverseScroll",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "",
                "action": "advanced",
                "height": 38
            }
        ]
    },
    "playback": {
        "title": "Playback Preferences",
        "sections": [
            {
                "title": "Startup",
                "rows": [
                    {
                        "id": "3062:12853",
                        "label": "Continue where you left off",
                        "height": 46,
                        "info": false,
                        "option": "restore-playback-pos",
                        "kind": "select"
                    },
                    {
                        "id": "3062:12847",
                        "label": "Start playing as soon as a file opens",
                        "height": 42,
                        "info": false,
                        "option": "start-paused",
                        "invert": true,
                        "kind": "toggle"
                    },
                    {
                        "id": "3062:12863",
                        "label": "Default playback speed",
                        "height": 67,
                        "info": false,
                        "option": "rate",
                        "kind": "slider",
                        "minimum": 0.25,
                        "maximum": 2,
                        "step": 0.05,
                        "ticks": [
                            "0.25",
                            "0.5",
                            "0.75",
                            "1",
                            "1.25",
                            "1.5",
                            "1.75",
                            "2"
                        ]
                    },
                    {
                        "id": "3062:12874",
                        "label": "Pause when another app uses audio",
                        "height": 42,
                        "info": false,
                        "option": "mmdevice-ducking",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "Tracks",
                "rows": [
                    {
                        "id": "3070:13098",
                        "label": "Preferred video quality",
                        "height": 46,
                        "info": false,
                        "option": "preferred-resolution",
                        "kind": "select"
                    },
                    {
                        "id": "3072:13805",
                        "label": "Preferred menu language",
                        "height": 46,
                        "info": false,
                        "option": "menu-language",
                        "kind": "select"
                    },
                    {
                        "id": "3072:13821",
                        "label": "Default audio track",
                        "height": 46,
                        "info": false,
                        "option": "audio-track",
                        "kind": "auto"
                    },
                    {
                        "id": "3072:13833",
                        "label": "Default subtitle track",
                        "height": 46,
                        "info": false,
                        "option": "sub-track",
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "Order",
                "rows": [
                    {
                        "id": "3072:13747",
                        "label": "Repeat",
                        "height": 46,
                        "info": false,
                        "special": "repeat",
                        "kind": "select"
                    },
                    {
                        "id": "3072:13757",
                        "label": "Shuffle",
                        "height": 42,
                        "info": false,
                        "option": "random",
                        "live": "shuffle",
                        "kind": "toggle"
                    },
                    {
                        "id": "3072:13763",
                        "label": "Stop after each item",
                        "height": 42,
                        "info": false,
                        "option": "play-and-stop",
                        "kind": "toggle"
                    },
                    {
                        "id": "3072:13769",
                        "label": "When playback finishes",
                        "height": 46,
                        "info": false,
                        "special": "finishAction",
                        "kind": "select"
                    }
                ]
            },
            {
                "title": "Seeking",
                "rows": [
                    {
                        "id": "3071:13227",
                        "label": "Seek precisely",
                        "height": 42,
                        "info": false,
                        "option": "input-fast-seek",
                        "invert": true,
                        "kind": "toggle"
                    },
                    {
                        "id": "3072:13275",
                        "label": "Show thumbnail while scrubbing",
                        "height": 42,
                        "info": false,
                        "special": "scrubbingPreview",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "Files & Discs",
                "rows": [
                    {
                        "id": "3072:13333",
                        "label": "Default optical drive",
                        "height": 46,
                        "info": false,
                        "option": "dvd",
                        "kind": "select"
                    },
                    {
                        "id": "3072:13350",
                        "label": "Repair damaged AVI files",
                        "height": 46,
                        "info": false,
                        "option": "avi-index",
                        "kind": "select"
                    },
                    {
                        "id": "3072:13381",
                        "label": "Load matching .mkv files from the same folder",
                        "height": 42,
                        "info": false,
                        "option": "mkv-preload-local-dir",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "",
                "action": "advanced",
                "height": 38
            }
        ]
    },
    "video": {
        "title": "Video Defaults",
        "sections": [
            {
                "title": "Output",
                "rows": [
                    {
                        "id": "3073:14232",
                        "label": "Enable video",
                        "height": 42,
                        "info": false,
                        "option": "video",
                        "kind": "toggle"
                    },
                    {
                        "id": "3073:14628",
                        "label": "Start videos in fullscreen",
                        "height": 42,
                        "info": false,
                        "option": "fullscreen",
                        "kind": "toggle"
                    },
                    {
                        "id": "3073:14644",
                        "label": "Stop the screensaver during playback",
                        "height": 42,
                        "info": false,
                        "option": "disable-screensaver",
                        "kind": "toggle"
                    },
                    {
                        "id": "3073:14660",
                        "label": "Play video as desktop wallpaper",
                        "height": 42,
                        "info": false,
                        "option": "video-wallpaper",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "Picture",
                "rows": [
                    {
                        "id": "3073:14673",
                        "label": "Hue",
                        "height": 42,
                        "info": false,
                        "option": "hue",
                        "kind": "slider",
                        "effect": "adjust",
                        "minimum": -180,
                        "maximum": 180
                    },
                    {
                        "id": "3073:14914",
                        "label": "Brightness",
                        "height": 42,
                        "info": false,
                        "option": "brightness",
                        "kind": "slider",
                        "effect": "adjust",
                        "minimum": 0,
                        "maximum": 2,
                        "step": 0.01
                    },
                    {
                        "id": "3073:14925",
                        "label": "Contrast",
                        "height": 42,
                        "info": false,
                        "option": "contrast",
                        "kind": "slider",
                        "effect": "adjust",
                        "minimum": 0,
                        "maximum": 2,
                        "step": 0.01
                    },
                    {
                        "id": "3073:14936",
                        "label": "Saturation",
                        "height": 42,
                        "info": false,
                        "option": "saturation",
                        "kind": "slider",
                        "effect": "adjust",
                        "minimum": 0,
                        "maximum": 3,
                        "step": 0.01
                    },
                    {
                        "id": "3073:14957",
                        "label": "Gamma",
                        "height": 42,
                        "info": false,
                        "option": "gamma",
                        "kind": "slider",
                        "effect": "adjust",
                        "minimum": 0.01,
                        "maximum": 10,
                        "step": 0.01
                    },
                    {
                        "id": "3073:14901",
                        "label": "Reset picture",
                        "height": 42,
                        "info": false,
                        "action": "resetPicture",
                        "buttonText": "Reset",
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "Deinterlacing",
                "rows": [
                    {
                        "id": "3073:15064",
                        "label": "Deinterlacing",
                        "height": 46,
                        "info": false,
                        "option": "deinterlace",
                        "kind": "select"
                    },
                    {
                        "id": "3073:15081",
                        "label": "Method",
                        "height": 46,
                        "info": false,
                        "option": "deinterlace-mode",
                        "kind": "select"
                    }
                ]
            },
            {
                "title": "Framing",
                "rows": [
                    {
                        "id": "3073:15100",
                        "label": "Aspect ratio",
                        "height": 46,
                        "info": false,
                        "option": "aspect-ratio",
                        "kind": "select"
                    },
                    {
                        "id": "3073:15132",
                        "label": "Crop",
                        "height": 46,
                        "info": false,
                        "option": "crop",
                        "kind": "select"
                    },
                    {
                        "id": "3073:15148",
                        "label": "Scale video to the window",
                        "height": 42,
                        "info": false,
                        "option": "autoscale",
                        "kind": "toggle"
                    },
                    {
                        "id": "3073:15162",
                        "label": "Zoom",
                        "height": 46,
                        "info": false,
                        "option": "zoom",
                        "kind": "select"
                    },
                    {
                        "id": "3073:15191",
                        "label": "Position in the window",
                        "height": 46,
                        "info": false,
                        "option": "align",
                        "kind": "select"
                    }
                ]
            },
            {
                "title": "Snapshots",
                "rows": [
                    {
                        "id": "3073:15287",
                        "label": "Save to",
                        "height": 42,
                        "info": false,
                        "option": "snapshot-path",
                        "kind": "folder"
                    },
                    {
                        "id": "3073:15301",
                        "label": "File name prefix",
                        "height": 42,
                        "info": false,
                        "option": "snapshot-prefix",
                        "kind": "auto"
                    },
                    {
                        "id": "3073:15236",
                        "label": "Format",
                        "height": 46,
                        "info": false,
                        "option": "snapshot-format",
                        "kind": "select"
                    },
                    {
                        "id": "3073:15359",
                        "label": "Size",
                        "height": 46,
                        "info": false,
                        "special": "snapshotSize",
                        "kind": "select"
                    },
                    {
                        "id": "3073:15230",
                        "label": "Number files sequentially",
                        "height": 42,
                        "info": false,
                        "option": "snapshot-sequential",
                        "kind": "toggle"
                    },
                    {
                        "id": "3073:15313",
                        "label": "Show a preview after capture",
                        "height": 42,
                        "info": false,
                        "option": "snapshot-preview",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "",
                "action": "advanced",
                "height": 38
            }
        ]
    },
    "audio": {
        "title": "Audio Defaults",
        "sections": [
            {
                "title": "Output",
                "rows": [
                    {
                        "id": "3073:15914",
                        "label": "Enable audio",
                        "height": 42,
                        "info": false,
                        "option": "audio",
                        "kind": "toggle"
                    },
                    {
                        "id": "3073:16402",
                        "label": "Output device",
                        "height": 46,
                        "info": false,
                        "special": "audioDevice",
                        "kind": "select"
                    },
                    {
                        "id": "3176:16449",
                        "label": "Speaker setup",
                        "height": 46,
                        "info": false,
                        "option": "stereo-mode",
                        "kind": "select"
                    }
                ]
            },
            {
                "title": "Volume",
                "rows": [
                    {
                        "id": "3176:16465",
                        "label": "Maximum volume",
                        "height": 67,
                        "info": false,
                        "option": "qt-max-volume",
                        "kind": "slider",
                        "minimum": 100,
                        "maximum": 300,
                        "ticks": [
                            "100%",
                            "200%",
                            "300%"
                        ]
                    },
                    {
                        "id": "3176:16496",
                        "label": "Startup volume",
                        "height": 98,
                        "info": false,
                        "special": "startupVolume",
                        "kind": "auto"
                    },
                    {
                        "id": "3176:16518",
                        "label": "Volume step",
                        "height": 48,
                        "info": false,
                        "option": "volume-step",
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "Loudness",
                "rows": [
                    {
                        "id": "3176:16582",
                        "label": "Normalize loudness",
                        "height": 42,
                        "info": false,
                        "filter": "normvol",
                        "chain": "audio-filter",
                        "kind": "toggle"
                    },
                    {
                        "id": "3178:16599",
                        "label": "Target level",
                        "height": 48,
                        "info": false,
                        "option": "norm-max-level",
                        "kind": "auto"
                    },
                    {
                        "id": "3178:16611",
                        "label": "Night mode",
                        "height": 42,
                        "info": false,
                        "special": "nightMode",
                        "kind": "toggle"
                    },
                    {
                        "id": "3178:16624",
                        "label": "Replay gain",
                        "height": 46,
                        "info": false,
                        "option": "audio-replay-gain-mode",
                        "kind": "select"
                    },
                    {
                        "id": "3178:16647",
                        "label": "Replay gain preamp",
                        "height": 48,
                        "info": false,
                        "option": "audio-replay-gain-preamp",
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "Effects",
                "rows": [
                    {
                        "id": "3178:16662",
                        "label": "Equalizer",
                        "height": 42,
                        "info": false,
                        "filter": "equalizer",
                        "chain": "audio-filter",
                        "kind": "toggle"
                    },
                    {
                        "id": "3178:16668",
                        "label": "Equalizer preset",
                        "height": 48,
                        "info": false,
                        "option": "equalizer-preset",
                        "kind": "auto"
                    },
                    {
                        "id": "3178:17014",
                        "label": "Two-pass",
                        "height": 42,
                        "info": false,
                        "option": "equalizer-2pass",
                        "kind": "toggle"
                    },
                    {
                        "id": "3178:17044",
                        "label": "Spatial audio",
                        "height": 42,
                        "info": false,
                        "filter": "spatializer",
                        "chain": "audio-filter",
                        "kind": "toggle"
                    },
                    {
                        "id": "3178:17060",
                        "label": "Spatial audio mode",
                        "height": 46,
                        "info": false,
                        "special": "spatialMode",
                        "kind": "select"
                    },
                    {
                        "id": "3178:17077",
                        "label": "Stereo widening",
                        "height": 42,
                        "info": false,
                        "filter": "stereowiden",
                        "chain": "audio-filter",
                        "kind": "toggle"
                    },
                    {
                        "id": "3178:17090",
                        "label": "Compressor",
                        "height": 42,
                        "info": false,
                        "filter": "compressor",
                        "chain": "audio-filter",
                        "kind": "toggle"
                    },
                    {
                        "id": "3178:17115",
                        "label": "Pitch shift",
                        "height": 42,
                        "info": false,
                        "option": "pitch-shift",
                        "kind": "auto"
                    },
                    {
                        "id": "3180:17162",
                        "label": "Chorus/flanger",
                        "height": 42,
                        "info": false,
                        "filter": "chorus_flanger",
                        "chain": "audio-filter",
                        "kind": "toggle"
                    },
                    {
                        "id": "3180:17176",
                        "label": "Karaoke",
                        "height": 42,
                        "info": false,
                        "filter": "karaoke",
                        "chain": "audio-filter",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "Tracks",
                "rows": [
                    {
                        "id": "3180:17192",
                        "label": "Preferred audio language",
                        "height": 46,
                        "info": false,
                        "option": "audio-language",
                        "kind": "select"
                    },
                    {
                        "id": "3180:17247",
                        "label": "Audio delay",
                        "height": 46,
                        "info": false,
                        "option": "audio-desync",
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "Visualization",
                "rows": [
                    {
                        "id": "3180:17269",
                        "label": "Visualizer",
                        "height": 46,
                        "info": false,
                        "option": "audio-visual",
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "",
                "action": "advanced",
                "height": 38
            }
        ]
    },
    "subtitles": {
        "title": "Subtitle Defaults",
        "sections": [
            {
                "title": "Tracks & Languages",
                "rows": [
                    {
                        "id": "3180:18024",
                        "label": "Enable subtitles",
                        "height": 42,
                        "info": false,
                        "option": "spu",
                        "kind": "toggle"
                    },
                    {
                        "id": "3180:18030",
                        "label": "Preferred language",
                        "height": 46,
                        "info": false,
                        "option": "sub-language",
                        "kind": "select"
                    },
                    {
                        "id": "3180:18040",
                        "label": "Text encoding",
                        "height": 46,
                        "info": false,
                        "option": "subsdec-encoding",
                        "kind": "select"
                    }
                ]
            },
            {
                "title": "Loading Subtitles",
                "rows": [
                    {
                        "id": "3182:18599",
                        "label": "Load subtitle files automatically",
                        "height": 42,
                        "info": false,
                        "option": "sub-autodetect-file",
                        "kind": "toggle"
                    },
                    {
                        "id": "3182:18613",
                        "label": "File name matching",
                        "height": 46,
                        "info": false,
                        "option": "sub-autodetect-fuzzy",
                        "kind": "select"
                    }
                ]
            },
            {
                "title": "Appearance",
                "rows": [
                    {
                        "id": "3180:18098",
                        "label": "Font",
                        "height": 48,
                        "info": false,
                        "option": "freetype-font",
                        "kind": "auto"
                    },
                    {
                        "id": "3191:18686",
                        "label": "Size values",
                        "height": 48,
                        "info": false,
                        "special": "subtitleSizeMode",
                        "kind": "auto"
                    },
                    {
                        "id": "3191:18703",
                        "label": "Font size",
                        "height": 46,
                        "info": false,
                        "option": "freetype-rel-fontsize",
                        "kind": "select"
                    },
                    {
                        "id": "3191:18720",
                        "label": "Bold",
                        "height": 42,
                        "info": false,
                        "option": "freetype-bold",
                        "kind": "toggle"
                    },
                    {
                        "id": "3180:18092",
                        "label": "Text color",
                        "height": 42,
                        "info": false,
                        "option": "freetype-color",
                        "kind": "color"
                    },
                    {
                        "id": "3191:18741",
                        "label": "Text opacity",
                        "height": 67,
                        "info": false,
                        "option": "freetype-opacity",
                        "kind": "slider",
                        "minimum": 0,
                        "maximum": 255,
                        "ticks": [
                            "0%",
                            "50%",
                            "100%"
                        ]
                    },
                    {
                        "id": "3191:18778",
                        "label": "Outline thickness",
                        "height": 46,
                        "info": false,
                        "option": "freetype-outline-thickness",
                        "kind": "select"
                    },
                    {
                        "id": "3191:18817",
                        "label": "Outline color",
                        "height": 42,
                        "info": false,
                        "option": "freetype-outline-color",
                        "kind": "color"
                    },
                    {
                        "id": "3191:18824",
                        "label": "Shadow",
                        "height": 42,
                        "info": false,
                        "option": "freetype-shadow-opacity",
                        "kind": "toggle",
                        "onValue": 128,
                        "offValue": 0
                    },
                    {
                        "id": "3191:18835",
                        "label": "Shadow color",
                        "height": 42,
                        "info": false,
                        "option": "freetype-shadow-color",
                        "kind": "color"
                    },
                    {
                        "id": "3191:18842",
                        "label": "Shadow distance",
                        "height": 46,
                        "info": false,
                        "option": "freetype-shadow-distance",
                        "kind": "select"
                    },
                    {
                        "id": "3180:18111",
                        "label": "Background",
                        "height": 46,
                        "info": false,
                        "option": "freetype-background-opacity",
                        "kind": "select",
                        "choices": [
                            {
                                "text": "None",
                                "value": 0
                            },
                            {
                                "text": "Solid",
                                "value": 255
                            }
                        ]
                    },
                    {
                        "id": "3191:18853",
                        "label": "Background color",
                        "height": 42,
                        "info": false,
                        "option": "freetype-background-color",
                        "kind": "color"
                    },
                    {
                        "id": "3191:18860",
                        "label": "Background opacity",
                        "height": 67,
                        "info": false,
                        "option": "freetype-background-opacity",
                        "kind": "slider",
                        "minimum": 0,
                        "maximum": 255,
                        "ticks": [
                            "0%",
                            "50%",
                            "100%"
                        ]
                    },
                    {
                        "id": "3191:18885",
                        "label": "Vertical position",
                        "height": 46,
                        "info": false,
                        "option": "sub-margin",
                        "kind": "integer"
                    }
                ]
            },
            {
                "title": "Timing",
                "rows": [
                    {
                        "id": "3191:19011",
                        "label": "Subtitle delay",
                        "height": 67,
                        "info": false,
                        "option": "sub-delay",
                        "kind": "slider",
                        "minimum": -50,
                        "maximum": 50,
                        "ticks": [
                            "-5 s",
                            "0 s",
                            "+5 s"
                        ]
                    }
                ]
            },
            {
                "title": "On-Screen Messages",
                "rows": [
                    {
                        "id": "3191:19101",
                        "label": "Show feedback for shortcuts",
                        "height": 42,
                        "info": false,
                        "option": "osd",
                        "kind": "toggle"
                    },
                    {
                        "id": "3192:19183",
                        "label": "Show feedback for",
                        "height": 67,
                        "info": false,
                        "special": "osdDuration",
                        "kind": "slider",
                        "ticks": [
                            "0.5 s",
                            "5 s"
                        ]
                    },
                    {
                        "id": "3191:19144",
                        "label": "Show filename when a video starts",
                        "height": 42,
                        "info": false,
                        "option": "video-title-show",
                        "kind": "toggle"
                    },
                    {
                        "id": "3191:19157",
                        "label": "Show filename for",
                        "height": 67,
                        "info": false,
                        "option": "video-title-timeout",
                        "kind": "slider",
                        "minimum": 1000,
                        "maximum": 10000,
                        "ticks": [
                            "1 s",
                            "10 s"
                        ]
                    }
                ]
            },
            {
                "title": "",
                "action": "advanced",
                "height": 38
            }
        ]
    },
    "library": {
        "title": "Playlists, Folders & Files",
        "sections": [
            {
                "title": "Opening Files",
                "rows": [
                    {
                        "id": "6542:15547",
                        "label": "Only allow one VLC window",
                        "height": 42,
                        "info": false,
                        "option": "one-instance",
                        "kind": "toggle"
                    },
                    {
                        "id": "6542:15562",
                        "label": "Apply to files opened from the file manager",
                        "height": 42,
                        "info": false,
                        "option": "one-instance-when-started-from-file",
                        "kind": "toggle"
                    },
                    {
                        "id": "6542:15575",
                        "label": "Add to the playlist instead of replacing it",
                        "height": 42,
                        "info": false,
                        "option": "playlist-enqueue",
                        "kind": "toggle"
                    },
                    {
                        "id": "6542:15588",
                        "label": "When opening a folder",
                        "height": 46,
                        "info": false,
                        "option": "recursive",
                        "kind": "select"
                    },
                    {
                        "id": "6542:15600",
                        "label": "Show hidden files",
                        "height": 42,
                        "info": false,
                        "option": "show-hiddenfiles",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "Metadata & Artwork",
                "rows": [
                    {
                        "id": "6542:15613",
                        "label": "Fetch titles and artwork",
                        "height": 46,
                        "info": false,
                        "option": "metadata-network-access",
                        "kind": "select",
                        "choices": [
                            {
                                "text": "From the file only",
                                "value": false
                            },
                            {
                                "text": "From the internet",
                                "value": true
                            }
                        ]
                    },
                    {
                        "id": "6542:15624",
                        "label": "Use the media library",
                        "height": 42,
                        "info": false,
                        "option": "media-library",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "",
                "action": "advanced",
                "height": 38
            }
        ]
    },
    "network": {
        "title": "Network Connections & Security",
        "sections": [
            {
                "title": "Buffering",
                "rows": [
                    {
                        "id": "6571:15876",
                        "label": "Buffering",
                        "height": 46,
                        "info": false,
                        "special": "buffering",
                        "kind": "select"
                    },
                    {
                        "id": "6571:15888",
                        "label": "Local files",
                        "height": 48,
                        "info": false,
                        "option": "file-caching",
                        "kind": "auto"
                    },
                    {
                        "id": "6571:15895",
                        "label": "Discs",
                        "height": 48,
                        "info": false,
                        "option": "disc-caching",
                        "kind": "auto"
                    },
                    {
                        "id": "6571:15900",
                        "label": "Network streams",
                        "height": 48,
                        "info": false,
                        "option": "network-caching",
                        "kind": "auto"
                    },
                    {
                        "id": "6571:15905",
                        "label": "Live capture",
                        "height": 48,
                        "info": false,
                        "option": "live-caching",
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "Proxy",
                "rows": [
                    {
                        "id": "6571:15910",
                        "label": "HTTP proxy",
                        "height": 48,
                        "info": false,
                        "option": "http-proxy",
                        "kind": "auto"
                    },
                    {
                        "id": "6571:15916",
                        "label": "HTTP proxy password",
                        "height": 48,
                        "info": false,
                        "option": "http-proxy-pwd",
                        "password": true,
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "Security",
                "rows": [
                    {
                        "id": "6571:15938",
                        "label": "Verify certificates against the system trust store",
                        "height": 42,
                        "info": false,
                        "option": "gnutls-system-trust",
                        "kind": "toggle"
                    },
                    {
                        "id": "6571:15946",
                        "label": "Cipher preference",
                        "height": 46,
                        "info": false,
                        "option": "gnutls-priorities",
                        "kind": "select"
                    }
                ]
            },
            {
                "title": "",
                "action": "advanced",
                "height": 38
            }
        ]
    },
    "performance": {
        "title": "Performance Settings",
        "sections": [
            {
                "title": "Decoding",
                "rows": [
                    {
                        "id": "6571:15993",
                        "label": "Hardware-accelerated decoding",
                        "height": 46,
                        "info": false,
                        "option": "avcodec-hw",
                        "kind": "select"
                    },
                    {
                        "id": "6571:16231",
                        "label": "Video post-processing",
                        "height": 46,
                        "info": false,
                        "option": "postproc-q",
                        "kind": "select"
                    },
                    {
                        "id": "6571:16262",
                        "label": "Skip the H.264 loop filter",
                        "height": 46,
                        "info": false,
                        "option": "avcodec-skiploopfilter",
                        "kind": "select"
                    },
                    {
                        "id": "6571:16278",
                        "label": "Decoding threads",
                        "height": 48,
                        "info": false,
                        "option": "avcodec-threads",
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "Smooth Playback",
                "rows": [
                    {
                        "id": "6571:16254",
                        "label": "Drop frames when the system can't keep up",
                        "height": 42,
                        "info": false,
                        "option": "drop-late-frames",
                        "kind": "toggle"
                    },
                    {
                        "id": "6571:16290",
                        "label": "Give VLC real-time priority",
                        "height": 42,
                        "info": false,
                        "option": "high-priority",
                        "kind": "toggle"
                    },
                    {
                        "id": "6571:16301",
                        "label": "Process priority",
                        "height": 48,
                        "info": false,
                        "option": "rt-priority",
                        "kind": "auto"
                    },
                    {
                        "id": "6571:16312",
                        "label": "Rescan plugins",
                        "height": 42,
                        "info": false,
                        "action": "rescanPlugins",
                        "buttonText": "Rescan",
                        "kind": "auto"
                    }
                ]
            },
            {
                "title": "",
                "action": "advanced",
                "height": 38
            },
            {
                "title": "Developer",
                "rows": [
                    {
                        "id": "6571:16357",
                        "label": "Encoder",
                        "height": 46,
                        "info": false,
                        "option": "sout-transcode-venc",
                        "kind": "select"
                    },
                    {
                        "id": "6571:16374",
                        "label": "Decoder",
                        "height": 46,
                        "info": false,
                        "option": "codec",
                        "kind": "select"
                    },
                    {
                        "id": "6571:16390",
                        "label": "Clock synchronisation",
                        "height": 46,
                        "info": false,
                        "option": "clock-synchro",
                        "kind": "select"
                    },
                    {
                        "id": "6571:16406",
                        "label": "Clock jitter",
                        "height": 48,
                        "info": false,
                        "option": "clock-jitter",
                        "kind": "auto"
                    },
                    {
                        "id": "6571:16418",
                        "label": "Clock reference averaging",
                        "height": 48,
                        "info": false,
                        "option": "clock-average",
                        "kind": "auto"
                    }
                ]
            }
        ]
    },
    "recording": {
        "title": "Recording, Casting & Streaming Out",
        "sections": [
            {
                "title": "Recording",
                "rows": [
                    {
                        "id": "6571:16494",
                        "label": "Save recordings to",
                        "height": 48,
                        "info": false,
                        "option": "input-record-path",
                        "kind": "folder"
                    },
                    {
                        "id": "6571:16772",
                        "label": "Record without re-encoding when possible",
                        "height": 42,
                        "info": false,
                        "option": "input-record-native",
                        "kind": "toggle"
                    }
                ]
            },
            {
                "title": "Casting",
                "rows": [
                    {
                        "id": "6571:16504",
                        "label": "Discover cast devices",
                        "height": 42,
                        "info": false,
                        "special": "rendererDiscovery",
                        "kind": "toggle"
                    },
                    {
                        "id": "6571:16780",
                        "label": "Cast quality",
                        "height": 46,
                        "info": false,
                        "option": "sout-chromecast-conversion-quality",
                        "kind": "select"
                    }
                ]
            },
            {
                "title": "Streaming",
                "rows": [
                    {
                        "id": "6571:16800",
                        "label": "Play locally while streaming",
                        "height": 42,
                        "info": false,
                        "option": "sout-display",
                        "kind": "toggle"
                    },
                    {
                        "id": "6571:16825",
                        "label": "Include audio",
                        "height": 42,
                        "info": false,
                        "option": "sout-audio",
                        "kind": "toggle"
                    },
                    {
                        "id": "6571:16833",
                        "label": "Include video",
                        "height": 42,
                        "info": false,
                        "option": "sout-video",
                        "kind": "toggle"
                    },
                    {
                        "id": "6571:16841",
                        "label": "Include subtitles",
                        "height": 42,
                        "info": false,
                        "option": "sout-spu",
                        "kind": "toggle"
                    },
                    {
                        "id": "6571:16805",
                        "label": "Encoding preset",
                        "height": 46,
                        "info": false,
                        "option": "sout-x264-preset",
                        "kind": "select"
                    },
                    {
                        "id": "6571:16849",
                        "label": "Tuning",
                        "height": 46,
                        "info": false,
                        "option": "sout-x264-tune",
                        "kind": "select"
                    }
                ]
            },
            {
                "title": "",
                "action": "advanced",
                "height": 38
            }
        ]
    }
})
}
