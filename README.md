# Setup

The Appiko setup app is used to configure and get information about Sense devices by Appiko. 
The app also has a feature to define and save multiple configurations prior connecting to the Sense device, hereon referred as a profile. A profile can then be written to sense device upon connection over Bluetooth.

Other features include naming, seeing device information, monitoring battery information, device logs of the Sense devices.

## Getting Started

### 1️. [Install Flutter](https://flutter.dev/docs/get-started/install)

### 2️. Clone the repository

### 3️. Open the project in VS Code / Android Studio

### 4️. Run
`flutter run -d device-name`

---

### Generating Docs
`dartdoc`

Open docs on local server

`dhttpd --path doc/api`

> For help getting started with Flutter, see the online
[online documentation](https://flutter.dev/docs).


## Project Structure Overview

Most of the project is under the `/lib/` folder.

Important files and folders under UI

- The `/lib/ui/` folder holds all the UI related Info.
- The `/lib/core` folder has all the Classes and Services.
- The `/lib/main.dart` file is the root file, from where the application is started
- The `/lib/locators.dart` file is a file which has an instance of [get_it](https://pub.dev/packages/get_it) plugin. It helps in creating and getting instances of singleton or factory classes.

---

The structure is made in such a way that each new Sense device addition will need a set of new device-specific classes, UI screens, and algorithms to be created.

---
### UI

Each screen of the UI is made with combining

- Widgets: Basic UI components directly taken from flutter, with minor changes.
- Compound Widgets: Compound widgets are a set of widgets combined to make a larger part of the UI.
- Pages: Pages represent the whole screen of the UI and are developed using the compound and basic widgets.

All Sense device-specific UI will go under 

`/lib/core/ui/devices/<device-name>/`

UI dependent on the firmware version will go deep another level

`/lib/core/ui/devices/<device-name>/<firmware-version>/`

Initially, we are using

**`/lib/core/ui/devices/<device-name>/1.0/`**

All profile-specific UI will go under

`/lib/core/ui/devices/<device-name>/<firmware-version>/profiles/`

All Configuration settings UI will be under

`/lib/core/ui/devices/<device-name>/<firmware-version>/settings/`

Any other Sense device-specific screens will just go under

`/lib/core/ui/devices/<device-name>/<firmware-version>/`

---
### Structure (Class/Model)

A structure is a class which defines how the data is structured. It will also have algorithms to pack and unpack the data to and fro the Sense device or a profile.

There is also a MetaStructure which holds the Meta Information relating to the Structure. 
Ex. Which of the settings have advanced options on while setting it up.

Each Sense device's structure will go under

`/lib/core/models/devices/<device-name>/<firmware-version>/`

---
### Service

Every Sense device added, also needs to have a service file under `/lib/core/services/` which will Initialize the structure, Add / Modify / Reset a setting and other device-specific functions.

---

### Other things

- Basic / Compound Widgets will go under 

`/lib/ui/widgets`

- Device Independent pages will go under 

`/lib/ui/views`

- Models which interacts with the UI goes under

`/lib/core/view_models`

- Other services go under

`/lib/core/services`