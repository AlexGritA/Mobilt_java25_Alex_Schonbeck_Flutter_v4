import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://picsum.photos/200',
              height: 150,
            ),
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool darkMode = false;
  double satisfaction = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Your name'),
            ),
            const SizedBox(height: 20),
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
          ],
        ),
      ),
    );
  }
}