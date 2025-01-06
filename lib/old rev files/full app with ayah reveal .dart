import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/surah_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2F4F3),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4F757C),
          elevation: 0,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF417D7A),
          secondary: Color(0xFF2B4141),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Qurany'),
        ),
        body: const SimpleList(),
      ),
    );
  }
}

class SimpleList extends StatefulWidget {
  const SimpleList({Key? key}) : super(key: key);

  @override
  State<SimpleList> createState() => _SimpleListState();
}

class _SimpleListState extends State<SimpleList> {
  final Map<int, int> _currentAyahNumbers = {};
  bool _globalAutoPlayEnabled = false;
  final Map<int, Map<String, dynamic>> _surahInfo = SurahData.surahInfo;

  Map<int, List<int>> _getSurahPages() {
    Map<int, List<int>> surahPages = {};

    for (int surahNum = 1; surahNum <= 114; surahNum++) {
      int startPage = _surahInfo[surahNum]!['start_page'];
      int endPage =
          surahNum < 114 ? _surahInfo[surahNum + 1]!['start_page'] - 1 : 604;

      surahPages[surahNum] =
          List.generate(endPage - startPage + 1, (index) => startPage + index);
    }

    return surahPages;
  }

  @override
  Widget build(BuildContext context) {
    final surahPages = _getSurahPages();

    // Update the special pages reference
    const Map<int, List<int>> specialPages = SurahData.specialPages;

    return ListView.builder(
      itemCount: 114,
      itemBuilder: (context, index) {
        final surahNum = index + 1;
        final surahData = _surahInfo[surahNum]!;
        final pages = surahPages[surahNum]!;

        // Add special pages to the surah's page list if it's part of a multi-surah page
        List<int> additionalPages = [];
        specialPages.forEach((pageNum, surahs) {
          if (surahs.contains(surahNum) && !pages.contains(pageNum)) {
            additionalPages.add(pageNum);
          }
        });
        final allPages = [...pages, ...additionalPages]..sort();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${surahData['name']}',
                    style: const TextStyle(
                      fontFamily: '_Othmani',
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  '(صفحة ${surahData['start_page']})',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            children: allPages.map((pageNum) {
              final multipleSurahs = specialPages[pageNum] ?? [];

              return ListTile(
                title: Row(
                  children: [
                    Text('صفحة $pageNum'),
                    if (multipleSurahs.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        '(${multipleSurahs.map((s) => _surahInfo[s]!['name']).join(' - ')})',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontFamily: '_Othmani',
                        ),
                      ),
                    ],
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahPage(
                        pageNumber: pageNum,
                        currentAyah: 1,
                        onAyahChanged: (newAyah) {
                          setState(() {
                            _currentAyahNumbers[pageNum] = 1;
                          });
                        },
                        initialSurah:
                            multipleSurahs.contains(surahNum) ? surahNum : null,
                        autoPlayEnabled: _globalAutoPlayEnabled,
                        onAutoPlayChanged: (enabled) {
                          setState(() {
                            _globalAutoPlayEnabled = enabled;
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class SurahPage extends StatefulWidget {
  final int pageNumber;
  final int currentAyah;
  final Function(int) onAyahChanged;
  final int? initialSurah;
  final bool autoPlayEnabled;
  final Function(bool) onAutoPlayChanged;

  const SurahPage({
    Key? key,
    required this.pageNumber,
    required this.currentAyah,
    required this.onAyahChanged,
    this.initialSurah,
    required this.autoPlayEnabled,
    required this.onAutoPlayChanged,
  }) : super(key: key);

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  late int _currentAyah;
  List<Map<String, dynamic>> _pageAyahs = [];
  List<Map<String, dynamic>> _currentAyahData = [];
  bool _isLoading = false;
  final Map<String, String> _tafsirMap = {};
  final Map<String, String> _translationMap = {};
  final Map<String, List<String>> _pageMapping =
      {}; // Format: 'pageNum': ['surah|ayah', ...]
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _autoPlayEnabled = true;
  Set<int> _revealedAyahs = {};

  final Map<int, Map<String, dynamic>> _surahInfo = SurahData.surahInfo;

  @override
  void initState() {
    super.initState();
    _currentAyah = widget.currentAyah;
    _loadData().then((_) {
      setState(() {
        if (widget.initialSurah != null) {
          // Show all ayahs but hide selected surah's ayahs
          _currentAyahData = _pageAyahs;
          // Find first ayah index of selected surah
          int firstAyahIndex = _pageAyahs
              .indexWhere((ayah) => ayah['surah'] == widget.initialSurah);
          if (firstAyahIndex != -1) {
            _currentAyah = firstAyahIndex + 1;
            _revealedAyahs = Set.from(_pageAyahs
                .asMap()
                .entries
                .where((entry) => entry.value['surah'] != widget.initialSurah)
                .map((entry) => entry.key + 1));
          }
        } else if (SurahData.specialPages.containsKey(widget.pageNumber)) {
          _currentAyahData = _pageAyahs;
        } else {
          _currentAyahData = _pageAyahs;
        }
      });
    });

    _autoPlayEnabled = widget.autoPlayEnabled;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all required text files
      final mappingText =
          await rootBundle.loadString('assets/Txt files/page_mapping.txt');
      final quranText =
          await rootBundle.loadString('assets/Txt files/quran-uthmani (1).txt');
      final tafsirText =
          await rootBundle.loadString('assets/Txt files/ar.muyassar.txt');
      final translationText =
          await rootBundle.loadString('assets/Txt files/en.yusufali.txt');

      // Parse page mapping
      final mappingLines = mappingText.split('\n');
      for (var line in mappingLines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split('|');
        final pageNum = parts[0];
        final surah = parts[1];
        final ayah = parts[2];

        if (!_pageMapping.containsKey(pageNum)) {
          _pageMapping[pageNum] = [];
        }
        _pageMapping[pageNum]!.add('$surah|$ayah');
      }

      // Parse Quran text
      final quranLines = quranText.split('\n');
      Map<String, String> quranMap = {};
      for (var line in quranLines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split('|');
        if (parts.length < 3) continue; // Ensure there are enough parts
        final key = '${parts[0]}|${parts[1]}';
        quranMap[key] = parts[2];
      }

      // Parse tafsir and translation
      // ... (keep existing parsing code for tafsir and translation) ...
      // Parse tafsir text
      final tafsirLines = tafsirText.split('\n');
      Map<String, String> tafsirMap = {};
      for (var line in tafsirLines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split('|');
        if (parts.length < 3) continue;
        final key = '${parts[0]}|${parts[1]}';
        tafsirMap[key] = parts[2];
      }

      // Parse translation text
      final translationLines = translationText.split('\n');
      Map<String, String> translationMap = {};
      for (var line in translationLines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split('|');
        if (parts.length < 3) continue;
        final key = '${parts[0]}|${parts[1]}';
        translationMap[key] = parts[2];
      }

      // Get ayahs for current page
      List<Map<String, dynamic>> ayahs = [];
      final pageAyahs = _pageMapping[widget.pageNumber.toString()] ?? [];

      for (var mapping in pageAyahs) {
        final parts = mapping.split('|');
        if (parts.length < 2) continue; // Ensure there are enough parts
        final surah = int.parse(parts[0]);
        final ayah = int.parse(parts[1]);
        final mapKey = '$surah|$ayah';

        ayahs.add({
          'surah': surah,
          'ayah': ayah,
          'verse': quranMap[mapKey] ?? '',
          'tafsir': tafsirMap[mapKey] ?? '',
          'translation': translationMap[mapKey] ?? '',
        });
      }

      setState(() {
        _pageAyahs = ayahs;
        if (ayahs.isNotEmpty) {
          _currentAyahData = [ayahs.first];
        } else {
          _currentAyahData = [];
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _playAudio(int surah, int ayah) async {
    try {
      // Format surah and ayah numbers to 3 digits
      final surahStr = surah.toString().padLeft(3, '0');
      final ayahStr = ayah.toString().padLeft(3, '0');
      final audioFile = 'audio_files_Hudhaify/$surahStr$ayahStr.mp3';

      setState(() {
        _isPlaying = true;
      });

      await _audioPlayer.play(AssetSource(audioFile));

      _audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          _isPlaying = false;
        });
      });
    } catch (e) {
      print('Error playing audio: $e');
      setState(() {
        _isPlaying = false;
      });
    }
  }

  // Add this helper method to get the current ayah data
  Map<String, dynamic> _getCurrentAyahData() {
    // Get the index of the last revealed ayah
    final currentIndex = (_revealedAyahs.isEmpty)
        ? 0 // If no ayahs revealed yet, start with first ayah
        : (_currentAyah - 1).clamp(0, _pageAyahs.length - 1);

    return _pageAyahs[currentIndex];
  }

  void _showNextAyah() {
    if (_currentAyah <= _pageAyahs.length) {
      // Stop any currently playing audio
      if (_isPlaying) {
        _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
        });
      }

      // Get the next ayah that belongs to the selected surah
      int nextAyahIndex = _currentAyah - 1;
      while (nextAyahIndex < _pageAyahs.length &&
          widget.initialSurah != null &&
          _pageAyahs[nextAyahIndex]['surah'] != widget.initialSurah) {
        nextAyahIndex++;
      }

      if (nextAyahIndex < _pageAyahs.length) {
        // Play audio for the ayah being revealed only if autoplay is enabled
        if (_autoPlayEnabled) {
          final currentAyahData = _pageAyahs[nextAyahIndex];
          _playAudio(
            currentAyahData['surah'],
            currentAyahData['ayah'],
          );
        }

        setState(() {
          _revealedAyahs.add(_currentAyah);
          _currentAyah++;
          widget.onAyahChanged(_currentAyah);
        });
      } else {
        _navigateToNextPage();
      }
    } else {
      _navigateToNextPage();
    }
  }

  void _navigateToNextPage() {
    if (widget.pageNumber < 604) {
      // Check if not the last page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SurahPage(
            pageNumber: widget.pageNumber + 1,
            currentAyah: 1, // Start from first ayah of new page
            onAyahChanged: (newAyah) {}, // Reset ayah tracking for new page
            autoPlayEnabled: _autoPlayEnabled,
            onAutoPlayChanged: (enabled) {
              setState(() {
                _autoPlayEnabled = enabled;
              });
            },
          ),
        ),
      );
    }
  }

  // Add this method to group ayahs by surah
  Map<int, List<Map<String, dynamic>>> _groupAyahsBySurah(
      List<Map<String, dynamic>> ayahs) {
    Map<int, List<Map<String, dynamic>>> grouped = {};
    for (var ayah in ayahs) {
      final surah = ayah['surah'] as int;
      if (!grouped.containsKey(surah)) {
        grouped[surah] = [];
      }
      grouped[surah]!.add(ayah);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive font sizes based on screen dimensions
    double getQuranFontSize() {
      if (screenWidth <= 600) return screenWidth * 0.06;
      if (screenWidth <= 1024) return screenWidth * 0.04;
      return 24.0;
    }

    double getSymbolFontSize() {
      if (screenWidth <= 600) return screenWidth * 0.04;
      if (screenWidth <= 1024) return screenWidth * 0.025;
      return 22.0;
    }

    // Calculate responsive padding
    double getHorizontalPadding() {
      if (screenWidth <= 600) return 16.0;
      if (screenWidth <= 1024) return 24.0;
      return 32.0;
    }

    double getVerticalPadding() {
      if (screenHeight <= 800) return 16.0;
      return 20.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Page ${widget.pageNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: widget.pageNumber > 1
                ? () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahPage(
                          pageNumber: widget.pageNumber - 1,
                          currentAyah: 1,
                          onAyahChanged: (newAyah) {},
                          autoPlayEnabled: _autoPlayEnabled,
                          onAutoPlayChanged: (enabled) {
                            setState(() {
                              _autoPlayEnabled = enabled;
                            });
                          },
                        ),
                      ),
                    );
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed:
                widget.pageNumber < 604 ? () => _navigateToNextPage() : null,
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 800,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFF2F4F3),
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: _groupAyahsBySurah(_currentAyahData)
                        .entries
                        .map((entry) {
                      final surahNumber = entry.key;
                      final surahAyahs = entry.value;

                      return Align(
                        alignment: Alignment.topLeft,
                        child: Card(
                          margin: EdgeInsets.all(getHorizontalPadding() * 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                              color: Color(0xFF4F757C),
                              width: 3,
                            ),
                          ),
                          elevation: 5,
                          child: InkWell(
                            onTap: _showNextAyah,
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                maxWidth:
                                    screenWidth > 1024 ? 1024 : double.infinity,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getHorizontalPadding(),
                                  vertical: getVerticalPadding(),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'سورة ${_surahInfo[surahNumber]!['name']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: const Color(0xFF2B4141),
                                                fontSize:
                                                    getQuranFontSize() * 0.75,
                                                fontFamily: 'Scheherazade',
                                              ),
                                        ),
                                        if (surahAyahs.isNotEmpty)
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  _autoPlayEnabled
                                                      ? Icons.repeat_one
                                                      : Icons
                                                          .repeat_one_outlined,
                                                  color: _autoPlayEnabled
                                                      ? const Color(0xFF417D7A)
                                                      : Colors.grey,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _autoPlayEnabled =
                                                        !_autoPlayEnabled;
                                                  });
                                                  widget.onAutoPlayChanged(
                                                      _autoPlayEnabled);
                                                },
                                                tooltip: 'Toggle Auto-play',
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  _isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: const Color(0xFF417D7A),
                                                ),
                                                onPressed: _isPlaying
                                                    ? () {
                                                        _audioPlayer.pause();
                                                        setState(() {
                                                          _isPlaying = false;
                                                        });
                                                      }
                                                    : () {
                                                        final currentAyahData =
                                                            _getCurrentAyahData();
                                                        _playAudio(
                                                          currentAyahData[
                                                              'surah'],
                                                          currentAyahData[
                                                              'ayah'],
                                                        );
                                                      },
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: getVerticalPadding()),
                                    RichText(
                                      textAlign: TextAlign.justify,
                                      textDirection: TextDirection.rtl,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontFamily: 'Scheherazade',
                                          fontSize: getQuranFontSize(),
                                          height: 1.5,
                                          letterSpacing: 0,
                                          color: const Color(0xFF2B4141),
                                        ),
                                        children: surahAyahs.map((ayah) {
                                          final isRevealed =
                                              _revealedAyahs.contains(
                                                  _pageAyahs.indexOf(ayah) + 1);

                                          return TextSpan(
                                            children: [
                                              TextSpan(
                                                text: ayah['verse'],
                                                style: TextStyle(
                                                  fontFamily: 'Scheherazade',
                                                  fontSize: getQuranFontSize(),
                                                  height: 1.5,
                                                  letterSpacing: 0,
                                                  color: isRevealed
                                                      ? const Color(0xFF2B4141)
                                                      : const Color(0xFFF2F4F3),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    ' ۝${ayah['ayah'].toString().replaceAll('0', '٠').replaceAll('1', '١').replaceAll('2', '٢').replaceAll('3', '٣').replaceAll('4', '٤').replaceAll('5', '٥').replaceAll('6', '٦').replaceAll('7', '٧').replaceAll('8', '٨').replaceAll('9', '٩')} ',
                                                style: TextStyle(
                                                  fontFamily: 'Scheherazade',
                                                  fontSize: getSymbolFontSize(),
                                                  color: const Color(0xFF417D7A),
                                                  letterSpacing: 0,
                                                  height: 1.2,
                                                  textBaseline:
                                                      TextBaseline.alphabetic,
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    if (surahAyahs.isNotEmpty &&
                                        _currentAyah <=
                                            _pageAyahs.length + 1) ...[
                                      Divider(
                                        height: getVerticalPadding() * 2,
                                        thickness: 1,
                                        color:
                                            const Color(0xFF4F757C).withOpacity(0.3),
                                      ),
                                      Text(
                                        _pageAyahs[(_currentAyah - 2).clamp(
                                                    0, _pageAyahs.length - 1)]
                                                ['tafsir'] ??
                                            '',
                                        style: TextStyle(
                                          fontSize: getQuranFontSize() * 0.65,
                                          height: 1.5,
                                          color: const Color(0xFF2B4141)
                                              .withOpacity(0.8),
                                        ),
                                        textAlign: TextAlign.justify,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      SizedBox(
                                          height: getVerticalPadding() * 0.5),
                                      Text(
                                        _pageAyahs[(_currentAyah - 2).clamp(
                                                    0, _pageAyahs.length - 1)]
                                                ['translation'] ??
                                            '',
                                        style: TextStyle(
                                          fontSize: getQuranFontSize() * 0.65,
                                          height: 1.5,
                                          color: const Color(0xFF2B4141)
                                              .withOpacity(0.8),
                                          fontStyle: FontStyle.italic,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ),
    );
  }
}
