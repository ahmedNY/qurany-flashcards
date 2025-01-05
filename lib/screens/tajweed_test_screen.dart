import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/tajweed_parser.dart';

class TajweedTestScreen extends StatefulWidget {
  @override
  _TajweedTestScreenState createState() => _TajweedTestScreenState();
}

class _TajweedTestScreenState extends State<TajweedTestScreen> {
  List<String> verses = [];
  bool isLoading = true;

  final Map<String, Color> tajweedColors = {
    'h': TajweedColor.lightBlue, // Emphatic pronunciation
    'g': TajweedColor.green, // Nasalization (ghunnah)
    'l': const Color.fromARGB(255, 197, 197, 197), // Non-pronounced letters
    'q': TajweedColor.darkBlue, // Qalqalah
    'f': TajweedColor.orangeRed, // Permissible prolongation
    'p': TajweedColor.cuminRed, // Normal prolongation
    'u': TajweedColor.bloodRed, // Obligatory prolongation
    'm': TajweedColor.darkRed, // Necessary prolongation
  };

  TextSpan parseTajweedText(String verse, double fontSize) {
    List<TextSpan> spans = [];
    RegExp regex = RegExp(r'\[(.*?)\[(.*?)\]|[^\[]+');

    for (Match match in regex.allMatches(verse)) {
      String text = match.group(0) ?? '';

      if (text.startsWith('[')) {
        RegExp ruleRegex = RegExp(r'\[(\w+):?(\d*)\[(.*?)\]');
        Match? ruleMatch = ruleRegex.firstMatch(text);

        if (ruleMatch != null) {
          String rule = ruleMatch.group(1) ?? '';
          String content = ruleMatch.group(3) ?? '';

          spans.add(TextSpan(
            text: content,
            style: TextStyle(
              color: tajweedColors[rule] ?? Colors.black,
              fontFamily: 'Scheherazade',
              fontSize: fontSize,
            ),
          ));
        }
      } else {
        spans.add(TextSpan(
          text: text,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Scheherazade',
            fontSize: fontSize,
          ),
        ));
      }
    }

    return TextSpan(children: spans);
  }

  @override
  void initState() {
    super.initState();
    _loadVerses();
  }

  Future<void> _loadVerses() async {
    try {
      final String content =
          await rootBundle.loadString('assets/Txt files/quran-tajweed.txt');
      setState(() {
        verses = content
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .take(7) // First 7 verses (Al-Fatiha)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading verses: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tajweed Test'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ...verses
                        .map((verse) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                text: parseTajweedText(verse, 32.0),
                              ),
                            ))
                        .toList(),
                    SizedBox(height: 40),
                    Text('Tajweed Rules:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildLegendItem(
                            'Necessary Prolongation', TajweedColor.darkRed),
                        _buildLegendItem(
                            'Obligatory Prolongation', TajweedColor.bloodRed),
                        _buildLegendItem(
                            'Permissible Prolongation', TajweedColor.orangeRed),
                        _buildLegendItem(
                            'Normal Prolongation', TajweedColor.cuminRed),
                        _buildLegendItem(
                            'Non-pronounced Letters', TajweedColor.gray),
                        _buildLegendItem(
                            'Emphatic Pronunciation', TajweedColor.darkBlue),
                        _buildLegendItem('Qalqalah', TajweedColor.lightBlue),
                        _buildLegendItem('Nasalization', TajweedColor.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Tooltip(
      message: label,
      triggerMode: TooltipTriggerMode.tap,
      child: Container(
        margin: EdgeInsets.all(4),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}
