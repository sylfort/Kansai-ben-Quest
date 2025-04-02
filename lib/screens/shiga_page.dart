// lib/screens/shiga_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/kansai_word.dart'; // Adjust path if your model is elsewhere

// --- Theme Colors (Define centrally or repeat here) ---
const Color kPrimaryBackgroundColor = Color(0xFFF2D7A9);
const Color kPrimaryTextColor = Color(0xFF2A1201);
const Color kAccentColorOrange = Color(0xFFE55934);
const Color kAccentColorGold = Color(0xFFF5B700);
const Color kCardBackgroundColor = Color(0xFFFAEBCD);
const Color kSubtleTextColor = Color(0xFF6E5B44);
// --- End Theme Colors ---

class ShigaPage extends StatefulWidget {
  const ShigaPage({super.key});

  @override
  State<ShigaPage> createState() => _ShigaPageState();
}

class _ShigaPageState extends State<ShigaPage> {
  late Future<List<KansaiWord>> _shigaWordsFuture;

  @override
  void initState() {
    super.initState();
    _shigaWordsFuture = _loadShigaWords();
  }

  // Function to load, decode, and map Shiga words JSON data
  Future<List<KansaiWord>> _loadShigaWords() async {
    try {
      // Load the specific JSON string for Shiga from assets
      final String jsonString =
          await rootBundle.loadString('assets/data/shiga_words.json');

      // Decode the JSON string into a List<dynamic>
      final List<dynamic> jsonList = json.decode(jsonString);

      // Map the dynamic list to a List<KansaiWord>
      final List<KansaiWord> shigaWords =
          jsonList.map((jsonItem) => KansaiWord.fromJson(jsonItem)).toList();

      return shigaWords;
    } catch (e) {
      // Handle errors (e.g., file not found, JSON parsing error)
      debugPrint('Error loading or parsing shiga_words.json: $e');
      // Return an error to be caught by FutureBuilder
      return Future.error('Failed to load Shiga words.');
    }
  }

  // Function to show the details in a bottom sheet
  void _showWordDetails(BuildContext context, KansaiWord word) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCardBackgroundColor, // Use card color for modal
      shape: const RoundedRectangleBorder( // Add rounded corners
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true, // Allows modal to take more height if needed
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          // Make content scrollable if it overflows
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Take only needed vertical space
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDetailRow("Kansai-ben:", word.kansaiExpression, isHighlight: true),
                const SizedBox(height: 10),
                _buildDetailRow("Standard:", word.standardJapanese),
                const SizedBox(height: 10),
                _buildDetailRow("English:", word.englishTranslation),
                const Divider(height: 30, thickness: 1, color: kSubtleTextColor), // Separator
                _buildDetailRow("Example:", word.exampleSentence, isExample: true),
                const SizedBox(height: 8),
                _buildDetailRow("(", word.standardJapaneseSentence, isExample: true, isSubtle: true),
                 const SizedBox(height: 8),
                _buildDetailRow("(", word.englishSentence + ")", isExample: true, isSubtle: true),
                const SizedBox(height: 20), // Spacing at bottom
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget for styling detail rows in the bottom sheet
  Widget _buildDetailRow(String label, String value, {bool isHighlight = false, bool isExample = false, bool isSubtle = false}) {
    // Using RichText allows different styles within the same text block
    return RichText(
      text: TextSpan(
        // Default style for this text block
        style: TextStyle(
          fontSize: isExample ? 16 : 18,
          color: isSubtle ? kSubtleTextColor : kPrimaryTextColor,
           fontFamily: 'YourCustomFont', // Replace if using a custom font
           height: 1.4 // Slightly increase line height for readability
        ),
        children: <TextSpan>[
          TextSpan(
            text: '$label ',
            style: TextStyle(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? kAccentColorOrange : (isSubtle ? kSubtleTextColor : kPrimaryTextColor),
            ),
          ),
          TextSpan(
            text: value,
            // Apply specific styles to the value part
            style: TextStyle(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              fontSize: isHighlight ? 22 : (isExample ? 16 : 18),
              color: isHighlight ? kAccentColorGold : (isSubtle ? kSubtleTextColor : kPrimaryTextColor),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryBackgroundColor, // Set background color
      appBar: AppBar(
        title: const Text(
          'Shiga - 滋賀県', // Updated title for Shiga
          style: TextStyle(
            color: kPrimaryTextColor, // Dark text on AppBar
            fontWeight: FontWeight.bold,
             // fontFamily: 'YourCustomFont', // TODO: Add a custom font
          ),
        ),
        backgroundColor: kPrimaryBackgroundColor, // Match scaffold background
        elevation: 0, // No shadow for a flatter look
        iconTheme: const IconThemeData(color: kPrimaryTextColor), // Back button color
      ),
      body: FutureBuilder<List<KansaiWord>>(
        future: _shigaWordsFuture, // Use the future for Shiga words
        builder: (context, snapshot) {
          // ----- Handle Loading State -----
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: kAccentColorOrange));
          }

          // ----- Handle Error State -----
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding( // Add padding for error message
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  snapshot.hasError
                      ? 'Error loading words.\nPlease check your connection or the data file (shiga_words.json).' // Updated error message
                      : 'No words found for Shiga in the dictionary.', // Updated message
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: kPrimaryTextColor, fontSize: 16, height: 1.5),
                ),
              ),
            );
          }

          // ----- Handle Data Loaded State -----
          final shigaWords = snapshot.data!; // Assign data to specific variable

          // Use SingleChildScrollView for vertical scrolling if table is long
          // Use SingleChildScrollView with horizontal direction for horizontal scrolling
          return SingleChildScrollView( // Vertical scroll for the whole table area
            child: SingleChildScrollView( // Horizontal scroll for the table content
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0), // Padding around the table
                child: DataTable(
                  showCheckboxColumn: false, // Hide checkboxes
                  headingRowColor: MaterialStateColor.resolveWith( // Style header row
                      (states) => kAccentColorGold.withOpacity(0.3)),
                  dataRowColor: MaterialStateColor.resolveWith( // Style data rows
                    (states) {
                      return kCardBackgroundColor.withOpacity(0.6);
                    }),
                   dataRowMinHeight: 48.0,
                   dataRowMaxHeight: 60.0,
                   headingRowHeight: 56.0,
                  columnSpacing: 25.0, // Spacing between columns
                  columns: const <DataColumn>[ // Define table columns (Headers)
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Kansai-ben',
                          style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryTextColor, fontSize: 16),
                           overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataColumn(
                       label: Expanded(
                        child: Text(
                          'Standard',
                          style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryTextColor, fontSize: 16),
                           overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'English',
                          style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryTextColor, fontSize: 16),
                           overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  rows: shigaWords.map((word) { // Map the list of words to DataRows
                    // Build each row
                    return DataRow(
                      // Make the row tappable to show details
                      onSelectChanged: (bool? selected) {
                          _showWordDetails(context, word); // Call the detail function on tap
                      },
                      cells: <DataCell>[ // Define cells for the row
                        DataCell(Text(word.kansaiExpression, style: const TextStyle(color: kPrimaryTextColor, fontSize: 15))),
                        DataCell(Text(word.standardJapanese, style: const TextStyle(color: kPrimaryTextColor, fontSize: 15))),
                        DataCell(Text(word.englishTranslation, style: const TextStyle(color: kPrimaryTextColor, fontSize: 15))),
                      ],
                    );
                  }).toList(), // Convert the mapped iterable to a List
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}