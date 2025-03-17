# Win10 SDDM Theme
A modern Windows 10 inspired login screen theme for SDDM *(Simple Desktop Display Manager)*
## Features
### Dual screen system
**Start screen:** minimal design with clock and date display
The time and date are automatically displayed in the format that corresponds to the regional settings of the operating system.

**Monitor icon on the right:** Opens a System Information panel.
Some basic information about the system and how the Internet network works.

**Full screen click sensitive,** switches to second screen on click.
**Second screen:** The login screen.

### Logging in users
Display of round user profile pictures.
Use default avatar image if profile picture is missing.

**Display up to 5 users at the same time:**
One is usually the main user in the middle.
Up to 4 additional users in the bottom left panel.
Click on any of the 4 users and the user swaps places with the user in the middle.
The user name is displayed below the image.
The 4 additional users have a smaller circular avatar with the user name on the right.

### Password management

Password input field is slightly transparent, turns white when in focus.
"Eye" icon at right end of field to temporarily toggle password visibility.
At the end of the password field is an arrow-shaped login button, but the enter key can also be used.
Unsuccessful login is indicated by a red text message.

### Icons in bottom right corner.

**Monitor icon:** System information panel, same as on the home screen

**Keyboard icon:** virtual keyboard
Built-in on-screen keyboard, English, German, Hungarian language assignment with changeable language settings.
To log in, click on the password field, then launch the virtual keyboard, enter the password and press enter to log in.
I couldn't access the virtual keyboard installed on my system, I would have had to install it first, that's why this custom keyboard was made.

**Power off button and menu:** For the menu, I tried to bring back the colours and icons that Q4OS uses in the Windows 10 theme.

**Supported functions:**

**Sleep:** (Optional: You need to edit the Main.qml file. If the function is available on the system, you just need to remove the "//" comment from the sddm.suspend(); line.)

**Hibernate:** (Optional: Edit the Main.qml file. If the function is available on the system, just remove the "//" comment from the sddm.hibernate(); line.

**Reboot:** reboots the system by default.

**Shutdown:** Shuts down the system by default.

### Dynamic wallpaper display
Change wallpaper after every successful login. Currently 7 images of *1920 px x 1080 px* are built-in, but can be freely extended. 
It is recommended to keep the image file size below 500Kb

### Inactivity screen switching.
Automatically returns to home screen after 35 seconds of inactivity.

### Localization
Multilingual interface with support for translations. Currently English and Hungarian language support.
Automatically retrieves the system language settings and if there is support for the language it will use it, in the absence of a language template English is the default language.

**Create a language file:** Make a copy of the en.qml file in the translations folder. Open it in a suitable editor like **"Notepad++"** or **"Kate"** etc...
Then rewrite the lines that look like this : *"virtualKeyboard": "Virtual Keyboard",*
For example, for French this way:  *"virtualKeyboard": "Clavier virtuel",*

### Important information
The theme is inspired by the Windows 10 login screen, but is built exclusively from royalty-free elements.
All wallpapers are free-use photos downloaded from Pexels. 

### Use
Copy to */usr/share/sddm/themes/*, create the language file you need and you're done.

### License
This project is licensed under GPL v2 v3, in accordance with the SDDM license.

I hope you will like this supe login interface.
