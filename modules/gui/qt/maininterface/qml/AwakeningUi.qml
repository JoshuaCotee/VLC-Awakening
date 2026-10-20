// SPDX-License-Identifier: GPL-2.0-or-later
pragma Singleton
import QtQuick

QtObject {
    property string dialog: ""
    property string settingsCategory: "general"
    property string librarySection: "home"
    property bool sidebarVisible: false
    function showSettings(category) {
        settingsCategory = category || "general"
        dialog = "settings"
    }
}
