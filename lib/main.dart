import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

import 'custom_hit_test_image.dart';
import 'screens/initial_screen.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE55934),
          primary: const Color(0xFFE55934),
          secondary: const Color(0xFFF5B700),
          background: const Color(0xFFF2D7A9),
          onBackground: const Color(0xFF2A1201),
          surface: const Color(0xFFFAEBCD),
          onSurface: const Color(0xFF2A1201),
        ),
        useMaterial3: true,
      ),
      home: const InitialScreen(),
      routes: {
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

// --- MyHomePage (Map Screen)---
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // State variable to track the route of the currently selected prefecture
  String? _selectedPrefectureRoute;
  String _selectedPrefectureName = ''; // State variable for the displayed name

  // charTopOffset, charLeftOffset are relative to the PREFECTURE image's top-left.

  final List<Map<String, dynamic>> destinations = [
    {
      'name': 'Hyogo', // Display name
      'image': 'assets/images/hyougo.png',
      'charImage': 'assets/images/hyougo_char.png', 
      'route': '/hyougo',
      'top': 90.0, 'left': 115.0,
      'hitTestRects': [ const Rect.fromLTWH(0, 0, 275, 265), ],
      'charTopOffset': 170.0,
      'charLeftOffset': 128.0,
      'charWidth': 60.0,
      'charHeight': 70.0,
    },
    {
      'name': 'Wakayama',
      'image': 'assets/images/wakayama.png',
      'charImage': 'assets/images/wakayama_char.png',
      'route': '/wakayama',
      'top': 420.0, 'left': 300.0,
      'hitTestRects': [ const Rect.fromLTWH(0, 30, 180, 215), ],
      'charTopOffset': 120.0, 'charLeftOffset': 110.0, // ADJUST
      'charWidth': 55.0, 'charHeight': 65.0, // ADJUST
    },
     {
      'name': 'Kyoto',
      'image': 'assets/images/kyouto.png',
      'charImage': 'assets/images/kyouto_char.png',
      'route': '/kyouto',
      'top': 60.0, 'left': 260.0,
      'hitTestRects': [ const Rect.fromLTWH(0, 0, 225, 250), ],
      'charTopOffset': 125.0, 'charLeftOffset': 130.0, // ADJUST
      'charWidth': 60.0, 'charHeight': 70.0, // ADJUST
    },
     {
      'name': 'Nara',
      'image': 'assets/images/nara.png',
      'charImage': 'assets/images/nara_char.png',
      'route': '/nara',
      'top': 325.0, 'left': 390.0,
      'hitTestRects': [ const Rect.fromLTWH(71, 0, 150, 220), ],
      'charTopOffset': 110.0, 'charLeftOffset': 125.0, 
      'charWidth': 50.0, 'charHeight': 65.0, 
    },
     {
      'name': 'Shiga',
      'image': 'assets/images/shiga.png',
      'charImage': 'assets/images/shiga_char.png',
      'route': '/shiga',
      'top': 80.0, 'left': 440.0,
      'hitTestRects': [ const Rect.fromLTWH(82, 31, 208, 190), ],
      'charTopOffset': 115.0, 'charLeftOffset': 135.0, 
      'charWidth': 55.0, 'charHeight': 65.0, 
    },
     {
      'name': '0saka',
      'image': 'assets/images/osaka.png',
      'charImage': 'assets/images/osaka_char.png',
      'route': '/osaka',
      'top': 269.0, 'left': 342.0,
      'hitTestRects': [ const Rect.fromLTWH(48, 7, 131, 190), const Rect.fromLTWH(0, 179, 114, 216), ],
      'charTopOffset': 100.0, 'charLeftOffset': 80.0,
      'charWidth': 60.0, 'charHeight': 70.0,
    },
    {
      'name': 'Mie',
      'image': 'assets/images/mie.png',
      'charImage': 'assets/images/mie_char.png',
      'route': '/mie',
      'top': 200.0, 'left': 460.0, // Example position
      'hitTestRects': [ const Rect.fromLTWH(0, 0, 200, 230), ],
      'charTopOffset': 175.0, 'charLeftOffset': 160.0,
      'charWidth': 55.0, 'charHeight': 65.0,
    },
  ];

  // Function to handle the tap event
  void _handlePrefectureTap(Map<String, dynamic> destination) {
    final String currentRoute = destination['route']!;
    final String currentName = destination['name']!;

    setState(() {
      if (_selectedPrefectureRoute == currentRoute) {
        // Second tap on the same prefecture: Navigate
        Navigator.pushNamed(context, currentRoute);
      } else {
        // First tap or tap on a different prefecture: Select it
        _selectedPrefectureRoute = currentRoute;
        _selectedPrefectureName = currentName;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    const Duration animationDuration = Duration(milliseconds: 200);

    return Scaffold(
      appBar: AppBar(
        // Use widget.title to access title from StatefulWidget
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 700,
            width: 1000,
            child: ClipRect(
              child: Stack(
                children: [
                  // --- Prefecture Images (Background Layer) ---
                  ...destinations.map((destination) {
                    return Positioned(
                      top: destination['top'],
                      left: destination['left'],
                      child: CustomHitTestImage(
                        hitTestRects: destination['hitTestRects'].cast<Rect>(),
                        child: InkWell(
                          onTap: () => _handlePrefectureTap(destination),

                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Image.asset(
                            destination['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  // --- Character Images (Foreground Layer) ---
                  ...destinations.map((destination) {
                    bool isSelected = _selectedPrefectureRoute == destination['route'];
                    double scale = isSelected ? 1.3 : 1.0; // Scale factor
                    double charWidth = destination['charWidth'];
                    double charHeight = destination['charHeight'];

                    // Calculate top-left corner for the character image to center it
                    // at the offset point relative to the prefecture image's top-left
                    double charTop = destination['top'] + destination['charTopOffset'] - (charHeight / 2);
                    double charLeft = destination['left'] + destination['charLeftOffset'] - (charWidth / 2);

                    return Positioned(
                      top: charTop,
                      left: charLeft,
                      width: charWidth, // Base width
                      height: charHeight, // Base height
                      child: IgnorePointer( // Characters shouldn't block prefecture taps
                        child: AnimatedScale(
                          scale: scale,
                          duration: animationDuration,
                          curve: Curves.easeInOut,
                          child: Image.asset(
                            destination['charImage']!,
                            width: charWidth,
                            height: charHeight,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  // --- Selected Prefecture Name Display (Top Center) ---
                  Positioned(
                    top: 20.0,
                    left: 0,
                    right: 0,
                    child: Center( // Center the opacity widget horizontally
                      child: AnimatedOpacity(
                        opacity: _selectedPrefectureName.isNotEmpty ? 1.0 : 0.0,
                        duration: animationDuration,
                        curve: Curves.easeInOut,
                        child: IgnorePointer( // Name display shouldn't block taps
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface.withOpacity(0.85), // Semi-transparent card color
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            ),
                            child: Text(
                              _selectedPrefectureName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface, // Text color on card
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Optional: Keep DestinationPage only if you might use it for other placeholders
// class DestinationPage extends StatelessWidget { ... }