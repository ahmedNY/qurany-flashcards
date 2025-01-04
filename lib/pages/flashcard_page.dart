import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/srs_service.dart';
import '../data/surah_data.dart';

class FlashcardPage extends StatefulWidget {
  final int pageNumber;

  const FlashcardPage({Key? key, required this.pageNumber}) : super(key: key);

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  List<Map<String, dynamic>> _flashcards = [];
  int _currentIndex = 0;
  final SRSService _srsService = SRSService();
  final Map<int, Map<String, dynamic>> _surahInfo = SurahData.surahInfo;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> unknownAyahs = prefs.getStringList('unknown_ayahs') ?? [];

    // Filter unknown ayahs for the current page
    final pageUnknownAyahs = unknownAyahs.where((entry) {
      final parts = entry.split('|');
      return int.parse(parts[0]) == widget.pageNumber; // pageNum matches
    }).toList();

    // Generate flashcards for unknown ayahs
    List<Map<String, dynamic>> flashcards = [];
    for (var entry in pageUnknownAyahs) {
      final parts = entry.split('|');
      final pageNum = int.parse(parts[0]);
      final numAyahsInPage = int.parse(parts[1]);
      final indexInPage = int.parse(parts[2]);
      final surahNum = int.parse(parts[3]);
      final ayahNum = int.parse(parts[4]);

      String cardId = '$pageNum|$surahNum|$ayahNum';

      // Load card data or initialize
      Map<String, dynamic> cardData = await _srsService.getCardData(cardId);
      if (cardData.isEmpty) {
        cardData = {
          'cardId': cardId,
          'pageNum': pageNum,
          'surahNum': surahNum,
          'ayahNum': ayahNum,
          'interval': 1,
          'ef': 2.5,
          'nextReview': DateTime.now().toIso8601String(),
        };
        await prefs.setString('card_$cardId', json.encode(cardData));
      }
      flashcards.add(cardData);
    }

    setState(() {
      _flashcards = flashcards;
      _flashcards.sort((a, b) {
        DateTime aDate = DateTime.parse(a['nextReview']);
        DateTime bDate = DateTime.parse(b['nextReview']);
        return aDate.compareTo(bDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Flashcards for Page ${widget.pageNumber}'),
        ),
        body: Center(
          child: Text('No flashcards scheduled for review.'),
        ),
      );
    }

    final currentCard = _flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards for Page ${widget.pageNumber}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Surah ${_surahInfo[currentCard['surahNum']]?['name']} Ayah ${currentCard['ayahNum']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Display the flashcard content here
            // You can customize this to display the ayah text
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _answerCard(5); // Easy
              },
              child: Text('Easy'),
            ),
            ElevatedButton(
              onPressed: () {
                _answerCard(3); // Medium
              },
              child: Text('Medium'),
            ),
            ElevatedButton(
              onPressed: () {
                _answerCard(1); // Hard
              },
              child: Text('Hard'),
            ),
          ],
        ),
      ),
    );
  }

  void _answerCard(int easeFactor) async {
    final currentCard = _flashcards[_currentIndex];
    await _srsService.scheduleCard(currentCard['cardId'], easeFactor);
    setState(() {
      _flashcards.removeAt(_currentIndex);
      if (_currentIndex >= _flashcards.length) {
        _currentIndex = 0;
      }
    });
  }
}
