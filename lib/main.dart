import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sensors_plus/sensors_plus.dart';

// Entry point of the whole app — Flutter's equivalent of onCreate/main()
void main() {
  runApp(const MyApp());
}

// Root widget of the app. Stateless because it never changes itself —
// it just sets up the theme/title and points to the first screen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter v4 Demo',
      home: const HomePage(),
    );
  }
}

// First screen the user sees. Stateless because nothing on this
// screen changes on its own — it's just a static image, text and button.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('https://picsum.photos/200', height: 150),
            const SizedBox(height: 20),
            const Text('Welcome to the demo app', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: const Text('Go to Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

// Profile screen. StatefulWidget because it contains widgets whose
// values change while the user interacts with them (text field,
// switch, slider) — a Stateless widget couldn't do that.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// The actual mutable data and UI-building logic for ProfilePage live
// here, in a separate State class. Flutter keeps this same State
// object alive across rebuilds, which is why our values persist
// while the user interacts with the screen.
class _ProfilePageState extends State<ProfilePage> {
  bool darkMode = false;
  double satisfaction = 5.0;
  final TextEditingController nameController = TextEditingController();

  // Runs once when this screen is first created —
  // we use it to load any previously saved name.
  @override
  void initState() {
    super.initState();
    _loadName();
  }

  // Reading from SharedPreferences is not instant,
  // so this function waits for it to finish before updating the screen.
  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? '';
    });
  }

  // Saves the name every time the text field changes, so the value
  // is persisted immediately rather than only on some "save" button.
  Future<void> _saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Interactive widget #1: TextField, tied to a controller
            // so we can read/write its value from code
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Your name'),
              onChanged: (value) {
                _saveName(value);
              },
            ),
            const SizedBox(height: 20),
            // Interactive widget #2: Switch. setState() tells Flutter
            // "something changed, rebuild the UI" every time it's toggled
            SwitchListTile(
              title: const Text('Dark mode'),
              value: darkMode,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Text('Satisfaction: ${satisfaction.round()}'),
            // Interactive widget #3: Slider, same setState() pattern
            Slider(
              value: satisfaction,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  satisfaction = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SensorPage()),
                );
              },
              child: const Text('Go to Sensor'),
            ),
          ],
        ),
      ),
    );
  }
}

// Sensor screen — StatefulWidget because the X/Y/Z values change
// continuously as the accelerometer sends new readings.
class SensorPage extends StatefulWidget {
  const SensorPage({super.key});

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  double x = 0, y = 0, z = 0;

  @override
  void initState() {
    super.initState();
    // Accelerometer isn't available in browsers, so we only start
    // listening to sensor events on Android
    if (!kIsWeb) {
      accelerometerEventStream().listen((event) {
        setState(() {
          x = event.x;
          y = event.y;
          z = event.z;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sensor')),
      body: Center(
        // Same kIsWeb check here — shows a clear fallback message
        // on web instead of blank/broken sensor values
        child: kIsWeb
            ? const Text('Accelerometer not available on web',
            style: TextStyle(fontSize: 18))
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('X: ${x.toStringAsFixed(2)}'),
            Text('Y: ${y.toStringAsFixed(2)}'),
            Text('Z: ${z.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}