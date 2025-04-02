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
        fit: StackFit.expand, // Make stack children fill the screen
        children: <Widget>[
          // Background Image
          Image.asset(
            'assets/images/kansai_ben_quest_title.png', // Correct path to your image
            fit: BoxFit.cover, // Cover the entire screen
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
                  // Use 'backgroundColor' for the button's background fill.
                  // Your original value was very transparent (alpha 74).
                  // Let's make it more opaque or solid for visibility.
                  backgroundColor: const Color.fromRGBO(
                    222,
                    143,
                    25,
                    1.0,
                  ), // Opaque dark brown
                  // Use 'foregroundColor' for the color of the text and icons.
                  foregroundColor: const Color.fromRGBO(
                    42,
                    18,
                    1,
                    1.0,
                  ), // A contrasting light beige/gold color
                  // Padding remains the same
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),

                  // textStyle is mainly for font size, weight, etc.
                  // It's better *not* to set the color here for ElevatedButton.
                  textStyle: const TextStyle(
                    fontSize: 24,
                    // fontWeight: FontWeight.bold // You could add weight here
                  ),

                  // Optional: Add shape/elevation if desired
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  // elevation: 5,
                ),
                // --- END OF CORRECTION ---
                child: const Text('Start'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
