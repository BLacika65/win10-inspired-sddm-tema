// BackgroundManager.qml
// Time-based wallpaper switching, with configurable intervals
import QtQuick 2.8

Item {
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

    //Set time interval (in milliseconds)
    // Choose one of the following or create your own
    readonly property var timeIntervals: {
        "30min": 30 * 60 * 1000,
        "1hour": 60 * 60 * 1000,
        "3hours": 3 * 60 * 60 * 1000,
        "6hours": 6 * 60 * 60 * 1000,
        "12hours": 12 * 60 * 60 * 1000,
        "1day": 24 * 60 * 60 * 1000,
        "3days": 3 * 24 * 60 * 60 * 1000,
        "1week": 7 * 24 * 60 * 60 * 1000,
        "2weeks": 14 * 24 * 60 * 60 * 1000,
        "1month": 30 * 24 * 60 * 60 * 1000
    }

    // Select the time interval you want
    property int selectedInterval: timeIntervals["1day"]  // Write your preferred time here

    // Calculate the current wallpaper index based on time
    property int currentBackground: {
        var now = new Date()
        var epochTime = now.getTime()

        // The time is divided according to the selected time interval
        var timeSlot = Math.floor(epochTime / selectedInterval)

        // Select the wallpaper based on the timeslot
        return timeSlot % backgroundList.length
    }

    // Wallpaper to display
    property string currentBackgroundSource: backgroundList[currentBackground]

    // This function will not do time-based switching, it is only here for compatibility
    function switchToNextBackground() {
        console.log("A háttérkép automatikusan változik a beállított időintervallum alapján: " +
                  Object.keys(timeIntervals).find(key => timeIntervals[key] === selectedInterval))
        // Automatic time-based switching means it does nothing
    }

    // Sets the next time when the wallpaper will change
    property date nextChangeTime: {
        var now = new Date()
        var epochTime = now.getTime()
        var currentSlot = Math.floor(epochTime / selectedInterval)
        var nextChangeEpoch = (currentSlot + 1) * selectedInterval

        return new Date(nextChangeEpoch)
    }

    // Calculates how much time is left until the next wallpaper change (in ms)
    property int timeUntilNextChange: {
        var now = new Date()
        return nextChangeTime.getTime() - now.getTime()
    }

    // Calculation of the following background shift in readable form
    function getTimeUntilNextChangeFormatted() {
        var ms = timeUntilNextChange
        var seconds = Math.floor((ms / 1000) % 60)
        var minutes = Math.floor((ms / (1000 * 60)) % 60)
        var hours = Math.floor((ms / (1000 * 60 * 60)) % 24)
        var days = Math.floor(ms / (1000 * 60 * 60 * 24))

        var result = ""
        if (days > 0) result += days + " nap "
        if (hours > 0) result += hours + " óra "
        if (minutes > 0) result += minutes + " perc "
        result += seconds + " másodperc"

        return result
    }

    // This function is useful for debugging
    function displayCurrentState() {
        console.log("Aktuális háttérkép index: " + currentBackground)
        console.log("Következő háttérváltás: " + nextChangeTime.toLocaleString())
        console.log("Hátralevő idő: " + getTimeUntilNextChangeFormatted())
    }

    // Update timer to update the time displayed on the UI (if necessary)
    Timer {
        interval: 1000
        running: true // Set to true only if you want to display the remaining time in the user interface.
        repeat: true
        onTriggered: {
            // This updates the timeUntilNextChange property every second
            backgroundManager.timeUntilNextChange =
                backgroundManager.nextChangeTime.getTime() - new Date().getTime()
        }
    }
}
