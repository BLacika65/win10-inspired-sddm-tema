// VirtualKeyboard.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Item {
    id: virtualKeyboard
    width: Math.min(Math.max(600, parent.width * 0.9), 800)  // Min 600px, max 800px, 90%
    height: parent.height * 0.3
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.left: undefined
    anchors.right: undefined
    y: parent.height
    visible: false


    // Enter signal, for main.qml
    signal enterPressed()

    property var targetInput: null
    property bool shiftEnabled: false
    property bool capsLockEnabled: false
    property bool specialCharsVisible: false

    // Current keyboard layout (default Hungarian)
    property string currentLayout: "hu_HU"
    property var keyboardLayout: getLayoutByLanguage(currentLayout)

    // Query language allocations
    function getLayoutByLanguage(layoutCode) {
        switch(layoutCode) {
            case "en_US": return englishLayout;
            case "de_DE": return germanLayout;
            default: return hungarianLayout;
        }
    }

    // Update allocation by language
    function changeLanguage(layoutCode) {
        currentLayout = layoutCode;
        keyboardLayout = getLayoutByLanguage(layoutCode);
    }

    // Change to next language
    function switchToNextLanguage() {
        if (currentLayout === "hu_HU") {
            changeLanguage("en_US");
        } else if (currentLayout === "en_US") {
            changeLanguage("de_DE");
        } else {
            changeLanguage("hu_HU");
        }
    }

    // Keyboard layout in Hungarian
    property var hungarianLayout: [
        [
            { text: "0", shiftText: "§" },
            { text: "1", shiftText: "'" },
            { text: "2", shiftText: "\"" },
            { text: "3", shiftText: "+" },
            { text: "4", shiftText: "!" },
            { text: "5", shiftText: "%" },
            { text: "6", shiftText: "/" },
            { text: "7", shiftText: "=" },
            { text: "8", shiftText: "(" },
            { text: "9", shiftText: ")" },
            { text: "ö", shiftText: "Ö" },
            { text: "ü", shiftText: "Ü" },
            { text: "ó", shiftText: "Ó" },
            { text: "⌫", shiftText: "⌫", displayText: "Back", specialKey: true, size: 1.5 }
        ],
        [
            { text: "⇥", shiftText: "⇥", displayText: "Tab", specialKey: true, size: 1.5 },
            { text: "q", shiftText: "Q" },
            { text: "w", shiftText: "W" },
            { text: "e", shiftText: "E" },
            { text: "r", shiftText: "R" },
            { text: "t", shiftText: "T" },
            { text: "z", shiftText: "Z" },
            { text: "u", shiftText: "U" },
            { text: "i", shiftText: "I" },
            { text: "o", shiftText: "O" },
            { text: "p", shiftText: "P" },
            { text: "ő", shiftText: "Ő" },
            { text: "ú", shiftText: "Ú" },
            { text: "\\", shiftText: "|" }
        ],
        [
            { text: "Caps", shiftText: "Caps", specialKey: true, size: 1.8 },
            { text: "a", shiftText: "A" },
            { text: "s", shiftText: "S" },
            { text: "d", shiftText: "D" },
            { text: "f", shiftText: "F" },
            { text: "g", shiftText: "G" },
            { text: "h", shiftText: "H" },
            { text: "j", shiftText: "J" },
            { text: "k", shiftText: "K" },
            { text: "l", shiftText: "L" },
            { text: "é", shiftText: "É" },
            { text: "á", shiftText: "Á" },
            { text: "ű", shiftText: "Ű" },
           { text: "↵", shiftText: "↵", displayText: "Enter", specialKey: true, size: 2.2 }
        ],
        [
            { text: "⇧", shiftText: "⇧", displayText: "Shift", specialKey: true, size: 1.5 },
            { text: "í", shiftText: "Í" },
            { text: "y", shiftText: "Y" },
            { text: "x", shiftText: "X" },
            { text: "c", shiftText: "C" },
            { text: "v", shiftText: "V" },
            { text: "b", shiftText: "B" },
            { text: "n", shiftText: "N" },
            { text: "m", shiftText: "M" },
            { text: ",", shiftText: "?" },
            { text: ".", shiftText: ":" },
            { text: "-", shiftText: "_" },
            { text: "⇧", shiftText: "⇧", displayText: "Shift", specialKey: true, size: 1.5 }
        ],
        [
            { text: "123", shiftText: "123", specialKey: true, size: 1.5 },
            { text: "Lang", shiftText: "Lang", specialKey: true, size: 1.5 },
            { text: "Space", shiftText: "Space", displayText: " ", specialKey: true, size: 7 },
            { text: ";", shiftText: ";" },
            { text: "Hide", shiftText: "Hide", specialKey: true, size: 2 }
        ]
    ]

    // English (US) keyboard layout
    property var englishLayout: [
        [
            { text: "`", shiftText: "~" },
            { text: "1", shiftText: "!" },
            { text: "2", shiftText: "@" },
            { text: "3", shiftText: "#" },
            { text: "4", shiftText: "$" },
            { text: "5", shiftText: "%" },
            { text: "6", shiftText: "^" },
            { text: "7", shiftText: "&" },
            { text: "8", shiftText: "*" },
            { text: "9", shiftText: "(" },
            { text: "0", shiftText: ")" },
            { text: "-", shiftText: "_" },
            { text: "=", shiftText: "+" },
            { text: "⌫", shiftText: "⌫", displayText: "Back", specialKey: true, size: 1.5 }
        ],
        [
            { text: "⇥", shiftText: "⇥", displayText: "Tab", specialKey: true, size: 1.5 },
            { text: "q", shiftText: "Q" },
            { text: "w", shiftText: "W" },
            { text: "e", shiftText: "E" },
            { text: "r", shiftText: "R" },
            { text: "t", shiftText: "T" },
            { text: "y", shiftText: "Y" },
            { text: "u", shiftText: "U" },
            { text: "i", shiftText: "I" },
            { text: "o", shiftText: "O" },
            { text: "p", shiftText: "P" },
            { text: "[", shiftText: "{" },
            { text: "]", shiftText: "}" },
            { text: "\\", shiftText: "|" }
        ],
        [
            { text: "Caps", shiftText: "Caps", specialKey: true, size: 1.8 },
            { text: "a", shiftText: "A" },
            { text: "s", shiftText: "S" },
            { text: "d", shiftText: "D" },
            { text: "f", shiftText: "F" },
            { text: "g", shiftText: "G" },
            { text: "h", shiftText: "H" },
            { text: "j", shiftText: "J" },
            { text: "k", shiftText: "K" },
            { text: "l", shiftText: "L" },
            { text: ";", shiftText: ":" },
            { text: "'", shiftText: "\"" },
            { text: "↵", shiftText: "↵", displayText: "Enter", specialKey: true, size: 2.2 }
        ],
        [
            { text: "⇧", shiftText: "⇧", displayText: "Shift", specialKey: true, size: 1.5 },
            { text: "z", shiftText: "Z" },
            { text: "x", shiftText: "X" },
            { text: "c", shiftText: "C" },
            { text: "v", shiftText: "V" },
            { text: "b", shiftText: "B" },
            { text: "n", shiftText: "N" },
            { text: "m", shiftText: "M" },
            { text: ",", shiftText: "<" },
            { text: ".", shiftText: ">" },
            { text: "/", shiftText: "?" },
            { text: "⇧", shiftText: "⇧", displayText: "Shift", specialKey: true, size: 1.5 }
        ],
        [
            { text: "123", shiftText: "123", specialKey: true, size: 1.5 },
            { text: "Lang", shiftText: "Lang", specialKey: true, size: 1.5 },
            { text: "Space", shiftText: "Space", displayText: " ", specialKey: true, size: 7 },
            { text: ";", shiftText: ";" },
            { text: "Hide", shiftText: "Hide", specialKey: true, size: 2 }
        ]
    ]

    // German keyboard layout
    property var germanLayout: [
        [
            { text: "^", shiftText: "°" },
            { text: "1", shiftText: "!" },
            { text: "2", shiftText: "\"" },
            { text: "3", shiftText: "§" },
            { text: "4", shiftText: "$" },
            { text: "5", shiftText: "%" },
            { text: "6", shiftText: "&" },
            { text: "7", shiftText: "/" },
            { text: "8", shiftText: "(" },
            { text: "9", shiftText: ")" },
            { text: "0", shiftText: "=" },
            { text: "ß", shiftText: "?" },
            { text: "´", shiftText: "`" },
            { text: "⌫", shiftText: "⌫", displayText: "Back", specialKey: true, size: 1.5 }
        ],
        [
            { text: "⇥", shiftText: "⇥", displayText: "Tab", specialKey: true, size: 1.5 },
            { text: "q", shiftText: "Q" },
            { text: "w", shiftText: "W" },
            { text: "e", shiftText: "E" },
            { text: "r", shiftText: "R" },
            { text: "t", shiftText: "T" },
            { text: "z", shiftText: "Z" },
            { text: "u", shiftText: "U" },
            { text: "i", shiftText: "I" },
            { text: "o", shiftText: "O" },
            { text: "p", shiftText: "P" },
            { text: "ü", shiftText: "Ü" },
            { text: "+", shiftText: "*" },
            { text: "#", shiftText: "'" }
        ],
        [
            { text: "Caps", shiftText: "Caps", specialKey: true, size: 1.8 },
            { text: "a", shiftText: "A" },
            { text: "s", shiftText: "S" },
            { text: "d", shiftText: "D" },
            { text: "f", shiftText: "F" },
            { text: "g", shiftText: "G" },
            { text: "h", shiftText: "H" },
            { text: "j", shiftText: "J" },
            { text: "k", shiftText: "K" },
            { text: "l", shiftText: "L" },
            { text: "ö", shiftText: "Ö" },
            { text: "ä", shiftText: "Ä" },
            { text: "↵", shiftText: "↵", displayText: "Enter", specialKey: true, size: 2.2 }
        ],
        [
            { text: "⇧", shiftText: "⇧", displayText: "Shift", specialKey: true, size: 1.5 },
            { text: "<", shiftText: ">" },
            { text: "y", shiftText: "Y" },
            { text: "x", shiftText: "X" },
            { text: "c", shiftText: "C" },
            { text: "v", shiftText: "V" },
            { text: "b", shiftText: "B" },
            { text: "n", shiftText: "N" },
            { text: "m", shiftText: "M" },
            { text: ",", shiftText: ";" },
            { text: ".", shiftText: ":" },
            { text: "-", shiftText: "_" },
            { text: "⇧", shiftText: "⇧", displayText: "Shift", specialKey: true, size: 1.5 }
        ],
        [
            { text: "123", shiftText: "123", specialKey: true, size: 1.5 },
            { text: "Lang", shiftText: "Lang", specialKey: true, size: 1.5 },
            { text: "Space", shiftText: "Space", displayText: " ", specialKey: true, size: 7 },
            { text: ";", shiftText: ";" },
            { text: "Hide", shiftText: "Hide", specialKey: true, size: 2 }
        ]
    ]

    // Allocating special characters
    property var specialCharsLayout: [
        [
            { text: "1", shiftText: "1" },
            { text: "2", shiftText: "2" },
            { text: "3", shiftText: "3" },
            { text: "4", shiftText: "4" },
            { text: "5", shiftText: "5" },
            { text: "6", shiftText: "6" },
            { text: "7", shiftText: "7" },
            { text: "8", shiftText: "8" },
            { text: "9", shiftText: "9" },
            { text: "0", shiftText: "0" },
            { text: "⌫", shiftText: "⌫", displayText: "Back", specialKey: true, size: 2 }
        ],
        [
            { text: "@", shiftText: "@" },
            { text: "#", shiftText: "#" },
            { text: "$", shiftText: "$" },
            { text: "%", shiftText: "%" },
            { text: "&", shiftText: "&" },
            { text: "*", shiftText: "*" },
            { text: "-", shiftText: "-" },
            { text: "+", shiftText: "+" },
            { text: "(", shiftText: "(" },
            { text: ")", shiftText: ")" },
            { text: "=", shiftText: "=" }
        ],
        [
            { text: "^", shiftText: "^", displayText: "^", size: 1.2 },
            { text: "!", shiftText: "!" },
            { text: "\"", shiftText: "\"" },
            { text: "'", shiftText: "'" },
            { text: ":", shiftText: ":" },
            { text: ";", shiftText: ";" },
            { text: "/", shiftText: "/" },
            { text: "?", shiftText: "?" },
            { text: "~", shiftText: "~" },
            { text: "`", shiftText: "`" },
            { text: "↵", shiftText: "↵", displayText: "Enter", specialKey: true, size: 1.5 }
        ],
        [
            { text: "⇧", shiftText: "⇧", displayText: "Shift", specialKey: true, size: 1.5 },
            { text: "<", shiftText: "<" },
            { text: ">", shiftText: ">" },
            { text: "{", shiftText: "{" },
            { text: "}", shiftText: "}" },
            { text: "[", shiftText: "[" },
            { text: "]", shiftText: "]" },
            { text: "€", shiftText: "€" },
            { text: "£", shiftText: "£" },
            { text: "\\", shiftText: "\\" },
            { text: "|", shiftText: "|" },
            { text: "⇧", shiftText: "⇧", displayText: "Shift", specialKey: true, size: 1.5 }
        ],
        [
            { text: "ABC", shiftText: "ABC", specialKey: true, size: 1.5 },
            { text: "Lang", shiftText: "Lang", specialKey: true, size: 1.5 },
            { text: "Space", shiftText: "Space", displayText: " ", specialKey: true, size: 7 },
            { text: ";", shiftText: ";" },
            { text: "Hide", shiftText: "Hide", specialKey: true, size: 2 }
        ]
    ]

    // Keyboard initialization on completion
    Component.onCompleted: {
        console.log("VirtualKeyboard inicializálva.");
    }

 function show(inputField) {
    console.log("Billentyűzet megjelenítése");
    targetInput = inputField;
    visible = true;
    animation.to = parent.height - height;
    animation.start();
}

