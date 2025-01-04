import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/surah_data.dart';
import '../widgets/ayah_display.dart';

class ReviewSurahPage extends StatefulWidget {
  @override
  _ReviewSurahPageState createState() => _ReviewSurahPageState();
}

class _ReviewSurahPageState extends State<ReviewSurahPage> {
  final TextEditingController _pageController = TextEditingController();
  final TextEditingController _ayahController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _pageAyahs = [];
  List<Map<String, dynamic>> _currentAyahData = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _currentAyah = 1;
  final Map<int, Map<String, dynamic>> _surahInfo = SurahData.surahInfo;
  Map<String, String> _pageMapping = {};
  String? _surahBismillah;
  Set<int> _fullyRevealedAyahs = {};
  Set<int> _partiallyRevealedAyahs = {};
  bool _showFirstWordOnly = false;

  @override
  void initState() {
    super.initState();
    print('Initializing ReviewSurahPage');
  }

  Future<void> _loadData(int pageNumber, int startAyah) async {
    print('Starting _loadData() for page $pageNumber, ayah $startAyah');
    setState(() {
      _isLoading = true;
    });

    try {
      print('Loading text files...');
      final mappingText =
          await rootBundle.loadString('assets/Txt files/page_mapping.txt');
      final quranText =
          await rootBundle.loadString('assets/Txt files/quran-uthmani (1).txt');
      final tafsirText =
          await rootBundle.loadString('assets/Txt files/ar.muyassar.txt');
      final translationText =
          await rootBundle.loadString('assets/Txt files/en.yusufali.txt');

      // Parse files and create ayahs list (reusing logic from main.dart)
      print('Parsing page mapping for page $pageNumber');
      final mappingLines = mappingText.split('\n');
      Map<String, List<String>> pageMapping = {};

      for (var line in mappingLines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split('|');
        final pageNum = parts[0];
        if (!pageMapping.containsKey(pageNum)) {
          pageMapping[pageNum] = [];
        }
        pageMapping[pageNum]!.add('${parts[1]}|${parts[2]}');
      }

      // Get ayahs for selected page
      print('Creating ayahs list for page $pageNumber');
      List<Map<String, dynamic>> ayahs = [];
      final pageAyahs = pageMapping[pageNumber.toString()] ?? [];
      print('Found ${pageAyahs.length} ayahs on this page');

      // Parse Quran text and create ayahs
      final quranLines = quranText.split('\n');
      Map<String, String> quranMap = {};
      for (var line in quranLines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split('|');
        if (parts.length < 3) continue;
        final key = '${parts[0]}|${parts[1]}';
        quranMap[key] = parts[2];
      }

      // Create ayahs list
      for (var mapping in pageAyahs) {
        final parts = mapping.split('|');
        final surah = int.parse(parts[0]);
        final ayah = int.parse(parts[1]);
        final mapKey = '$surah|$ayah';

        ayahs.add({
          'surah': surah,
          'ayah': ayah,
          'verse': quranMap[mapKey] ?? '',
          'tafsir': '', // Add tafsir parsing if needed
          'translation': '', // Add translation parsing if needed
        });
      }

      setState(() {
        _pageAyahs = ayahs;
        _currentAyah = startAyah.clamp(1, ayahs.length);
        _fullyRevealedAyahs = Set.from(List.generate(startAyah, (i) => i + 1));
        _isLoading = false;
      });

      print('Data loaded successfully. Current ayah: $_currentAyah');
    } catch (e) {
      print('Error in _loadData(): $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Surah'),
      ),
      body: Column(
        children: [
          // Input fields for page and ayah selection
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pageController,
                    decoration: InputDecoration(
                      labelText: 'Page Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _ayahController,
                    decoration: InputDecoration(
                      labelText: 'Ayah Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final pageNum = int.tryParse(_pageController.text) ?? 1;
                    final ayahNum = int.tryParse(_ayahController.text) ?? 1;
                    _loadData(pageNum, ayahNum);
                  },
                  child: Text('Load'),
                ),
              ],
            ),
          ),

          // Display area for ayahs
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          for (var i = 0; i < _pageAyahs.length; i++)
                            AyahDisplay(
                              ayahData: _pageAyahs[i],
                              isFullyRevealed:
                                  _fullyRevealedAyahs.contains(i + 1),
                              isPartiallyRevealed:
                                  _partiallyRevealedAyahs.contains(i + 1),
                              showFirstWordOnly: _showFirstWordOnly,
                              onTap: () {
                                if (_showFirstWordOnly) {
                                  if (_partiallyRevealedAyahs.contains(i + 1)) {
                                    setState(() {
                                      _fullyRevealedAyahs.add(i + 1);
                                      _partiallyRevealedAyahs.remove(i + 1);
                                    });
                                  } else if (!_fullyRevealedAyahs
                                      .contains(i + 1)) {
                                    setState(() {
                                      _partiallyRevealedAyahs.add(i + 1);
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _fullyRevealedAyahs.add(i + 1);
                                  });
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _showFirstWordOnly = !_showFirstWordOnly;
                if (!_showFirstWordOnly) {
                  // When switching to full ayah mode, reveal all partially revealed ayahs
                  _fullyRevealedAyahs.addAll(_partiallyRevealedAyahs);
                  _partiallyRevealedAyahs.clear();
                }
              });
            },
            child: Icon(
                _showFirstWordOnly ? Icons.visibility_off : Icons.visibility),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                // Reset all revelations
                _fullyRevealedAyahs.clear();
                _partiallyRevealedAyahs.clear();
              });
            },
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    _ayahController.dispose();
    super.dispose();
  }
}
