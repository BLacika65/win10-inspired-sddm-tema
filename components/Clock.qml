import QtQuick 2.8
import QtQuick.Layouts 1.2

Rectangle {
    id: clockComponent
    color: "transparent"
    width: 300
    height: 100

    // The time and date section
    Text {
        id: clockText
        anchors.left: parent.left
        anchors.top: parent.top
        font.pixelSize: 42
        color: "white"
        text: Qt.formatTime(new Date(), "hh:mm")

        // Clock update every minute
        Timer {
            interval: 60000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: { clockText.text = Qt.formatTime(new Date(), "hh:mm") }
        }
    }

    // Date
    Text {
        id: dateText
        anchors.left: parent.left
        anchors.top: clockText.bottom
        anchors.topMargin: 5
        font.pixelSize: 24
        color: "white"
        text: new Date().toLocaleDateString(Qt.locale(), "MMMM d., dddd")

        // Date update at midnight
        Timer {
            interval: 3600000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: { dateText.text = new Date().toLocaleDateString(Qt.locale(), "MMMM d., dddd") }
        }
    }
}
