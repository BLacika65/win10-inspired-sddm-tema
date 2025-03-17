import QtQuick 2.8

Item {
    id: translator

 // Recognising the system language code
    property string languageCode: {
        var locale = Qt.locale().name;
        return locale.split("_")[0];
    }
 // Set fixed English language for test purposes
//property string languageCode: "en"  // Always English, regardless of the system setting


    // Loading a translation file
    property var translationFile: Loader {
        id: translationLoader
        source: languageCode + ".qml"

        onStatusChanged: {
            if (status === Loader.Error) {
                console.log("Nem sikerült betölteni: " + source);
                // If you fail, try English
                if (languageCode !== "en") {
                    source = "en.qml";
                }
            }
        }
    }

    // Default translations - these are used if the external file does not load
    property var defaultTranslations: {
        "password": "Password",
        "loginFailed": "Login failed. Please enter your password again.",
        "networkInfo": "System Information",
        "virtualKeyboard": "Virtual Keyboard",
        "powerSettings": "Power",
        "sleepButton": "Sleep",
        "sleepTooltip": "Put system to sleep mode",
        "hibernateButton": "Hibernate",
        "hibernateTooltip": "Put system to hibernate mode",
        "rebootButton": "Restart",
        "rebootTooltip": "Restart the system",
        "powerOffButton": "Shut Down",
        "powerOffTooltip": "Shut down the system completely",
        "sysBasicInfo": "System Basic Information",
        "operatingSystem": "Operating System:",
        "screenResolution": "Screen Resolution:",
        "dateTime": "Date/Time:",
        "localizationInfo": "Localization Information",
        "localization": "Localization:",
        "country": "Country:",
        "language": "Language:",
        "networkStatus": "Network Status",
        "networkAvailable": "Network Available:",
        "checking": "Checking...",
        "yes": "Yes",
        "no": "No"

    }

    // Translation method
    function tr(key) {
        // If the translation file is loaded, use it
        if (translationFile.status === Loader.Ready &&
            translationFile.item &&
            typeof translationFile.item.translations === "object" &&
            translationFile.item.translations[key]) {

            return translationFile.item.translations[key];
        }

        // Otherwise, we use the default translations
        return defaultTranslations[key] || key;
    }

    Component.onCompleted: {
        console.log("Translator betöltve, nyelv: " + languageCode);
        console.log("Fordítási fájl: " + translationFile.source);
        console.log("Fordítási fájl státusza: " +
                    (translationFile.status === Loader.Ready ? "READY" :
                     translationFile.status === Loader.Loading ? "LOADING" :
                     translationFile.status === Loader.Error ? "ERROR" : "UNKNOWN"));
    }
}
