// lib/screens/hyougo_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // For loading JSON asset
import 'dart:convert'; // For decoding JSON
import '../models/kansai_word.dart';

// --- Theme Colors ---
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
    _hyogoWordsFuture = _loadHyogoWords();
  }

  Future<List<KansaiWord>> _loadHyogoWords() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/hyougo_words.json');

      // Decode the JSON string into a List<dynamic>
      final List<dynamic> jsonList = json.decode(jsonString);

      final List<KansaiWord> hyogoWords =
          jsonList.map((jsonItem) => KansaiWord.fromJson(jsonItem)).toList();

      return hyogoWords;
    } catch (e) {
      debugPrint('Error loading or parsing hyougo_words.json: $e');
      return Future.error('Failed to load Hyougo words.');
    }
  }

   // Function to show the details in a bottom sheet
  void _showWordDetails(BuildContext context, KansaiWord word) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCardBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          // Make content scrollable if it overflows
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDetailRow("Kansai-ben:", word.kansaiExpression, isHighlight: true),
                const SizedBox(height: 10),
                _buildDetailRow("Standard:", word.standardJapanese),
                const SizedBox(height: 10),
                _buildDetailRow("English:", word.englishTranslation),
                const Divider(height: 30, thickness: 1, color: kSubtleTextColor),
                _buildDetailRow("Example:", word.exampleSentence, isExample: true),
                const SizedBox(height: 8),
                _buildDetailRow("(", word.standardJapaneseSentence, isExample: true, isSubtle: true),
                 const SizedBox(height: 8),
                _buildDetailRow("(", word.englishSentence + ")", isExample: true, isSubtle: true),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget for styling detail rows in the bottom sheet
  Widget _buildDetailRow(String label, String value, {bool isHighlight = false, bool isExample = false, bool isSubtle = false}) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: isExample ? 16 : 18,
          color: isSubtle ? kSubtleTextColor : kPrimaryTextColor,
           height: 1.4
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
      backgroundColor: kPrimaryBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Hyogo - 兵庫県',
          style: TextStyle(
            color: kPrimaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPrimaryTextColor),
        leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back to Map',
                onPressed: () {
                  Navigator.pop(context);
                },
            ),

      ),
      body: FutureBuilder<List<KansaiWord>>(
        future: _hyogoWordsFuture,
        builder: (context, snapshot) {
          // ----- Handle Loading State -----
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: kAccentColorOrange));
          }

          // ----- Handle Error State -----
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  snapshot.hasError
                      ? 'Error loading words.\nPlease check your connection or the data file (hyougo_words.json).'
                      : 'No words found for Hyougo in the dictionary.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: kPrimaryTextColor, fontSize: 16, height: 1.5),
                ),
              ),
            );
          }

          // ----- Handle Data Loaded State -----
          final hyogoWords = snapshot.data!;

          return SingleChildScrollView(
            child: Center(
              child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: DataTable(
                  showCheckboxColumn: false,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => kAccentColorGold.withOpacity(0.3)),
                  dataRowColor: MaterialStateColor.resolveWith(
                    (states) {
                      return kCardBackgroundColor.withOpacity(0.6);
                    }),
                   dataRowMinHeight: 48.0,
                   dataRowMaxHeight: 60.0,
                   headingRowHeight: 56.0,
                  columnSpacing: 25.0,
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded( // Use Expanded to allow text wrapping if needed
                        child: Text(
                          'Kansai-ben',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: kPrimaryTextColor, fontSize: 16),
                           overflow: TextOverflow.ellipsis,
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
                    return DataRow(
                      onSelectChanged: (bool? selected) {
                          _showWordDetails(context, word);
                      },
                      cells: <DataCell>[
                        DataCell(Text(word.kansaiExpression,
                            style: const TextStyle(color: kPrimaryTextColor, fontSize: 15))),
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
            ) 
          );
        },
      ),
    );
  }
}