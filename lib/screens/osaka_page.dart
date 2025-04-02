// lib/screens/osaka_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/kansai_word.dart'; // Adjust path if needed

// --- Theme Colors --- (Repeat or move to central location)
const Color kPrimaryBackgroundColor = Color(0xFFF2D7A9);
const Color kPrimaryTextColor = Color(0xFF2A1201);
const Color kAccentColorOrange = Color(0xFFE55934);
const Color kAccentColorGold = Color(0xFFF5B700);
const Color kCardBackgroundColor = Color(0xFFFAEBCD);
const Color kSubtleTextColor = Color(0xFF6E5B44);
// --- End Theme Colors ---

class OsakaPage extends StatefulWidget {
  const OsakaPage({super.key});

  @override
  State<OsakaPage> createState() => _OsakaPageState();
}

class _OsakaPageState extends State<OsakaPage> {
  late Future<List<KansaiWord>> _osakaWordsFuture;

  @override
  void initState() {
    super.initState();
    _osakaWordsFuture = _loadOsakaWords();
  }

  Future<List<KansaiWord>> _loadOsakaWords() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/osaka_words.json'); // Load Osaka JSON
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<KansaiWord> osakaWords =
          jsonList.map((jsonItem) => KansaiWord.fromJson(jsonItem)).toList();
      return osakaWords;
    } catch (e) {
      debugPrint('Error loading or parsing osaka_words.json: $e');
      return Future.error('Failed to load Osaka words.');
    }
  }

  // --- _showWordDetails and _buildDetailRow are IDENTICAL to HyougoPage ---
  // --- You can copy them here, or ideally extract them to a shared utility/widget ---
  void _showWordDetails(BuildContext context, KansaiWord word) {
    showModalBottomSheet( /* ... Same implementation as HyougoPage ... */
      context: context,
      backgroundColor: kCardBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
         return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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

  Widget _buildDetailRow(String label, String value, {bool isHighlight = false, bool isExample = false, bool isSubtle = false}) {
     return RichText( /* ... Same implementation as HyougoPage ... */
       text: TextSpan(
        style: TextStyle(
          fontSize: isExample ? 16 : 18,
          color: isSubtle ? kSubtleTextColor : kPrimaryTextColor,
           fontFamily: 'YourCustomFont',
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
  // --- End of shared functions ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryBackgroundColor,
      appBar: AppBar(
        title: const Text( // Change Title
          'Osaka - 大阪府',
          style: TextStyle(color: kPrimaryTextColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPrimaryTextColor),
      ),
      body: FutureBuilder<List<KansaiWord>>(
        future: _osakaWordsFuture, // Use Osaka future
        builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator(color: kAccentColorOrange));
           }
           if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
             return Center( /* ... Error Handling ... */
                child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  snapshot.hasError
                      ? 'Error loading words.\nPlease check your connection or the data file (osaka_words.json).' // Updated error
                      : 'No words found for Osaka in the dictionary.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: kPrimaryTextColor, fontSize: 16, height: 1.5),
                ),
              ),
            );
           }
           final words = snapshot.data!;
           return SingleChildScrollView( /* ... DataTable setup IDENTICAL to HyougoPage ... */
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: DataTable(
                  showCheckboxColumn: false,
                  headingRowColor: MaterialStateColor.resolveWith((states) => kAccentColorGold.withOpacity(0.3)),
                  dataRowColor: MaterialStateColor.resolveWith((states) => kCardBackgroundColor.withOpacity(0.6)),
                  dataRowMinHeight: 48.0, dataRowMaxHeight: 60.0, headingRowHeight: 56.0,
                  columnSpacing: 25.0,
                  columns: const <DataColumn>[ /* ... Same Columns ... */
                     DataColumn(label: Expanded(child: Text('Kansai-ben', style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryTextColor, fontSize: 16), overflow: TextOverflow.ellipsis))),
                     DataColumn(label: Expanded(child: Text('Standard', style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryTextColor, fontSize: 16), overflow: TextOverflow.ellipsis))),
                     DataColumn(label: Expanded(child: Text('English', style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryTextColor, fontSize: 16), overflow: TextOverflow.ellipsis))),
                  ],
                  rows: words.map((word) { // Use 'words' variable
                    return DataRow(
                      onSelectChanged: (bool? selected) { _showWordDetails(context, word); },
                      cells: <DataCell>[ /* ... Same Cells ... */
                        DataCell(Text(word.kansaiExpression, style: const TextStyle(color: kPrimaryTextColor, fontSize: 15))),
                        DataCell(Text(word.standardJapanese, style: const TextStyle(color: kPrimaryTextColor, fontSize: 15))),
                        DataCell(Text(word.englishTranslation, style: const TextStyle(color: kPrimaryTextColor, fontSize: 15))),
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