function updateTargetInput(inputField) {
    console.log("Target input frissítve");
    targetInput = inputField;
}

    function hide() {
        console.log("Billentyűzet elrejtése");
        animation.to = parent.height;
        animation.start();
    }

    // Animation for show/hide
    NumberAnimation {
        id: animation
        target: virtualKeyboard
        property: "y"
        duration: 300
        easing.type: Easing.OutCubic
        onFinished: {
            if (y >= parent.height) {
                visible = false;
            }
        }
    }

    // Add text to input field
    function addTextToInput(text) {
        if (targetInput) {
            // Check the type of targetInput and update it accordingly
            if (targetInput.hasOwnProperty("text")) {
                targetInput.text += text;
            } else {
                console.log("Nem támogatott input típus");
            }
        } else {
            console.log("Nincs targetInput beállítva");
        }
    }

    // Backspace function
    function backspace() {
        if (targetInput && targetInput.text && targetInput.text.length > 0) {
            targetInput.text = targetInput.text.substring(0, targetInput.text.length - 1);
        }
    }

    // Enter function - modified to release the signal
    function handleEnter() {
        if (targetInput) {
            // Sends the contents of the input field (displayed here for console test purposes only)
           // console.log("Submitted text: " + targetInput.text);

            // Issue the enterPressed signal
            enterPressed();

            // Keeping old logic for compatibility reasons
            if (targetInput.onEnterPressed) {
                targetInput.onEnterPressed();
            }
        }
    }

    // Shift state management
    function toggleShift() {
        shiftEnabled = !shiftEnabled;
    }

    // Caps Lock state management
    function toggleCapsLock() {
        capsLockEnabled = !capsLockEnabled;
    }

    // Switch between special characters/normal characters
    function toggleSpecialChars() {
        console.log("Váltás speciális karakterekre: " + !specialCharsVisible);
        specialCharsVisible = !specialCharsVisible;
    }

    // elect the character to display based on the status
    function getDisplayText(key) {
        if (key.displayText !== undefined) {
            return key.displayText;
        }

        if (shiftEnabled || capsLockEnabled) {
            return key.shiftText;
        }

        return key.text;
    }

    // Managing the key press
    function handleKeyPress(key) {
       // console.log("Billentyű lenyomva: " + key.text);

        if (key.specialKey) {
            if (key.text === "⌫") {
                backspace();
            } else if (key.text === "↵") {
                handleEnter();
            } else if (key.text === "⇧") {
                toggleShift();
            } else if (key.text === "Caps") {
                toggleCapsLock();
            } else if (key.text === "123") {
               // console.log("123 gomb megnyomva, váltás speciális karakterekre");
                toggleSpecialChars();
            } else if (key.text === "ABC") {
               // console.log("ABC gomb megnyomva, visszaváltás normál billentyűzetre");
                toggleSpecialChars();
            } else if (key.text === "Hide") {
                hide();
            } else if (key.text === "Space") {
                addTextToInput(" ");
            } else if (key.text === "⇥") {
                addTextToInput("\t");
            } else if (key.text === "@") {
                addTextToInput("@");
            } else if (key.text === "Lang") {
                // Change language
                switchToNextLanguage();
               // console.log("Nyelvváltás: " + currentLayout);
            }
        } else {
            addTextToInput(getDisplayText(key));
            if (shiftEnabled && !capsLockEnabled) {
                shiftEnabled = false;
            }
        }
    }

    // Background
    Rectangle {
        id: keyboardBackground
        anchors.fill: parent
        color: "#2c3e50"
        opacity: 0.95
        radius: 8 // Lekerekített sarkok
    }

    // Current language display
    Rectangle {
        id: languageIndicator
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 5
        width: 60
        height: 25
        color: "#34495e"
        radius: 4

        Text {
            anchors.centerIn: parent
            text: {
                if (currentLayout === "hu_HU") return "HU";
                else if (currentLayout === "en_US") return "EN";
                else if (currentLayout === "de_DE") return "DE";
                else return "?";
            }
            color: "white"
            font.pixelSize: 16
            font.bold: true
        }
    }

    // Keyboard contents
    Column {
        id: keyboardColumn
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        Repeater {
            id: rowRepeater
            model: specialCharsVisible ? specialCharsLayout : keyboardLayout

            Row {
                id: keyRow
                height: (keyboardColumn.height - keyboardColumn.spacing * 4) / 5
                width: keyboardColumn.width
                spacing: 5

                property var rowData: specialCharsVisible ? specialCharsLayout[index] : keyboardLayout[index]

                Repeater {
                    model: rowData

                    Rectangle {
                        id: keyRect
                        height: keyRow.height
                        width: {
                            // Calculate the total weight/size of the row
                            let totalSize = 0;
                            for (let i = 0; i < rowData.length; i++) {
                                totalSize += (rowData[i].size || 1);
                            }

                            // One unit width in relation to the total row size
                            let unitWidth = (keyRow.width - (rowData.length - 1) * keyRow.spacing) / totalSize;

                            // The width of a specific key based on its size
                            return unitWidth * (modelData.size || 1);
                        }

                        color: {
                            if (modelData.text === "Lang") {
                                return "#1abc9c"; // The turquoise language button
                            } else if (modelData.specialKey) {
                                return "#34495e";
                            } else {
                                return "#3498db";
                            }
                        }

                        border.color: "#2980b9"
                        border.width: 1
                        radius: 5

                        // Visual indication of Shift/CapsLock status
                        Rectangle {
                            visible: (modelData.text === "⇧" && shiftEnabled) ||
                                    (modelData.text === "Caps" && capsLockEnabled)
                            anchors.right: parent.right
                            anchors.top: parent.top
                            width: 10
                            height: 10
                            radius: 5
                            color: "red"
                            anchors.rightMargin: 2
                            anchors.topMargin: 2
                        }

                        Text {
                            anchors.centerIn: parent
                            text: {
                                if (modelData.text === "Space") {
                                    return "Space";
                                } else if (modelData.text === "Lang") {
                                    // Change the text of the language switcher button
                                    if (currentLayout === "hu_HU") return "HU";
                                    else if (currentLayout === "en_US") return "EN";
                                    else if (currentLayout === "de_DE") return "DE";
                                    else return "Lang";
                                } else if (modelData.displayText !== undefined) {
                                    return modelData.displayText;
                                } else if (shiftEnabled || capsLockEnabled) {
                                    return modelData.shiftText;
                                } else {
                                    return modelData.text;
                                }
                            }
                            font.pixelSize: modelData.specialKey ? 16 : 20
                            color: "white"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                parent.color = modelData.text === "Lang" ? "#16a085" : "#2980b9";
                            }
                            onReleased: {
                                if (modelData.text === "Lang") {
                                    parent.color = "#1abc9c";
                                } else {
                                    parent.color = modelData.specialKey ? "#34495e" : "#3498db";
                                }
                                handleKeyPress(modelData);
                            }
                        }
                    }
                }
            }
        }
    }
}
