// QML-based, two-state Windows 10-like login screen with wallpaper switching
import QtQuick 2.8
import SddmComponents 2.0
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.2
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import "components"
import QtQuick.Window 2.2

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height

     // Loading a translation component
    Loader {
        id: translatorLoader
        source: "translations/Translator.qml"
        asynchronous: false
    }

    // PROPERTY DECLARATIONS
    property var translator: translatorLoader.item
    property bool secondScreen: false
    property bool isNetworkInfoVisible: false

    // Basic settings
    LayoutMirroring.enabled: Qt.locale().textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true
    TextConstants { id: textConstants }

    // System info panel
    Rectangle {
        id: networkInfoPanel
        width: 440
        height: 380
        color: "#2c2c2c"
        radius: 8
        visible: isNetworkInfoVisible
        z: 1000
        x: secondScreen ? (controlsContainer.x - width + 30) : (networkIconFirstScreen.x - width + 30)
        y: secondScreen ? (controlsContainer.y - height) : (networkIconFirstScreen.y - height)

        Loader {
            id: infoSysLoader
            anchors.fill: parent
            source: "components/infosys.qml"
        }
    }

    // Create a tooltip component
    Component {
        id: tooltipComponent
        Rectangle {
            property alias text: tooltipText.text
            visible: false
            color: "#E0555555"
            width: tooltipText.width + 20
            height: tooltipText.height + 10
            radius: 4
            border.width: 1
            border.color: "#80FFFFFF"

            Text {
                id: tooltipText
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 14
            }
        }
    }

    // Network icon for system information panel
    Rectangle {
        id: networkIconFirstScreen
        color: "#80000000"
        width: 40
        height: 40
        radius: 5
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 160
        anchors.bottomMargin: 30
        visible: true
        z: 1100

        Image {
            anchors.centerIn: parent
            width: 30
            height: 30
            source: "images/network.svg"
            fillMode: Image.PreserveAspectFit
        }

        property var tooltip: tooltipComponent.createObject(networkIconFirstScreen, {
            "text": translator ? translator.tr("networkInfo") : "System Information",
            "anchors.bottom": networkIconFirstScreen.top,
            "anchors.bottomMargin": 5,
            "anchors.horizontalCenter": networkIconFirstScreen.horizontalCenter
        })

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.tooltip.visible = true
            onExited: parent.tooltip.visible = false
            onClicked: {
                isNetworkInfoVisible = !isNetworkInfoVisible
                inactivityTimer.restart()
            }
        }
    }

    // Virtual keyboard management
    Loader {
        id: virtualKeyboardLoader
        source: Qt.resolvedUrl("components/VirtualKeyboard.qml")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: Math.min(Math.max(600, parent.width * 0.9), 800)
        height: parent.height * 0.3
        z: 1000

        onLoaded: {
            item.parent = root;
            if (item) {
                item.enterPressed.connect(function() {
                    if (password.text.length > 0 && loginButton.enabled) {
                        loginButton.enabled = false;
                        errorMsg.visible = false;
                        sddm.login(user.currentText, password.text, session.currentIndex);
                    }
                });
            }
        }
    }

    // Import wallpaper manager
    BackgroundManager {
        id: backgroundManager
    }

    // Background
    Image {
        id: wallpaper
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: backgroundManager.currentBackgroundSource
        cache: false
    }

    // Timer to automatically switch back from the second screen to the first
    Timer {
        id: inactivityTimer
        interval: 35000
        running: secondScreen
        onTriggered: {
            if (secondScreen) {
                secondScreen = false
                screenTransition.start()
            }
        }
    }

    // Global MouseArea to catch out-of-element clicks
    MouseArea {
        id: outsideClickCatcher
        anchors.fill: parent
        enabled: powerButton.menuOpen || isNetworkInfoVisible || (virtualKeyboardLoader.item && virtualKeyboardLoader.item.visible)
        z: 5020
        visible: powerButton.menuOpen || isNetworkInfoVisible || (virtualKeyboardLoader.item && virtualKeyboardLoader.item.visible)

        onPressed: {
            var clickPosInButton = mapToItem(powerButton, mouse.x, mouse.y)
            var inPowerButton = (clickPosInButton.x >= 0 && clickPosInButton.x <= powerButton.width &&
                            clickPosInButton.y >= 0 && clickPosInButton.y <= powerButton.height)

            var clickPosInMenu = mapToItem(powerMenu, mouse.x, mouse.y)
            var inPowerMenu = (clickPosInMenu.x >= 0 && clickPosInMenu.x <= powerMenu.width &&
                            clickPosInMenu.y >= 0 && clickPosInMenu.y <= powerMenu.height)

            var inVirtualKeyboard = false;
            if (virtualKeyboardLoader.item && virtualKeyboardLoader.item.visible) {
                var clickPosInKeyboard = mapToItem(virtualKeyboardLoader.item, mouse.x, mouse.y)
                inVirtualKeyboard = (clickPosInKeyboard.x >= 0 && clickPosInKeyboard.x <= virtualKeyboardLoader.item.width &&
                                clickPosInKeyboard.y >= 0 && clickPosInKeyboard.y <= virtualKeyboardLoader.item.height)
            }

            var inNetworkInfoPanel = false;
            if (isNetworkInfoVisible) {
                var clickPosInInfoPanel = mapToItem(networkInfoPanel, mouse.x, mouse.y)
                inNetworkInfoPanel = (clickPosInInfoPanel.x >= 0 && clickPosInInfoPanel.x <= networkInfoPanel.width &&
                                clickPosInInfoPanel.y >= 0 && clickPosInInfoPanel.y <= networkInfoPanel.height)
            }

            if (!inPowerButton && !inPowerMenu && powerButton.menuOpen) {
                powerButton.menuOpen = false
            }

            if (!inNetworkInfoPanel && isNetworkInfoVisible) {
                isNetworkInfoVisible = false
            }

            if (!inVirtualKeyboard && virtualKeyboardLoader.item && virtualKeyboardLoader.item.visible) {
                virtualKeyboardLoader.item.hide()
            }

            inactivityTimer.restart()
            mouse.accepted = (!inPowerButton && !inPowerMenu && !inVirtualKeyboard && !inNetworkInfoPanel)
        }
    }

    // Successful/failed login handling
    Connections {
        target: sddm
        onLoginSucceeded: backgroundManager.switchToNextBackground()
        onLoginFailed: {
            password.text = ""
            password.focus = true
            errorMsg.visible = true
            errorMsg.text = textConstants.loginFailed
            loginButton.enabled = true
        }
    }

    // Full screen click management on the first screen
    MouseArea {
        id: fullScreenClickArea
        anchors.fill: parent
        enabled: !secondScreen

        onClicked: {
            secondScreen = true
            screenTransition.start()
            inactivityTimer.restart()
        }
    }

    // Screen state transition animation
    ParallelAnimation {
        id: screenTransition
        PropertyAnimation { target: loginContainer; property: "opacity"; to: secondScreen ? 1 : 0; duration: 500; easing.type: Easing.InOutQuad }
        PropertyAnimation { target: clockContainer; property: "opacity"; to: secondScreen ? 0 : 1; duration: 500; easing.type: Easing.InOutQuad }
        PropertyAnimation { target: userListContainer; property: "opacity"; to: secondScreen ? 1 : 0; duration: 500; easing.type: Easing.InOutQuad }
        PropertyAnimation { target: controlsContainer; property: "opacity"; to: secondScreen ? 1 : 0; duration: 500; easing.type: Easing.InOutQuad }
    }

    //FIRST SCREEN ELEMENTS
    // Clock and date container (bottom left)
    Loader {
        id: clockContainer
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 40
        opacity: secondScreen ? 0 : 1

        Component.onCompleted: {
            var locale = Qt.locale().name;
            var clockQml = "";

            if (locale.indexOf("hu_") === 0 || locale === "hu") {
                clockQml = "components/Clock-hu.qml";
            } else if (locale.indexOf("en_GB") === 0) {
                clockQml = "components/Clock-uk.qml";
            } else if (locale.indexOf("en_US") === 0) {
                clockQml = "components/Clock-us.qml";
            } else if (locale.indexOf("en_") === 0) {
                clockQml = "components/Clock-uk.qml";
            } else if (locale.indexOf("de_") === 0 || locale.indexOf("fr_") === 0 ||
                      locale.indexOf("it_") === 0 || locale.indexOf("es_") === 0 ||
                      locale === "de" || locale === "fr" || locale === "it" || locale === "es") {
                clockQml = "components/Clock-eu.qml";
            } else {
                clockQml = "components/Clock-eu.qml";
            }

            source = clockQml;
        }
    }

     // SECOND SCREEN ELEMENTS
    // Central user login container
    Rectangle {
        id: loginContainer
        color: "transparent"
        width: 300
        height: 400
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -50
        opacity: secondScreen ? 1 : 0

        // Round avatar/profile picture
        Rectangle {
            id: avatarMask
            width: 180
            height: 180
            radius: 90
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
        }

        Rectangle {
            id: avatarBackground
            width: 180
            height: 180
            radius: 90
            color: "#e0e0e0"
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: avatarImage
                anchors.fill: parent
                source: userModel.count > 0 ? "/var/lib/AccountsService/icons/" + user.currentText : "images/default-avatar.svg"
                fillMode: Image.PreserveAspectCrop
                layer.enabled: true
                layer.effect: OpacityMask { maskSource: avatarMask }

                onStatusChanged: {
                    if (status == Image.Error) {
                        source = "images/default-avatar.svg"
                    }
                }
            }
        }

        // Fill in username and real name
        Text {
            id: userNameText
            anchors.top: avatarBackground.bottom
            anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 28
            font.bold: true
            color: "white"
            text: {
                if (typeof user !== 'undefined' && user.model) {
                    return user.model.data(user.model.index(user.currentIndex, 0), Qt.DisplayRole) || "";
                } else {
                    return "";
                }
            }
        }

        Text {
            id: realNameText
            anchors.top: userNameText.bottom
            anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 28
            font.bold: true
            color: "white"
            text: {
                if (typeof user !== 'undefined' && user.model) {
                    return user.model.data(user.model.index(user.currentIndex, 0), Qt.UserRole + 2) || "";
                } else {
                    return "";
                }
            }
            visible: text !== ""
        }

        // Password field
        Rectangle {
            id: passwordInputBackground
            anchors.top: realNameText.visible ? realNameText.bottom : userNameText.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            width: 250
            height: 40
            color: "#80000000"
            border.width: 1
            border.color: password.activeFocus ? "#3d94da" : "#80ffffff"
            visible: secondScreen

            TextField {
                id: password
                anchors.fill: parent
                anchors.margins: 1
                color: password.activeFocus ? "black" : "white"
                placeholderText: translator ? translator.tr("password") : "Password"
                placeholderTextColor: "#a0ffffff"
                echoMode: TextInput.Password
                passwordCharacter: "●"
                font.pixelSize: 24
                horizontalAlignment: TextInput.AlignLeft
                verticalAlignment: TextInput.AlignVCenter
                background: Rectangle {
                    color: password.activeFocus ? "white" : "transparent"
                    opacity: password.activeFocus ? 0.9 : 0.1
                    onActiveFocusChanged: {
                        if (activeFocus && virtualKeyboardLoader.item) {
                            virtualKeyboardLoader.item.show(password);
                            inactivityTimer.restart();
                        }
                    }
                }

                // Eye icon to the right of the password field
                Item {
                    id: passwordEyeButton
                    width: 24
                    height: 24
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    property bool pressed: false

                    Image {
                        id: eyeIcon
                        anchors.centerIn: parent
                        width: 24
                        height: 24
                        source: passwordEyeButton.pressed ? "images/eye.svg" : "images/eye-off.svg"
                        fillMode: Image.PreserveAspectFit
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onPressed: {
                            passwordEyeButton.pressed = true;
                            password.echoMode = TextInput.Normal;
                            inactivityTimer.restart();
                        }
                        onReleased: {
                            passwordEyeButton.pressed = false;
                            password.echoMode = TextInput.Password;
                            inactivityTimer.restart();
                        }
                        onExited: {
                            passwordEyeButton.pressed = false;
                            password.echoMode = TextInput.Password;
                            inactivityTimer.restart();
                        }
                    }
                }

                onAccepted: {
                    if (loginButton.enabled) {
                        loginButton.enabled = false
                        errorMsg.visible = false
                        sddm.login(user.currentText, password.text, session.currentIndex)
                    }
                }

                onTextChanged: { errorMsg.visible = false }

                onActiveFocusChanged: {
                    if (activeFocus) { inactivityTimer.restart() }
                }
            }

            // Login button (arrow)
            Rectangle {
                id: loginButton
                width: height
                height: parent.height
                anchors.left: parent.right
                anchors.leftMargin: 0
                color: "#80000000"
                border.width: 1
                border.color: "#80ffffff"
                property bool enabled: true

                Image {
                    anchors.centerIn: parent
                    width: parent.width * 0.6
                    height: parent.height * 0.6
                    source: "images/arrow-right.svg"
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (loginButton.enabled) {
                            loginButton.enabled = false
                            errorMsg.visible = false
                            sddm.login(user.currentText, password.text, session.currentIndex)
                        }
                    }
                }
            }
        }

       // Error message
        Text {
            id: errorMsg
            anchors.top: passwordInputBackground.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 14
            color: "red"
            text: translator ? translator.tr("loginFailed") : "Login failed. Please enter your password again."
            visible: false
        }
    }

    // User switch panel
    Rectangle {
        id: userSwitcherPanel
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 30
        anchors.bottomMargin: 30
        width: 250
        height: userBoxColumn.height
        color: "transparent"
        visible: secondScreen === true

        property var userIndexes: {
            if (typeof user === 'undefined' || !user.model)
                return [];

            var currentIdx = user.currentIndex;
            var totalUsers = user.model.count;
            var indexes = [];

            for (var i = 0; i < totalUsers; i++) {
                if (i !== currentIdx) {
                    indexes.push(i);
                }
            }

            return indexes;
        }

        Column {
            id: userBoxColumn
            width: parent.width
            spacing: 10

            Repeater {
                model: userSwitcherPanel.userIndexes.length

                Rectangle {
                    width: 250
                    height: 80
                    color: "#80000000"
                    radius: 5
                    visible: index < userSwitcherPanel.userIndexes.length

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (typeof user !== 'undefined') {
                                user.currentIndex = userSwitcherPanel.userIndexes[index];
                            }
                        }
                    }

                    Row {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Rectangle {
                            width: 60
                            height: 60
                            radius: 30
                            color: "#e0e0e0"

                            Image {
                                anchors.fill: parent
                                anchors.margins: 2
                                source: {
                                    if (typeof user !== 'undefined' && user.model && index < userSwitcherPanel.userIndexes.length) {
                                        var userIndex = userSwitcherPanel.userIndexes[index];
                                        var avatarPath = user.model.data(user.model.index(userIndex, 0), Qt.UserRole + 1);
                                        return avatarPath ? "/var/lib/AccountsService/icons/" + avatarPath : "images/default-avatar.svg";
                                    } else {
                                        return "images/default-avatar.svg";
                                    }
                                }
                                fillMode: Image.PreserveAspectCrop
                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: Rectangle {
                                        width: 60
                                        height: 60
                                        radius: 30
                                        visible: false
                                    }
                                }
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 80
                            spacing: 4

                            Text {
                                width: parent.width
                                color: "white"
                                font.pixelSize: 18
                                font.bold: true
                                elide: Text.ElideRight
                                text: {
                                    if (typeof user !== 'undefined' && user.model && index < userSwitcherPanel.userIndexes.length) {
                                        var userIndex = userSwitcherPanel.userIndexes[index];
                                        return user.model.data(user.model.index(userIndex, 0), Qt.DisplayRole) || "";
                                    } else {
                                        return "";
                                    }
                                }
                            }

                            Text {
                                width: parent.width
                                color: "#cccccc"
                                font.pixelSize: 18
                                font.bold: true
                                elide: Text.ElideRight
                                anchors.verticalCenter: parent.verticalCenter
                                text: {
                                    if (typeof user !== 'undefined' && user.model && index < userSwitcherPanel.userIndexes.length) {
                                        var userIndex = userSwitcherPanel.userIndexes[index];
                                        return user.model.data(user.model.index(userIndex, 0), Qt.UserRole + 2) || "";
                                    } else {
                                        return "";
                                    }
                                }
                                visible: text !== ""
                            }
                        }
                    }
                }
            }
        }

        Connections {
            target: user ? user.model : null
            function onRowsInserted() {
                userSwitcherPanel.userIndexes = Qt.binding(function() {
                    if (typeof user === 'undefined' || !user.model)
                        return [];

                    var currentIdx = user.currentIndex;
                    var totalUsers = user.model.count;
                    var indexes = [];

                    for (var i = 0; i < totalUsers; i++) {
                        if (i !== currentIdx) {
                            indexes.push(i);
                        }
                    }

                    return indexes;
                });
            }
        }
    }

   // Buttons container (bottom right)
    Rectangle {
        id: controlsContainer
        color: "transparent"
        width: 100
        height: 30
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 40
        anchors.bottomMargin: 40
        opacity: secondScreen ? 1 : 0

        Row {
            spacing: 20

            // Keyboard icon
            Rectangle {
                width: 40
                height: 40
                color: "#80000000"
                radius: 5

                Image {
                    anchors.centerIn: parent
                    width: 30
                    height: 30
                    source: "images/keyboard.svg"
                    fillMode: Image.PreserveAspectFit
                }

                property var tooltip: tooltipComponent.createObject(parent, {
                    "text": translator ? translator.tr("virtualKeyboard") : "Virtual Keyboard",
                    "anchors.bottom": parent.top,
                    "anchors.bottomMargin": 5,
                    "anchors.horizontalCenter": parent.horizontalCenter
                })

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: { parent.tooltip.visible = true }
                    onExited: { parent.tooltip.visible = false }
                    onClicked: {
                        if (virtualKeyboardLoader.item && virtualKeyboardLoader.item.visible) {
                            virtualKeyboardLoader.item.hide();
                        } else if (virtualKeyboardLoader.item) {
                            virtualKeyboardLoader.item.show(password.activeFocus ? password : null);
                        }
                    }
                }
            }

          // Power off icon and menu
Rectangle {
    id: powerButton
    width: 40
    height: 40
    color: "#80000000"
    radius: 5
    property bool menuOpen: false

    Image {
        anchors.centerIn: parent
        width: 30
        height: 30
        source: "images/power.svg"
        fillMode: Image.PreserveAspectFit
    }

    property var tooltip: tooltipComponent.createObject(powerButton, {
        "text": translator ? translator.tr("powerSettings") : "Master Switch",
        "anchors.bottom": powerButton.top,
        "anchors.bottomMargin": 5,
        "anchors.horizontalCenter": powerButton.horizontalCenter
    })

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            powerButton.menuOpen = !powerButton.menuOpen
            inactivityTimer.restart()
        }
        onEntered: { powerButton.tooltip.visible = true && !powerButton.menuOpen }
        onExited: { powerButton.tooltip.visible = false }
    }

    // Switch off menu
    Rectangle {
        id: powerMenu
        visible: powerButton.menuOpen
        width: 180
        height: childrenRect.height
        color: "#80000000"
        anchors.bottom: parent.top
        anchors.right: parent.right
        anchors.bottomMargin: 5
        z: 99

        MouseArea {
            anchors.fill: parent
            onClicked: { mouse.accepted = true }
            propagateComposedEvents: false
        }

        Column {
            spacing: 0
            width: parent.width

           // Power menu button generator function
            function createPowerButton(id, iconSource, buttonText, tooltipText, action) {
                return {
                    id: id,
                    iconSource: iconSource,
                    buttonText: buttonText,
                    tooltipText: tooltipText,
                    action: action
                };
            }

             // Defining the Power menu buttons
            property var buttons: [
                createPowerButton("sleepButton", "images/suspend_primary_new.svg",
                    translator ? translator.tr("sleepButton") : "Sleep",
                    translator ? translator.tr("sleepTooltip") : "Put the system to sleep",
                    function() {
                        powerButton.menuOpen = false;
                        inactivityTimer.restart();
                    }),
                createPowerButton("hibernateButton", "images/suspend_primary_one_new.svg",
                    translator ? translator.tr("hibernateButton") : "Hibernate",
                    translator ? translator.tr("hibernateTooltip") : "Hibernate the system",
                    function() {
                        powerButton.menuOpen = false;
                        inactivityTimer.restart();
                    }),
                createPowerButton("rebootButton", "images/restart_primary_new.svg",
                    translator ? translator.tr("rebootButton") : "Restart",
                    translator ? translator.tr("rebootTooltip") : "Restart the system",
                    function() {
                        powerButton.menuOpen = false;
                        sddm.reboot();
                        inactivityTimer.restart();
                    }),
                createPowerButton("powerOffButton", "images/shutdown_primary_new.svg",
                    translator ? translator.tr("powerOffButton") : "Shut down",
                    translator ? translator.tr("powerOffTooltip") : "Shut down the system",
                    function() {
                        powerButton.menuOpen = false;
                        sddm.powerOff();
                        inactivityTimer.restart();
                    })
            ]

            // Create Power menu buttons
            Repeater {
                model: parent.buttons
                delegate: Rectangle {
                    id: menuButton
                    width: powerMenu.width
                    height: 40
                    property bool isHovered: false
                    property bool isPressed: false
                    color: isPressed ? "#3d94da" : (isHovered ? "#373737" : "transparent")
                    border.width: isHovered && !isPressed ? 1 : 0
                    border.color: "#6d6d6d"

                    // Create a tooltip for the button
                    property var tooltip: tooltipComponent.createObject(menuButton, {
                        "text": modelData.tooltipText,
                        "anchors.right": menuButton.left,
                        "anchors.rightMargin": 5,
                        "anchors.verticalCenter": menuButton.verticalCenter
                    })

                    Rectangle {
                        id: buttonContent
                        anchors.fill: parent
                        color: "transparent"
                        transform: [
                            Scale {
                                xScale: menuButton.isPressed ? 0.90 : 1.0
                                yScale: menuButton.isPressed ? 0.90 : 1.0
                                origin.x: buttonContent.width / 2
                                origin.y: buttonContent.height / 2
                                Behavior on xScale { NumberAnimation { duration: 80 } }
                                Behavior on yScale { NumberAnimation { duration: 80 } }
                            },
                            Translate {
                                x: menuButton.isPressed ? 5 : 0
                                y: menuButton.isPressed ? 0 : 0
                                Behavior on x { NumberAnimation { duration: 80 } }
                                Behavior on y { NumberAnimation { duration: 80 } }
                            }
                        ]

                        Row {
                            anchors.fill: parent
                            anchors.margins: 5
                            spacing: 10

                            Image {
                                width: 30
                                height: 30
                                anchors.verticalCenter: parent.verticalCenter
                                source: modelData.iconSource
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                color: "white"
                                text: modelData.buttonText
                                font.pixelSize: 16
                            }
                        }
                    }

                    MouseArea {
                        id: buttonArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            menuButton.isHovered = true;
                            menuButton.tooltip.visible = true;
                        }
                        onExited: {
                            menuButton.isHovered = false;
                            menuButton.isPressed = false;
                            menuButton.tooltip.visible = false;
                        }
                        onPressed: { menuButton.isPressed = true }
                        onReleased: { menuButton.isPressed = false }
                        onClicked: {
                            // Index-based operation for all 4 buttons:
                            if (index === 0) {  // sleepButton
                                powerButton.menuOpen = false;
                                // sddm.suspend();    // Sleep function, to use it delete the comment "//" before "sddm.suspend();".
                                inactivityTimer.restart();
                            }
                            else if (index === 1) {  // hibernateButton
                                powerButton.menuOpen = false;
                                // sddm.hibernate();  // Hibernate function, to use it delete the comment "//" before "sddm.hibernate();".
                                inactivityTimer.restart();
                            }
                                    else if (index === 2) {  // rebootButton
                                        powerButton.menuOpen = false;
                                        sddm.reboot();
                                        inactivityTimer.restart();
                                    }
                                    else if (index === 3) {  // powerOffButton
                                        powerButton.menuOpen = false;
                                        sddm.powerOff();
                                        inactivityTimer.restart();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

    // ComboBox for selecting users
    ComboBox {
        id: user
        visible: false
        model: userModel
        textRole: "name"
        currentIndex: userModel.lastIndex
    }

    // ComboBox for session selection
    ComboBox {
        id: session
        visible: false
        model: sessionModel
        textRole: "name"
        currentIndex: sessionModel.lastIndex
    }
}
