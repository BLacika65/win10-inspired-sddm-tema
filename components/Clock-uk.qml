// Clock-uk.qml - British version
import QtQuick 2.8
import QtQuick.Layouts 1.2

Rectangle {
    id: clockComponent
    color: "transparent"
    width: 300
    height: 100

    // Time display - 12-hour format with AM/PM
    Text {
        id: clockText
        anchors.left: parent.left
        anchors.top: parent.top
        font.pixelSize: 42
        color: "white"
        text: Qt.formatTime(new Date(), "h:mm ap")

        // Clock update every minute
        Timer {
            interval: 60000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: { clockText.text = Qt.formatTime(new Date(), "h:mm ap") }
        }
    }

    // Date - UK format: day name, day number, month name
    Text {
        id: dateText
        anchors.left: parent.left
        anchors.top: clockText.bottom
        anchors.topMargin: 5
        font.pixelSize: 24
        color: "white"

        function updateDateText() {
            var date = new Date();
            var locale = Qt.locale("en_GB");
            var dayName = date.toLocaleDateString(locale, "dddd");
            var monthName = date.toLocaleDateString(locale, "MMMM");
            var dayNumber = date.getDate();

            // British format: "Friday, 14 March"
            return dayName + ", " + dayNumber + " " + monthName;
        }

        text: updateDateText()

        // Date update at midnight
        Timer {
            interval: 3600000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: { dateText.text = dateText.updateDateText() }
        }
    }
}
