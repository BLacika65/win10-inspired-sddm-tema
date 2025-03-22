// BackgroundManager.qml
// Random wallpapers without index storage
import QtQuick 2.8

QtObject {
    id: backgroundManager

    // List of wallpapers
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

    // Index of the current wallpaper (randomly initialized)
    property int currentBackground: Math.floor(Math.random() * backgroundList.length)

    // Wallpaper to display
    property string currentBackgroundSource: backgroundList[currentBackground]

    // Switch to a random wallpaper, but not the current one
    function switchToNextBackground() {
        var newIndex
        // Ensures you can choose a different background
        do {
            newIndex = Math.floor(Math.random() * backgroundList.length)
        } while (newIndex === currentBackground && backgroundList.length > 1)

        currentBackground = newIndex
    }
}
