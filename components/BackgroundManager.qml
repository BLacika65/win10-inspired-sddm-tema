// BackgroundManager.qml
// Modified wallpaper switcher with safe modulo calculation
import QtQuick 2.8

QtObject {
    id: backgroundManager

    // Wallpaper list
    property var backgroundList: [
        "images/background0.jpg",
        "images/background1.jpg",
        "images/background2.jpg",
        "images/background3.jpg",
        "images/background4.jpg",
        "images/background5.jpg",
        "images/background6.jpg",
        "images/background7.jpg"
    ]

    property int currentBackground: 0

    // The background image to display - with safe modulo calculation
    property string currentBackgroundSource: backgroundList[
        ((currentBackground % backgroundList.length) + backgroundList.length) % backgroundList.length
    ]

    property string stateFile: "../theme_state.conf"

    // Initialize
    Component.onCompleted: {
        loadState()
    }

    // Loading status
    function loadState() {
        try {
            var xhr = new XMLHttpRequest()
            xhr.open("GET", stateFile, false)
            xhr.send()

            if (xhr.status === 200) {
                var content = xhr.responseText
                var lines = content.split("\n")
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim()
                    if (line.startsWith("background_index=")) {
                        var index = parseInt(line.substring("background_index=".length))
                        if (!isNaN(index)) {
                            currentBackground = index
                        }
                    }
                }
            }
        } catch (e) {
            // In case of error, the index 0 remains
        }
    }

    // Saving a status
    function saveState() {
        try {
            // Safety modulo calculation before saving
            var safeIndex = ((currentBackground % backgroundList.length) + backgroundList.length) % backgroundList.length
            var content = "background_index=" + safeIndex

            var xhr = new XMLHttpRequest()
            xhr.open("PUT", stateFile, false)
            xhr.send(content)

            return true
        } catch (e) {
            return false
        }
    }

    // Change to the following wallpaper
    function switchToNextBackground() {
        currentBackground += 1

        // The modulo calculation is done automatically in the currentBackgroundSource property
        saveState()
    }
}
