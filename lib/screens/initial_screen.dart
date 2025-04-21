// lib/screens/initial_screen.dart
import 'package:flutter/material.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen height for potential relative positioning (optional)
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background Image
          Image.asset(
            'assets/images/kansai_ben_quest_title.png',
            fit: BoxFit.contain,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 190.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/map');
                },
                // --- CORRECTED STYLE ---
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(
                    222,
                    143,
                    25,
                    1.0,
                  ), // Opaque dark brown

                  foregroundColor: const Color.fromRGBO(
                    42,
                    18,
                    1,
                    1.0,
                  ),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),

                  textStyle: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                child: const Text('Start'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
