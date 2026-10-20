// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import QtQuick.Templates as T
import VLC.MainInterface
import VLC.MediaLibrary
import VLC.Playlist
import VLC.Dialogs

T.Pane {
    id: root
    readonly property real unit: AwakeningTheme.scale
    readonly property string section: AwakeningUi.librarySection
    property string location: ""
    property string locationTitle: ""
    property var folderItems: []
    property var folderRequest: 0
    property bool loadingFolder: false
    property string folderError: ""
    property var history: []
    property int historyIndex: -1
    property bool restoring: false
    property bool grid: false
    property bool showSearch: false
    property bool ascending: true
    property var audioHistory: []
    readonly property var frequentFolders: {
        AwakeningPreferences.revision
        return AwakeningPreferences.state("folderVisits", []).slice().sort((a, b) => b.visits - a.visits).slice(0, 3)
    }
    property var selectedEntry: null
    property int selectedIndex: -1
    readonly property var visibleFolderItems: {
        const items = folderItems.filter(matches)
        return ascending ? items : items.reverse()
    }
    readonly property var musicCategories: [
        {title: qsTr("Songs"), category: "songs", icon: "music"},
        {title: qsTr("Albums"), category: "albums", icon: "album"},
        {title: qsTr("Artists"), category: "artists", icon: "artist"},
        {title: qsTr("Genres"), category: "genres", icon: "genre"}
    ]
    readonly property var titles: ({
        home: qsTr("Home"), videos: qsTr("Videos"), music: qsTr("Music"), songs: qsTr("Songs"),
        albums: qsTr("Albums"), artists: qsTr("Artists"), genres: qsTr("Genres"),
        network: qsTr("Network"), playlists: qsTr("Playlists"), recent: qsTr("Recent"),
        queue: qsTr("Play Queue"), playlist: locationTitle, tracks: locationTitle
    })
    readonly property var activeModel: location ? folderItems : ({
        videos: videos, songs: songs, albums: albums, artists: artists, genres: genres,
        tracks: songs, music: musicCategories, network: streams, playlists: playlists,
        playlist: playlistContents, recent: recent, queue: filteredQueue
    }[section] || recent)
    readonly property int itemCount: section === "queue" ? queue.count
        : location ? visibleFolderItems.length : activeModel ? (activeModel.count ?? activeModel.length ?? 0) : 0
    readonly property string title: location ? locationTitle : titles[section] || qsTr("Home")
    padding: 0
    implicitWidth: 427 * unit
    background: Rectangle { color: AwakeningTheme.panel }
    onSectionChanged: {
        if (!restoring) {
            location = ""
            locationTitle = ""
            songs.parentId = undefined
            selectedIndex = -1
            selectedEntry = null
            remember()
        }
    }
    Component.onCompleted: remember()
    function remember() {
        if (restoring) return
        const next = history.slice(0, historyIndex + 1)
        next.push({section: section, location: location, title: locationTitle, parentId: section === "tracks" ? songs.parentId : playlistContents.parentId})
        history = next
        historyIndex = next.length - 1
    }
    function navigateHistory(offset) {
        const index = historyIndex + offset
        if (index < 0 || index >= history.length) return
        restoring = true
        historyIndex = index
        const entry = history[index]
        AwakeningUi.librarySection = entry.section
        locationTitle = entry.title
        location = entry.location
        if (entry.section === "tracks") songs.parentId = entry.parentId
        if (entry.section === "playlist") playlistContents.parentId = entry.parentId
        if (location) loadFolder(location, locationTitle, false)
        restoring = false
    }
    function loadFolder(url, title, record) {
        location = String(url)
        locationTitle = title || decodeURIComponent(location.split("/").filter(part => !!part).pop())
        folderItems = []
        folderError = ""
        loadingFolder = true
        folderRequest = AwakeningPreferences.requestFolder(url)
        if (record !== false) {
            const visited = AwakeningPreferences.state("folderVisits", []).slice()
            const index = visited.findIndex(item => String(item.url) === location)
            const entry = {url: location, title: locationTitle, isFolder: true, visits: index < 0 ? 1 : visited[index].visits + 1}
            if (index >= 0) visited.splice(index, 1)
            visited.push(entry)
            AwakeningPreferences.setState("folderVisits", visited.slice(-100))
            remember()
        }
    }
    function addFolder() {
        const path = AwakeningPreferences.choosePath("", true)
        if (!path) return
        const url = AwakeningPreferences.localUrl(path)
        if (MainCtx.mediaLibraryAvailable) folders.add(url)
        loadFolder(url, path.replace(/\\/g, "/").split("/").pop(), true)
    }
    function openEntry(entry, index) {
        if (entry.category) { AwakeningUi.librarySection = entry.category; return }
        if (entry.isFolder || entry.display_url !== undefined) {
            loadFolder(entry.url, entry.title || entry.display_url, true)
        } else if (section === "playlists") {
            restoring = true
            playlistContents.parentId = entry.id
            locationTitle = entry.name
            AwakeningUi.librarySection = "playlist"
            restoring = false
            remember()
        } else if (["albums", "artists", "genres"].includes(section)) {
            restoring = true
            songs.parentId = entry.id
            locationTitle = entry.title || entry.name
            AwakeningUi.librarySection = "tracks"
            restoring = false
            remember()
        } else if (section === "queue") {
            MainPlaylistController.goTo(filteredQueue.mapToSource(filteredQueue.index(index, 0)).row, true)
        } else if (entry.id && MainCtx.mediaLibraryAvailable) {
            MainCtx.mediaLibrary.addAndPlay(entry.id)
        } else if (entry.url || entry.mrl) {
            MainPlaylistController.append(entry.url || entry.mrl, true)
        }
    }
    function addEntry(entry) {
        if (entry.id && MainCtx.mediaLibraryAvailable) MainCtx.mediaLibrary.addToPlaylist(entry.id)
        else if (entry.url || entry.mrl) MainPlaylistController.append(entry.url || entry.mrl, false)
    }
    function matches(entry) {
        return !search.text || String(entry.title || entry.name || entry.url || "").toLowerCase().includes(search.text.toLowerCase())
    }
    Connections {
        target: AwakeningPreferences
        function onFolderLoaded(requestId, url, items, error) {
            if (requestId !== root.folderRequest) return
            root.folderItems = items
            root.folderError = error
            root.loadingFolder = false
        }
    }
    MLFolderModel { id: folders; ctx: MainCtx }
    MLVideoModel { id: videos; ml: MainCtx.mediaLibrary; searchPattern: search.text; sortOrder: root.ascending ? Qt.AscendingOrder : Qt.DescendingOrder }
    MLAudioModel { id: songs; ml: MainCtx.mediaLibrary; searchPattern: search.text; sortOrder: root.ascending ? Qt.AscendingOrder : Qt.DescendingOrder }
    MLAlbumModel { id: albums; ml: MainCtx.mediaLibrary; searchPattern: search.text; sortOrder: videos.sortOrder }
    MLArtistModel { id: artists; ml: MainCtx.mediaLibrary; searchPattern: search.text; sortOrder: videos.sortOrder }
    MLGenreModel { id: genres; ml: MainCtx.mediaLibrary; searchPattern: search.text; sortOrder: videos.sortOrder }
    MLRecentMediaModel { id: recent; ml: MainCtx.mediaLibrary; searchPattern: search.text }
    MLRecentVideoModel { id: recentVideos; ml: MainCtx.mediaLibrary; limit: 3 }
    MLRecentMediaModel {
        id: recentSongs; ml: MainCtx.mediaLibrary; limit: 24
        function refresh() {
            getDataFlat(Array.from({length: count}, (value, index) => index), data => {
                root.audioHistory = data.filter(row => row && !row.isVideo).slice(0, 3)
            })
        }
        onCountChanged: Qt.callLater(refresh)
        onModelReset: Qt.callLater(refresh)
        Component.onCompleted: Qt.callLater(refresh)
    }
    MLUrlModel { id: streams; ml: MainCtx.mediaLibrary; searchPattern: search.text; sortOrder: videos.sortOrder }
    MLPlaylistListModel { id: playlists; ml: MainCtx.mediaLibrary; searchPattern: search.text; sortOrder: videos.sortOrder }
    MLPlaylistListModel { id: homePlaylists; ml: MainCtx.mediaLibrary; limit: 3 }
    MLPlaylistModel { id: playlistContents; ml: MainCtx.mediaLibrary; searchPattern: search.text }
    PlaylistListModel { id: queue; playlist: MainPlaylistController.playlist }
    QtSortFilterProxyModel {
        id: filteredQueue
        sourceModel: queue
        filterCaseSensitivity: Qt.CaseInsensitive
        filterRole: Qt.DisplayRole
        filterRegularExpression: search.text.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")
    }
    contentItem: Item {
        Rectangle {
            width: 50 * root.unit
            height: parent.height
            color: AwakeningTheme.surface
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                y: 8 * root.unit
                spacing: 14 * root.unit
                Repeater {
                    model: [
                        {id: "home", icon: "home", label: qsTr("Home")},
                        {id: "videos", icon: "videos", label: qsTr("Videos")},
                        {id: "settings", icon: "settings", label: qsTr("Settings")},
                        {id: "network", icon: "streaming", label: qsTr("Network")},
                        {id: "playlists", icon: "playlist", label: qsTr("Playlists")},
                        {id: "recent", icon: "recent", label: qsTr("Recent")},
                        {id: "add", icon: "add", label: qsTr("Add media")}
                    ]
                    AwakeningLibraryButton {
                        required property var modelData
                        artwork: modelData.icon
                        description: modelData.label
                        checked: root.section === modelData.id
                        onClicked: {
                            if (modelData.id === "settings") AwakeningUi.showSettings()
                            else if (modelData.id === "add") root.addFolder()
                            else AwakeningUi.librarySection = modelData.id
                        }
                    }
                }
            }
        }
        Item {
            x: 70 * root.unit
            y: 20 * root.unit
            width: parent.width - 90 * root.unit
            height: parent.height - y
            Row {
                spacing: 12 * root.unit
                AwakeningLibraryButton { width: 24 * root.unit; height: width; artwork: "back"; description: qsTr("Back"); enabled: root.historyIndex > 0; onClicked: root.navigateHistory(-1) }
                AwakeningLibraryButton { width: 24 * root.unit; height: width; artwork: "forward"; description: qsTr("Forward"); enabled: root.historyIndex + 1 < root.history.length; onClicked: root.navigateHistory(1) }
            }
            AwakeningText {
                x: 70 * root.unit
                width: Math.max(0, parent.width - 140 * root.unit)
                height: 24 * root.unit
                text: root.title
                font.pixelSize: 16 * root.unit
                elide: Text.ElideMiddle
            }
            Row {
                anchors.right: parent.right
                spacing: 12 * root.unit
                AwakeningLibraryButton { width: 24 * root.unit; height: width; artwork: "more"; description: qsTr("Library actions"); onClicked: actions.open() }
                AwakeningLibraryButton {
                    width: 24 * root.unit; height: width; artwork: "open"; description: qsTr("Open folder")
                    onClicked: root.addFolder()
                }
            }
            AwakeningText {
                y: 44 * root.unit
                height: 24 * root.unit
                text: qsTr("%1 items").arg(root.section === "home" ? recent.count : root.itemCount)
            }
            Row {
                anchors.right: parent.right
                y: 44 * root.unit
                spacing: 12 * root.unit
                AwakeningLibraryButton {
                    width: 24 * root.unit; height: width; artwork: "sort"; description: qsTr("Reverse sort order")
                    onClicked: {
                        root.ascending = !root.ascending
                        if (root.section === "queue") filteredQueue.sort(0, root.ascending ? Qt.AscendingOrder : Qt.DescendingOrder)
                    }
                }
                AwakeningLibraryButton { width: 24 * root.unit; height: width; artwork: "list"; description: qsTr("Switch list or grid"); checked: root.grid; onClicked: root.grid = !root.grid }
                AwakeningLibraryButton { width: 24 * root.unit; height: width; artwork: "search"; description: qsTr("Search"); checked: root.showSearch; onClicked: { root.showSearch = !root.showSearch; if (root.showSearch) search.forceActiveFocus() } }
            }
            Rectangle { y: 85 * root.unit; width: parent.width; height: root.unit; color: AwakeningTheme.selected }
            AwakeningField {
                id: search
                y: 100 * root.unit
                width: parent.width
                visible: root.showSearch
                placeholderText: qsTr("Search")
                onVisibleChanged: if (!visible) text = ""
            }
            Flickable {
                id: content
                visible: root.section === "home" && !root.location
                y: (root.showSearch ? 146 : 105) * root.unit
                width: parent.width
                height: parent.height - y
                contentHeight: body.height + 20 * root.unit
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                C.ScrollBar.vertical: C.ScrollBar {}
                Column {
                    id: body
                    width: content.width
                    spacing: 10 * root.unit
                    Repeater {
                        model: root.section === "home" && !root.location ? [
                            {title: qsTr("Continue Watching"), model: recentVideos, destination: "videos"},
                            {title: qsTr("Listen Again"), model: root.audioHistory, destination: "music"},
                            {title: qsTr("Frequently Visited Folders"), model: root.frequentFolders, destination: "videos"},
                            {title: qsTr("Playlists"), model: homePlaylists, destination: "playlists"}
                        ] : []
                        Column {
                            id: homeSection
                            required property var modelData
                            width: body.width
                            spacing: 10 * root.unit
                            bottomPadding: 30 * root.unit
                            T.Button {
                                width: parent.width; height: 32 * root.unit
                                onClicked: AwakeningUi.librarySection = homeSection.modelData.destination
                                background: Item {}
                                contentItem: AwakeningText { text: homeSection.modelData.title; font.pixelSize: 16 * root.unit; color: AwakeningTheme.heading }
                            }
                            Repeater {
                                model: homeSection.modelData.model
                                MediaRow {
                                    required property var model
                                    required property int index
                                    width: homeSection.width
                                    entry: model.modelData === undefined ? model : model.modelData
                                    rowIndex: index
                                    onOpen: {
                                        if (homeSection.modelData.destination === "playlists") {
                                            AwakeningUi.librarySection = "playlists"
                                            root.openEntry(entry, index)
                                        } else root.openEntry(entry, index)
                                    }
                                }
                            }
                        }
                    }
                    AwakeningText {
                        width: body.width
                        wrapMode: Text.Wrap
                        visible: root.loadingFolder || !!root.folderError || (root.section !== "home" && !root.itemCount)
                        text: root.loadingFolder ? qsTr("Loading...") : root.folderError || qsTr("No items here yet.")
                        color: AwakeningTheme.muted
                    }
                }
            }
            Loader {
                id: listing
                y: content.y
                width: parent.width
                height: parent.height - y
                active: !content.visible
                visible: active
                sourceComponent: root.grid ? gridView : listView
            }
        }
    }
    Component {
        id: listHeader
        Item {
            width: listing.width
            height: !root.location && ["videos", "music", "network", "playlists"].includes(root.section) ? 42 * root.unit : 0
            visible: height > 0
            T.Button {
                width: parent.width; height: 32 * root.unit
                onClicked: {
                    if (root.section === "network") AwakeningUi.dialog = "network"
                    else if (root.section === "playlists") AwakeningUi.dialog = "newPlaylist"
                    else root.addFolder()
                }
                background: Item {}
                contentItem: Row {
                    spacing: 10 * root.unit
                    Image { width: 32 * root.unit; height: width; source: "qrc:/awakening/library/add.svg" }
                    AwakeningText { height: 32 * root.unit; text: root.section === "network" ? qsTr("Add Network Stream") : qsTr("Add") }
                }
            }
        }
    }
    Component {
        id: listView
        ListView {
            clip: true
            spacing: 10 * root.unit
            model: root.location ? root.visibleFolderItems : root.activeModel
            header: listHeader
            boundsBehavior: Flickable.StopAtBounds
            C.ScrollBar.vertical: C.ScrollBar {}
            delegate: MediaRow {
                required property var model
                required property int index
                entry: model.modelData === undefined ? model : model.modelData
                rowIndex: index
                width: listing.width
                onOpen: root.openEntry(entry, index)
            }
            AwakeningText {
                anchors.centerIn: parent
                width: parent.width
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                visible: parent.count === 0
                text: root.loadingFolder ? qsTr("Loading...") : root.folderError || qsTr("No items here yet.")
                color: AwakeningTheme.muted
            }
        }
    }
    Component {
        id: gridView
        GridView {
            clip: true
            model: root.location ? root.visibleFolderItems : root.activeModel
            cellWidth: width / 2
            cellHeight: cellWidth + 32 * root.unit
            header: listHeader
            boundsBehavior: Flickable.StopAtBounds
            C.ScrollBar.vertical: C.ScrollBar {}
            delegate: MediaRow {
                required property var model
                required property int index
                entry: model.modelData === undefined ? model : model.modelData
                rowIndex: index
                width: listing.width / 2 - 7 * root.unit
                grid: true
                onOpen: root.openEntry(entry, index)
            }
        }
    }
    component MediaRow: T.Button {
        id: media
        required property var entry
        required property int rowIndex
        property bool grid: false
        signal open()
        readonly property string label: entry.title || entry.name || entry.display_url || String(entry.url || "")
        readonly property string cover: {
            AwakeningPreferences.revision
            const custom = entry.id ? AwakeningPreferences.state("playlistArtwork/" + entry.id.toString(), "") : ""
            return String(custom || entry.thumbnail || entry.small_cover || entry.cover || entry.artwork || "")
        }
        height: grid ? width + 32 * root.unit : 32 * root.unit
        hoverEnabled: true
        padding: 0
        Accessible.name: label
        onClicked: { root.selectedEntry = entry; root.selectedIndex = rowIndex }
        onDoubleClicked: open()
        Keys.onReturnPressed: open()
        background: Rectangle {
            radius: 4 * root.unit
            color: media.hovered || root.selectedIndex === media.rowIndex ? AwakeningTheme.surface : "transparent"
        }
        contentItem: Item {
            Rectangle {
                width: media.grid ? parent.width : 32 * root.unit
                height: width
                color: AwakeningTheme.surface
                radius: 4 * root.unit
                Image {
                    anchors.fill: parent
                    source: media.cover
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    visible: !!media.cover
                }
                Image {
                    anchors.centerIn: parent
                    width: 24 * root.unit
                    height: width
                    visible: !media.cover
                    source: "qrc:/awakening/library/" + (media.entry.icon || (media.entry.isFolder || media.entry.display_url !== undefined ? "folder" : media.entry.isVideo ? "videos" : "music")) + ".svg"
                    mirror: true
                }
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width * (media.entry.progress || 0)
                    height: 3 * root.unit
                    color: AwakeningTheme.accent
                }
            }
            AwakeningText {
                x: media.grid ? 0 : 42 * root.unit
                y: media.grid ? media.width + 6 * root.unit : 0
                width: parent.width - x
                height: media.grid ? 20 * root.unit : parent.height
                text: media.label
                elide: Text.ElideRight
            }
        }
        TapHandler {
            acceptedButtons: Qt.RightButton
            onTapped: {
                root.selectedEntry = media.entry
                root.selectedIndex = media.rowIndex
                actions.open()
            }
        }
    }
    T.Popup {
        id: actions
        x: Math.max(50 * root.unit, root.width - width - 10 * root.unit)
        y: 52 * root.unit
        width: 230 * root.unit
        padding: 6 * root.unit
        background: Rectangle { color: AwakeningTheme.surface; radius: 6 * root.unit; border.width: 1; border.color: AwakeningTheme.selected }
        contentItem: Column {
            spacing: 4 * root.unit
            AwakeningAction { width: parent.width; text: qsTr("Play"); enabled: !!root.selectedEntry; onClicked: { root.openEntry(root.selectedEntry, root.selectedIndex); actions.close() } }
            AwakeningAction { width: parent.width; text: qsTr("Add to play queue"); enabled: !!root.selectedEntry; onClicked: { root.addEntry(root.selectedEntry); actions.close() } }
            AwakeningAction {
                width: parent.width; text: qsTr("Remove from queue"); visible: root.section === "queue"; enabled: root.selectedIndex >= 0
                onClicked: {
                    queue.removeItems([filteredQueue.mapToSource(filteredQueue.index(root.selectedIndex, 0)).row])
                    root.selectedIndex = -1
                    root.selectedEntry = null
                    actions.close()
                }
            }
            AwakeningAction { width: parent.width; text: qsTr("Add folder"); onClicked: { actions.close(); root.addFolder() } }
            AwakeningAction { width: parent.width; text: qsTr("Library settings"); onClicked: { actions.close(); AwakeningUi.showSettings("library") } }
        }
    }
}
