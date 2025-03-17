import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Rectangle {
    id: infoSysRoot
    width: 440
    height: 320
    color: "#2c2c2c"

    // Use the translatorLoader.item in Main.qml as a translator
    // Access to the translator (assuming that translatorLoader is available from the parent component)
    property var translator: translatorLoader.item

    // Background with subtle gradient
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#2c2c2c" }
            GradientStop { position: 1.0; color: "#1a1a1a" }
        }
    }

    ScrollView {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        clip: true

        ColumnLayout {
            width: infoSysRoot.width - 40
            spacing: 15

            // System Info Section
            GroupBox {
                Layout.fillWidth: true
                title: translator.tr("sysBasicInfo")

                // Dark theme label
                label: Label {
                    text: parent.title
                    color: "white"
                    font.bold: true
                }

                background: Rectangle {
                    color: "#3c3c3c"
                    border.color: "#555555"
                    radius: 5
                }

                GridLayout {
                    columns: 2
                    columnSpacing: 10
                    rowSpacing: 8
                    Layout.fillWidth: true

                    Label { text: translator.tr("operatingSystem"); font.bold: true; color: "white" }
                    Label {
                        text: {
                            var os = Qt.platform.os || "Linux";
                            return os.charAt(0).toUpperCase() + os.slice(1);
                        }
                        color: "white"
                    }

                    Label { text: translator.tr("screenResolution"); font.bold: true; color: "white" }
                    Label { text: Screen.width + " px X " + Screen.height + " px"; color: "white" }

                    Label { text: translator.tr("dateTime"); font.bold: true; color: "white" }
                    Label {
                        id: timeLabel
                        property date currentDate: new Date()
                        text: currentDate.toLocaleString(Qt.locale())
                        color: "white"

                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: timeLabel.currentDate = new Date()
                        }
                    }
                }
            }

            // Locale Info Section
            GroupBox {
                Layout.fillWidth: true
                title: translator.tr("localizationInfo")

                // Dark theme label
                label: Label {
                    text: parent.title
                    color: "white"
                    font.bold: true
                }

                background: Rectangle {
                    color: "#3c3c3c"
                    border.color: "#555555"
                    radius: 5
                }

                GridLayout {
                    columns: 2
                    columnSpacing: 10
                    rowSpacing: 8
                    Layout.fillWidth: true

                    Label { text: translator.tr("localization"); font.bold: true; color: "white" }
                    Label { text: Qt.locale().name; color: "white" }

                    Label { text: translator.tr("country"); font.bold: true; color: "white" }
                    Label { text: Qt.locale().nativeCountryName; color: "white" }

                    Label { text: translator.tr("language"); font.bold: true; color: "white" }
                    Label { text: Qt.locale().nativeLanguageName; color: "white" }
                }
            }

            // Network Info Section
            GroupBox {
                Layout.fillWidth: true
                title: translator.tr("networkStatus")

                // Dark theme label
                label: Label {
                    text: parent.title
                    color: "white"
                    font.bold: true
                }

                background: Rectangle {
                    color: "#3c3c3c"
                    border.color: "#555555"
                    radius: 5
                }

                GridLayout {
                    columns: 2
                    columnSpacing: 10
                    rowSpacing: 8
                    Layout.fillWidth: true

                    Label { text: translator.tr("networkAvailable"); font.bold: true; color: "white" }
                    RowLayout {
                        spacing: 5

                        Rectangle {
                            width: 12
                            height: 12
                            radius: 6
                            color: networkChecker.isChecking ? "orange" :
                                  (networkChecker.isOnline ? "green" : "red")
                        }

                        Label {
                            text: networkChecker.isChecking ?
                                translator.tr("checking") :
                                (networkChecker.isOnline ?
                                    translator.tr("yes") :
                                    translator.tr("no"))
                            color: "white"
                        }
                    }
                }
            }
        }
    }

    // Network availability check
    Item {
        id: networkChecker
        property bool isOnline: false
        property bool isChecking: false

        function checkNetworkStatus() {
            isChecking = true;
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    isOnline = (xhr.status >= 200 && xhr.status < 300);
                    isChecking = false;
                }
            }
            xhr.open("HEAD", "https://www.google.com");
            xhr.timeout = 5000;
            xhr.send();
        }

        Component.onCompleted: checkNetworkStatus()

        Timer {
            interval: 10000
            running: true
            repeat: true
            onTriggered: networkChecker.checkNetworkStatus()
        }
    }
}
