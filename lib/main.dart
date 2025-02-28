import 'package:flutter/material.dart';
import 'custom_hit_test_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/hyougo': (context) => const DestinationPage(title: 'Hyougo'),
        '/kyouto': (context) => const DestinationPage(title: 'Kyouto'),
        '/mie': (context) => const DestinationPage(title: 'Mie'),
        '/nara': (context) => const DestinationPage(title: 'Nara'),
        '/osaka': (context) => const DestinationPage(title: 'Osaka'),
        '/shiga': (context) => const DestinationPage(title: 'Shiga'),
        '/wakayama': (context) => const DestinationPage(title: 'Wakayama'),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  final List<Map<String, dynamic>> destinations = [
    {
      'image': 'assets/images/hyougo.png',
      'route': '/hyougo',
      'top': 90.0,
      'left': 115.0,
      // Define hit test rectangles (relative to the image's top-left)
      'hitTestRects': [
        const Rect.fromLTWH(0, 0, 275, 265), // Adjust these!  Example values.
        // Add more Rects if hyougo.png has multiple green areas
      ],
    },
    {
      'image': 'assets/images/wakayama.png',
      'route': '/wakayama',
      'top': 420.0,
      'left': 300.0,
      'hitTestRects': [
        const Rect.fromLTWH(0, 30, 180, 215), // Adjust!
      ],
    },
    {
      'image': 'assets/images/kyouto.png',
      'route': '/kyouto',
      'top': 60.0,
      'left': 260.0,
      'hitTestRects': [
        const Rect.fromLTWH(0, 0, 225, 250), // Adjust!
      ],
    },
    //  Mie is commented out in your code.
    // {
    //   'image': 'assets/images/mie.png',
    //   'route': '/mie',
    //   'top': 280.0,
    //   'left': 200.0,
    //   'hitTestRects': [
    //    const Rect.fromLTWH(0, 0, 200, 150), //Example
    //   ],
    // },
    {
      'image': 'assets/images/nara.png',
      'route': '/nara',
      'top': 325.0,
      'left': 390.0,
      'hitTestRects': [
        const Rect.fromLTWH(71, 0, 150, 220), // Adjust!
      ],
    },
    {
      'image': 'assets/images/shiga.png',
      'route': '/shiga',
      'top': 80.0,
      'left': 440.0,
      'hitTestRects': [
        const Rect.fromLTWH(82, 31, 208, 190), // Adjust!
      ],
    },
    {
      'image': 'assets/images/osaka.png',
      'route': '/osaka',
      'top': 269.0,
      'left': 342.0,
      'hitTestRects': [
        const Rect.fromLTWH(48, 7, 131, 190),
        const Rect.fromLTWH(0, 179, 114, 216), // Adjust!
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
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
                          // Use the custom widget
                          hitTestRects:
                              destination['hitTestRects']
                                  .cast<Rect>(), // Cast to List<Rect>
                          child: InkWell(
                            //You can remove the onTap here, and the click will be
                            // handled by CustomHitTestImage
                            onTap: () {
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

class DestinationPage extends StatelessWidget {
  const DestinationPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Welcome to $title!')),
    );
  }
}
