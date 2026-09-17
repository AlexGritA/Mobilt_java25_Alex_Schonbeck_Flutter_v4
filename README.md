                                    Flutter v.4 - Report
                                       Alex Schönbeck
**About the app**
A simple demo app built in Flutter/Dart that works on both Android and web. The app has
two pages: a home page with an image and a button, and a profile page with three
interactive widgets (text field, switch, slider), plus an additional page for sensor data.

**Pages & navigation**
- Home — shows an image and a button that navigates to Profile.

- Profile — a text field for the name, a switch for dark mode, a slider for "satisfaction," and a 
button that navigates on to Sensor.

- Sensor — shows accelerometer data (X/Y/Z) on Android; on web, a message is shown instead stating 
that the sensor isn't available there.

- Navigation is handled with Flutter's Navigator.push() and MaterialPageRoute, which stacks each 
new page on top of the previous one — the same approach on both Android and web.

**Widgets**
The three interactive widgets are TextField, SwitchListTile, and Slider, all connected to a
Stateful widget (ProfilePage) so the UI updates immediately as the user interacts. The image
widget (Image.network) loads an image from an external URL.

**Custom app icon & favicon**
Generated using the flutter_launcher_icons package, which automatically creates all necessary icon
sizes for Android as well as a favicon for the web version, based on an image file I created myself.

**Difference between Android and web app**
The two versions share the same UI and codebase, but differ in one key area: sensor access. 
The accelerometer is only available on Android - the web version checks the platform via kIsWeb
and displays a clear message when the sensor isn't available, rather than failing or showing
broken data.

**Extra features**
1. Local data persistence — the name entered in the text field is saved using
   shared _preferences and loaded back when the Profile page opens, so it persists even after 
   the app is fully closed and restarted.

2. Sensor data in UI — the Sensor page uses the sensors
   _plus package to read live accelerometer X/Y/Z values on Android. Since browsers don't have 
   the same sensor access, the app checks the platform via kIsWeb and shows a clear message when
   the sensor isn't available.

**Signed release**
I generated my own keystore using keytool, linked it to the Android project's build.gradle.kts,
and built a signed APK (flutter build apk --release). The web version was built with flutter
build web and zipped. Both files are attached in GitHub Release v1.0.
   
**Structure**
The entire app is written in a single file (main.dart), with four widget classes: MyApp (root
widget), HomePage, ProfilePage, and SensorPage. HomePage is Stateless since its content
is static; ProfilePage and SensorPage are Stateful since they need to remember and update values 
(text field, switch, slider, sensor data).

**Challenges**
The main challenge was understanding the Stateless/Stateful widget split and the initState()/
setState() pattern for the first time, coming from Kotlin's Activity/Fragment lifecycle. 
Getting sensor behavior to differ correctly between Android and web (without crashing on web)
also required learning the kIsWeb platform check.