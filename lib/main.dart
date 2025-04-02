import 'package:flutter/material.dart';

// --- Local Imports ---
import 'custom_hit_test_image.dart';
import 'screens/initial_screen.dart';
// ---> ADD THIS IMPORT for your new Hyougo Page <---
import 'screens/hyougo_page.dart';
import 'screens/osaka_page.dart';
import 'screens/kyouto_page.dart';
import 'screens/nara_page.dart';
import 'screens/shiga_page.dart';
import 'screens/wakayama_page.dart';
import 'screens/mie_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kansai Ben Quest',
      theme: ThemeData(
        // Consider defining your theme colors here for app-wide consistency
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE55934), // Example: Use orange as seed
          primary: const Color(0xFFE55934), // Orange
          secondary: const Color(0xFFF5B700), // Gold
          background: const Color(0xFFF2D7A9), // Beige background
          onBackground: const Color(0xFF2A1201), // Dark text on background
          surface: const Color(0xFFFAEBCD), // Card background
          onSurface: const Color(0xFF2A1201), // Dark text on cards
        ),
        useMaterial3: true,
        // You can also define AppBarTheme, TextTheme etc. here
      ),
      home: const InitialScreen(), // Start with the initial screen
      routes: {
        // The route to the map screen
        '/map': (context) => MyHomePage(title: 'Kansai Region Map'),

        '/hyougo': (context) => const HyougoPage(),
        '/osaka': (context) => const OsakaPage(),
        '/kyouto': (context) => const KyotoPage(),
        '/nara': (context) => const NaraPage(),
        '/shiga': (context) => const ShigaPage(),
        '/wakayama': (context) => const WakayamaPage(),
        '/mie': (context) => const MiePage(),
      },
    );
  }
}

// --- MyHomePage (Map Screen) remains the same ---
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final List<Map<String, dynamic>> destinations = [
     {
      'image': 'assets/images/hyougo.png',
      'route': '/hyougo', // This route name now correctly points to HyougoPage
      'top': 90.0,
      'left': 115.0,
      'hitTestRects': [
        const Rect.fromLTWH(0, 0, 275, 265),
      ],
    },
    {
      'image': 'assets/images/wakayama.png',
      'route': '/wakayama',
      'top': 420.0,
      'left': 300.0,
      'hitTestRects': [
        const Rect.fromLTWH(0, 30, 180, 215),
      ],
    },
    {
      'image': 'assets/images/kyouto.png',
      'route': '/kyouto',
      'top': 60.0,
      'left': 260.0,
      'hitTestRects': [
        const Rect.fromLTWH(0, 0, 225, 250),
      ],
    },
    // Mie commented out
    {
      'image': 'assets/images/nara.png',
      'route': '/nara',
      'top': 325.0,
      'left': 390.0,
      'hitTestRects': [
        const Rect.fromLTWH(71, 0, 150, 220),
      ],
    },
    {
      'image': 'assets/images/shiga.png',
      'route': '/shiga',
      'top': 80.0,
      'left': 440.0,
      'hitTestRects': [
        const Rect.fromLTWH(82, 31, 208, 190),
      ],
    },
    {
      'image': 'assets/images/osaka.png',
      'route': '/osaka',
      'top': 269.0,
      'left': 342.0,
      'hitTestRects': [
        const Rect.fromLTWH(48, 7, 131, 190),
        const Rect.fromLTWH(0, 179, 114, 216),
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar theme will now be influenced by ThemeData
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary, // You can remove this if using AppBarTheme
        title: Text(title),
      ),
      body: Center( // Keep Center if you want the map centered on larger screens
        child: SingleChildScrollView(
          child: SizedBox(
            height: 700,
            width: 1000,
            child: ClipRect(
              child: Stack(
                children:
                    destinations.map((destination) {
                      return Positioned(
                        top: destination['top'],
                        left: destination['left'],
                        child: CustomHitTestImage(
                          hitTestRects: destination['hitTestRects'].cast<Rect>(),
                          child: InkWell(
                            onTap: () {
                              // This pushNamed will now correctly go to HyougoPage
                              // when the hyougo image is tapped
                              Navigator.pushNamed(
                                context,
                                destination['route']!,
                              );
                            },
                            child: Image.asset(
                              destination['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- DestinationPage (Generic Placeholder - Keep if other routes use it) ---
class DestinationPage extends StatelessWidget {
  const DestinationPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Welcome to $title! (Placeholder)')), // Added Placeholder text
    );
  }
}