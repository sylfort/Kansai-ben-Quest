// lib/screens/initial_screen.dart
import 'package:flutter/material.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Make stack children fill the screen
        children: <Widget>[
          // Background Image
          Image.asset(
            'assets/images/kansai-ben-quest.png', // Correct path to your image
            fit: BoxFit.cover, // Cover the entire screen
          ),
          // Centered Start Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the map screen (MyHomePage) and replace the
                // initial screen so the user can't go back to it.
                Navigator.pushReplacementNamed(context, '/map');
              },
              style: ElevatedButton.styleFrom(
                 // Optional: Add some styling to the button
                 // backgroundColor: Colors.deepPurple,
                 padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                 textStyle: const TextStyle(fontSize: 20)
              ),
              child: const Text('Start'),
            ),
          ),
        ],
      ),
    );
  }
}