// lib/screens/hyougo_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // For loading JSON asset
import 'dart:convert'; // For decoding JSON

// Assuming your model is here:
import '../models/kansai_word.dart'; // Adjust path if needed

// --- Theme Colors (Inspired by Kansai-Ben Quest image) ---
const Color kPrimaryBackgroundColor = Color(0xFFF2D7A9);
const Color kPrimaryTextColor = Color(0xFF2A1201);
const Color kAccentColorOrange = Color(0xFFE55934);
const Color kAccentColorGold = Color(0xFFF5B700);
const Color kCardBackgroundColor = Color(0xFFFAEBCD);
const Color kSubtleTextColor = Color(0xFF6E5B44);
// --- End Theme Colors ---
class HyougoPage extends StatefulWidget {
  const HyougoPage({super.key});

  @override
  State<HyougoPage> createState() => _HyougoPageState();
}

class _HyougoPageState extends State<HyougoPage> {
  late Future<List<KansaiWord>> _hyogoWordsFuture;

  @override
  void initState() {
    super.initState();
    // ---> CHANGE: Call the simplified loading function <---
    _hyogoWordsFuture = _loadHyogoWords();
  }

  // ---> CHANGE: Simplified loading function for Hyougo <---
  Future<List<KansaiWord>> _loadHyogoWords() async {
    try {
      // ---> CHANGE: Load the specific Hyougo file <---
      final String jsonString =
          await rootBundle.loadString('assets/data/hyougo_words.json'); // Load specific file

      // Decode the JSON string into a List<dynamic>
      final List<dynamic> jsonList = json.decode(jsonString);

      // ---> CHANGE: Directly map, NO filtering needed anymore <---
      final List<KansaiWord> hyogoWords =
          jsonList.map((jsonItem) => KansaiWord.fromJson(jsonItem)).toList();

      return hyogoWords; // Return the already filtered list
    } catch (e) {
      debugPrint('Error loading or parsing hyougo_words.json: $e');
      return Future.error('Failed to load Hyougo words.');
    }
  }

  // ... (_showWordDetails, _buildDetailRow, and build methods remain the same) ...
  // The FutureBuilder will now use the future returned by _loadHyogoWords

  // --- Make sure the rest of the file (bottom sheet, build method with FutureBuilder, DataTable) ---
  // --- remains the same as the previous version.                                             ---
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
          'Hyōgo - 兵庫県',
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
        future: _hyogoWordsFuture, // This now correctly points to _loadHyogoWords future
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
                      ? 'Error loading words.\nPlease check your connection or the data file (hyougo_words.json).' // Updated error message
                      : 'No words found for Hyougo in the dictionary.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: kPrimaryTextColor, fontSize: 16, height: 1.5),
                ),
              ),
            );
          }

          // ----- Handle Data Loaded State -----
          final hyogoWords = snapshot.data!;

          // Use SingleChildScrollView for vertical scrolling if table is long
          // Use SingleChildScrollView with horizontal direction for horizontal scrolling
          return SingleChildScrollView( // Vertical scroll for the whole table area
            child: SingleChildScrollView( // Horizontal scroll for the table content
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0), // Padding around the table
                child: DataTable(
                  showCheckboxColumn: false,
                  headingRowColor: MaterialStateColor.resolveWith( // Style header row
                      (states) => kAccentColorGold.withOpacity(0.3)), // Slightly more opaque header
                  dataRowColor: MaterialStateColor.resolveWith( // Alternate row colors slightly
                    (states) {
                      return kCardBackgroundColor.withOpacity(0.6); // Slightly more opaque rows
                    }),
                   dataRowMinHeight: 48.0,
                   dataRowMaxHeight: 60.0,
                   headingRowHeight: 56.0,
                  columnSpacing: 25.0, // Increased spacing between columns
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded( // Use Expanded to allow text wrapping if needed
                        child: Text(
                          'Kansai-ben',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: kPrimaryTextColor, fontSize: 16), // Slightly larger header font
                           overflow: TextOverflow.ellipsis, // Handle overflow
                        ),
                      ),
                    ),
                    DataColumn(
                       label: Expanded(
                        child: Text(
                          'Standard',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: kPrimaryTextColor, fontSize: 16),
                           overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'English',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: kPrimaryTextColor, fontSize: 16),
                           overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  rows: hyogoWords.map((word) {
                    // Build each row
                    return DataRow(
                      onSelectChanged: (bool? selected) {
                          _showWordDetails(context, word);
                      },
                      cells: <DataCell>[
                        DataCell(Text(word.kansaiExpression,
                            style: const TextStyle(color: kPrimaryTextColor, fontSize: 15))), // Slightly larger cell font
                        DataCell(Text(word.standardJapanese,
                            style: const TextStyle(color: kPrimaryTextColor, fontSize: 15))),
                        DataCell(Text(word.englishTranslation,
                            style: const TextStyle(color: kPrimaryTextColor, fontSize: 15))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}