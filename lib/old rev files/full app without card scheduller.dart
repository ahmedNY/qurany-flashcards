import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF2F4F3),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4F757C),
          elevation: 0,
        ),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF417D7A),
          secondary: Color(0xFF2B4141),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple List 1-114 (with Printing)'),
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
  final Map<int, Map<String, dynamic>> _surahInfo = {
    1: {'name': 'الفاتحة', 'start_page': 1},
    2: {'name': 'البقرة', 'start_page': 2},
    3: {'name': 'آل عمران', 'start_page': 50},
    4: {'name': 'النساء', 'start_page': 77},
    5: {'name': 'المائدة', 'start_page': 106},
    6: {'name': 'الأنعام', 'start_page': 128},
    7: {'name': 'الأعراف', 'start_page': 151},
    8: {'name': 'الأنفال', 'start_page': 177},
    9: {'name': 'التوبة', 'start_page': 187},
    10: {'name': 'يونس', 'start_page': 208},
    11: {'name': 'هود', 'start_page': 221},
    12: {'name': 'يوسف', 'start_page': 235},
    13: {'name': 'الرعد', 'start_page': 249},
    14: {'name': 'ابراهيم', 'start_page': 255},
    15: {'name': 'الحجر', 'start_page': 262},
    16: {'name': 'النحل', 'start_page': 267},
    17: {'name': 'الإسراء', 'start_page': 282},
    18: {'name': 'الكهف', 'start_page': 293},
    19: {'name': 'مريم', 'start_page': 305},
    20: {'name': 'طه', 'start_page': 312},
    21: {'name': 'الأنبياء', 'start_page': 322},
    22: {'name': 'الحج', 'start_page': 332},
    23: {'name': 'المؤمنون', 'start_page': 342},
    24: {'name': 'النور', 'start_page': 350},
    25: {'name': 'لفرقان', 'start_page': 359},
    26: {'name': 'الشعراء', 'start_page': 367},
    27: {'name': 'النمل', 'start_page': 377},
    28: {'name': 'القصص', 'start_page': 385},
    29: {'name': 'العنكبوت', 'start_page': 396},
    30: {'name': 'الروم', 'start_page': 404},
    31: {'name': 'لقمان', 'start_page': 411},
    32: {'name': 'السجدة', 'start_page': 415},
    33: {'name': 'الأحزاب', 'start_page': 418},
    34: {'name': 'سبإ', 'start_page': 428},
    35: {'name': 'فاطر', 'start_page': 434},
    36: {'name': 'يس', 'start_page': 440},
    37: {'name': 'الصافات', 'start_page': 446},
    38: {'name': 'ص', 'start_page': 453},
    39: {'name': 'الزمر', 'start_page': 458},
    40: {'name': 'غافر', 'start_page': 467},
    41: {'name': 'فصلت', 'start_page': 477},
    42: {'name': 'الشورى', 'start_page': 483},
    43: {'name': 'الزخرف', 'start_page': 489},
    44: {'name': 'الدخان', 'start_page': 496},
    45: {'name': 'الجاثية', 'start_page': 499},
    46: {'name': 'الأحقاف', 'start_page': 502},
    47: {'name': 'محمد', 'start_page': 507},
    48: {'name': 'الفتح', 'start_page': 511},
    49: {'name': 'الحجرات', 'start_page': 515},
    50: {'name': 'ق', 'start_page': 518},
    51: {'name': 'الذاريات', 'start_page': 520},
    52: {'name': 'الطور', 'start_page': 523},
    53: {'name': 'النجم', 'start_page': 526},
    54: {'name': 'القمر', 'start_page': 528},
    55: {'name': 'الرحمن', 'start_page': 531},
    56: {'name': 'الواقعة', 'start_page': 534},
    57: {'name': 'الحديد', 'start_page': 537},
    58: {'name': 'المجادلة', 'start_page': 542},
    59: {'name': 'الحشر', 'start_page': 545},
    60: {'name': 'الممتحنة', 'start_page': 549},
    61: {'name': 'الصف', 'start_page': 551},
    62: {'name': 'الجمعة', 'start_page': 553},
    63: {'name': 'المنافقون', 'start_page': 554},
    64: {'name': 'التغابن', 'start_page': 556},
    65: {'name': 'الطلاق', 'start_page': 558},
    66: {'name': 'التحريم', 'start_page': 560},
    67: {'name': 'الملك', 'start_page': 562},
    68: {'name': 'القلم', 'start_page': 564},
    69: {'name': 'الحاقة', 'start_page': 566},
    70: {'name': 'المعارج', 'start_page': 568},
    71: {'name': 'نوح', 'start_page': 570},
    72: {'name': 'الجن', 'start_page': 572},
    73: {'name': 'المزمل', 'start_page': 574},
    74: {'name': 'المدثر', 'start_page': 575},
    75: {'name': 'القيامة', 'start_page': 577},
    76: {'name': 'الانسان', 'start_page': 578},
    77: {'name': 'المرسلات', 'start_page': 580},
    78: {'name': 'النبإ', 'start_page': 582},
    79: {'name': 'النازعات', 'start_page': 583},
    80: {'name': 'عبس', 'start_page': 585},
    81: {'name': 'التكوير', 'start_page': 586},
    82: {'name': 'الإنفطار', 'start_page': 587},
    83: {'name': 'المطففين', 'start_page': 587},
    84: {'name': 'الإنشقاق', 'start_page': 589},
    85: {'name': 'البروج', 'start_page': 590},
    86: {'name': 'الطارق', 'start_page': 591},
    87: {'name': 'الأعلى', 'start_page': 591},
    88: {'name': 'الغاشية', 'start_page': 592},
    89: {'name': 'الفجر', 'start_page': 593},
    90: {'name': 'البلد', 'start_page': 594},
    91: {'name': 'الشمس', 'start_page': 595},
    92: {'name': 'الليل', 'start_page': 595},
    93: {'name': 'الضحى', 'start_page': 596},
    94: {'name': 'الشرح', 'start_page': 596},
    95: {'name': 'التين', 'start_page': 597},
    96: {'name': 'العلق', 'start_page': 597},
    97: {'name': 'القدر', 'start_page': 598},
    98: {'name': 'البينة', 'start_page': 598},
    99: {'name': 'الزلزلة', 'start_page': 599},
    100: {'name': 'العاديات', 'start_page': 599},
    101: {'name': 'القارعة', 'start_page': 600},
    102: {'name': 'التكاثر', 'start_page': 600},
    103: {'name': 'العصر', 'start_page': 601},
    104: {'name': 'الهمزة', 'start_page': 601},
    105: {'name': 'الفيل', 'start_page': 601},
    106: {'name': 'قريش', 'start_page': 602},
    107: {'name': 'الماعون', 'start_page': 602},
    108: {'name': 'الكوثر', 'start_page': 602},
    109: {'name': 'الكافرون', 'start_page': 603},
    110: {'name': 'النصر', 'start_page': 603},
    111: {'name': 'المسد', 'start_page': 603},
    112: {'name': 'الإخلاص', 'start_page': 604},
    113: {'name': 'الفلق', 'start_page': 604},
    114: {'name': 'الناس', 'start_page': 604},
  };

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

    // Special cases for pages with multiple surahs
    final Map<int, List<int>> specialPages = {
      587: [82, 83], // Al-Infitar and Al-Mutaffifin
      591: [86, 87], // At-Tariq and Al-A'la
      595: [91, 92], // Ash-Shams and Al-Lail
      596: [93, 94], // Ad-Duha and Ash-Sharh
      597: [95, 96], // At-Tin and Al-Alaq
      598: [97, 98], // Al-Qadr and Al-Bayyina
      599: [99, 100], // Az-Zalzala and Al-Adiyat
      600: [101, 102], // Al-Qari'a and At-Takathur
      601: [103, 104, 105], // Al-Asr, Al-Humaza, and Al-Fil
      602: [106, 107, 108], // Quraish, Al-Ma'un, and Al-Kawthar
      603: [109, 110, 111], // Al-Kafirun, An-Nasr, and Al-Masad
      604: [112, 113, 114], // Al-Ikhlas, Al-Falaq, and An-Nas
    };

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
                    style: TextStyle(
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
                      SizedBox(width: 8),
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
                        currentAyah: _currentAyahNumbers[pageNum] ?? 1,
                        onAyahChanged: (newAyah) {
                          setState(() {
                            _currentAyahNumbers[pageNum] = newAyah;
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
  Map<String, String> _tafsirMap = {};
  Map<String, String> _translationMap = {};
  Map<String, List<String>> _pageMapping =
      {}; // Format: 'pageNum': ['surah|ayah', ...]
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _autoPlayEnabled = true;

  final Map<int, Map<String, dynamic>> _surahInfo = {
    1: {'name': 'الفاتحة', 'start_page': 1},
    2: {'name': 'البقرة', 'start_page': 2},
    3: {'name': 'آل عمران', 'start_page': 50},
    4: {'name': 'النساء', 'start_page': 77},
    5: {'name': 'المائدة', 'start_page': 106},
    6: {'name': 'الأنعام', 'start_page': 128},
    7: {'name': 'الأعراف', 'start_page': 151},
    8: {'name': 'الأنفال', 'start_page': 177},
    9: {'name': 'التوبة', 'start_page': 187},
    10: {'name': 'يونس', 'start_page': 208},
    11: {'name': 'هود', 'start_page': 221},
    12: {'name': 'يوسف', 'start_page': 235},
    13: {'name': 'الرعد', 'start_page': 249},
    14: {'name': 'ابراهيم', 'start_page': 255},
    15: {'name': 'الحجر', 'start_page': 262},
    16: {'name': 'النحل', 'start_page': 267},
    17: {'name': 'الإسراء', 'start_page': 282},
    18: {'name': 'الكهف', 'start_page': 293},
    19: {'name': 'مريم', 'start_page': 305},
    20: {'name': 'طه', 'start_page': 312},
    21: {'name': 'الأنبياء', 'start_page': 322},
    22: {'name': 'الحج', 'start_page': 332},
    23: {'name': 'المؤمنون', 'start_page': 342},
    24: {'name': 'النور', 'start_page': 350},
    25: {'name': 'لفرقان', 'start_page': 359},
    26: {'name': 'الشعراء', 'start_page': 367},
    27: {'name': 'النمل', 'start_page': 377},
    28: {'name': 'القصص', 'start_page': 385},
    29: {'name': 'العنكبوت', 'start_page': 396},
    30: {'name': 'الروم', 'start_page': 404},
    31: {'name': 'لقمان', 'start_page': 411},
    32: {'name': 'السجدة', 'start_page': 415},
    33: {'name': 'الأحزاب', 'start_page': 418},
    34: {'name': 'سبإ', 'start_page': 428},
    35: {'name': 'فاطر', 'start_page': 434},
    36: {'name': 'يس', 'start_page': 440},
    37: {'name': 'الصافات', 'start_page': 446},
    38: {'name': 'ص', 'start_page': 453},
    39: {'name': 'الزمر', 'start_page': 458},
    40: {'name': 'غافر', 'start_page': 467},
    41: {'name': 'فصلت', 'start_page': 477},
    42: {'name': 'الشورى', 'start_page': 483},
    43: {'name': 'الزخرف', 'start_page': 489},
    44: {'name': 'الدخان', 'start_page': 496},
    45: {'name': 'الجاثية', 'start_page': 499},
    46: {'name': 'الأحقاف', 'start_page': 502},
    47: {'name': 'محمد', 'start_page': 507},
    48: {'name': 'الفتح', 'start_page': 511},
    49: {'name': 'الحجرات', 'start_page': 515},
    50: {'name': 'ق', 'start_page': 518},
    51: {'name': 'الذاريات', 'start_page': 520},
    52: {'name': 'الطور', 'start_page': 523},
    53: {'name': 'النجم', 'start_page': 526},
    54: {'name': 'القمر', 'start_page': 528},
    55: {'name': 'الرحمن', 'start_page': 531},
    56: {'name': 'الواقعة', 'start_page': 534},
    57: {'name': 'الحديد', 'start_page': 537},
    58: {'name': 'المجادلة', 'start_page': 542},
    59: {'name': 'الحشر', 'start_page': 545},
    60: {'name': 'الممتحنة', 'start_page': 549},
    61: {'name': 'الصف', 'start_page': 551},
    62: {'name': 'الجمعة', 'start_page': 553},
    63: {'name': 'المنافقون', 'start_page': 554},
    64: {'name': 'التغابن', 'start_page': 556},
    65: {'name': 'الطلاق', 'start_page': 558},
    66: {'name': 'التحريم', 'start_page': 560},
    67: {'name': 'الملك', 'start_page': 562},
    68: {'name': 'القلم', 'start_page': 564},
    69: {'name': 'الحاقة', 'start_page': 566},
    70: {'name': 'المعارج', 'start_page': 568},
    71: {'name': 'نوح', 'start_page': 570},
    72: {'name': 'الجن', 'start_page': 572},
    73: {'name': 'المزمل', 'start_page': 574},
    74: {'name': 'المدثر', 'start_page': 575},
    75: {'name': 'القيامة', 'start_page': 577},
    76: {'name': 'الانسان', 'start_page': 578},
    77: {'name': 'المرسلات', 'start_page': 580},
    78: {'name': 'النبإ', 'start_page': 582},
    79: {'name': 'النازعات', 'start_page': 583},
    80: {'name': 'عبس', 'start_page': 585},
    81: {'name': 'التكوير', 'start_page': 586},
    82: {'name': 'الإنفطار', 'start_page': 587},
    83: {'name': 'المطففين', 'start_page': 587},
    84: {'name': 'الإنشقاق', 'start_page': 589},
    85: {'name': 'البروج', 'start_page': 590},
    86: {'name': 'الطارق', 'start_page': 591},
    87: {'name': 'الأعلى', 'start_page': 591},
    88: {'name': 'الغاشية', 'start_page': 592},
    89: {'name': 'الفجر', 'start_page': 593},
    90: {'name': 'البلد', 'start_page': 594},
    91: {'name': 'الشمس', 'start_page': 595},
    92: {'name': 'الليل', 'start_page': 595},
    93: {'name': 'الضحى', 'start_page': 596},
    94: {'name': 'الشرح', 'start_page': 596},
    95: {'name': 'التين', 'start_page': 597},
    96: {'name': 'العلق', 'start_page': 597},
    97: {'name': 'القدر', 'start_page': 598},
    98: {'name': 'البينة', 'start_page': 598},
    99: {'name': 'الزلزلة', 'start_page': 599},
    100: {'name': 'العاديات', 'start_page': 599},
    101: {'name': 'القارعة', 'start_page': 600},
    102: {'name': 'التكاثر', 'start_page': 600},
    103: {'name': 'العصر', 'start_page': 601},
    104: {'name': 'الهمزة', 'start_page': 601},
    105: {'name': 'الفيل', 'start_page': 601},
    106: {'name': 'قريش', 'start_page': 602},
    107: {'name': 'الماعون', 'start_page': 602},
    108: {'name': 'الكوثر', 'start_page': 602},
    109: {'name': 'الكافرون', 'start_page': 603},
    110: {'name': 'النصر', 'start_page': 603},
    111: {'name': 'المسد', 'start_page': 603},
    112: {'name': 'الإخلاص', 'start_page': 604},
    113: {'name': 'الفلق', 'start_page': 604},
    114: {'name': 'الناس', 'start_page': 604},
  };

  @override
  void initState() {
    super.initState();
    _currentAyah = widget.currentAyah;
    _loadData();

    // If initialSurah is provided, filter initial ayahs to start with that surah
    if (widget.initialSurah != null) {
      _loadData().then((_) {
        setState(() {
          _currentAyahData = _pageAyahs
              .where((ayah) => ayah['surah'] == widget.initialSurah)
              .take(1)
              .toList();
        });
      });
    }

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
      Map<String, String> _tafsirMap = {};
      for (var line in tafsirLines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split('|');
        if (parts.length < 3) continue;
        final key = '${parts[0]}|${parts[1]}';
        _tafsirMap[key] = parts[2];
      }

      // Parse translation text
      final translationLines = translationText.split('\n');
      Map<String, String> _translationMap = {};
      for (var line in translationLines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split('|');
        if (parts.length < 3) continue;
        final key = '${parts[0]}|${parts[1]}';
        _translationMap[key] = parts[2];
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
          'tafsir': _tafsirMap[mapKey] ?? '',
          'translation': _translationMap[mapKey] ?? '',
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

  void _showNextAyah() {
    if (_currentAyah < _pageAyahs.length) {
      setState(() {
        final nextAyah = _pageAyahs[_currentAyah];
        _currentAyahData.add(nextAyah);
        _currentAyah++;
        widget.onAyahChanged(_currentAyah);
      });

      if (_autoPlayEnabled) {
        _playAudio(_pageAyahs[_currentAyah - 1]['surah'],
            _pageAyahs[_currentAyah - 1]['ayah']);
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
            icon: Icon(Icons.arrow_back_ios),
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
            icon: Icon(Icons.arrow_forward_ios),
            onPressed:
                widget.pageNumber < 604 ? () => _navigateToNextPage() : null,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF2F4F3),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children:
                      _groupAyahsBySurah(_currentAyahData).entries.map((entry) {
                    final surahNumber = entry.key;
                    final surahAyahs = entry.value;

                    return Align(
                      alignment: Alignment.topLeft,
                      child: Card(
                        margin: EdgeInsets.all(getHorizontalPadding() * 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
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
                                  offset: Offset(5, 5),
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                              color: Color(0xFF2B4141),
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
                                                    : Icons.repeat_one_outlined,
                                                color: _autoPlayEnabled
                                                    ? Color(0xFF417D7A)
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
                                                color: Color(0xFF417D7A),
                                              ),
                                              onPressed: _isPlaying
                                                  ? () {
                                                      _audioPlayer.pause();
                                                      setState(() {
                                                        _isPlaying = false;
                                                      });
                                                    }
                                                  : () => _playAudio(
                                                        surahAyahs
                                                            .last['surah'],
                                                        surahAyahs.last['ayah'],
                                                      ),
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
                                        color: Color(0xFF2B4141),
                                      ),
                                      children: surahAyahs
                                          .map((ayah) => TextSpan(
                                                children: [
                                                  TextSpan(text: ayah['verse']),
                                                  TextSpan(
                                                    text:
                                                        ' ۝${ayah['ayah'].toString().replaceAll('0', '٠').replaceAll('1', '١').replaceAll('2', '٢').replaceAll('3', '٣').replaceAll('4', '٤').replaceAll('5', '٥').replaceAll('6', '٦').replaceAll('7', '٧').replaceAll('8', '٨').replaceAll('9', '٩')} ',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Scheherazade',
                                                      fontSize:
                                                          getSymbolFontSize(),
                                                      color: Color(0xFF417D7A),
                                                      letterSpacing: 0,
                                                      height: 1.2,
                                                      textBaseline: TextBaseline
                                                          .alphabetic,
                                                    ),
                                                  ),
                                                ],
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                  if (surahAyahs.isNotEmpty) ...[
                                    Divider(
                                      height: getVerticalPadding() * 2,
                                      thickness: 1,
                                      color: Color(0xFF4F757C).withOpacity(0.3),
                                    ),
                                    // Tafsir
                                    Text(
                                      surahAyahs.last['tafsir'] ?? '',
                                      style: TextStyle(
                                        fontSize: getQuranFontSize() * 0.65,
                                        height: 1.5,
                                        color:
                                            Color(0xFF2B4141).withOpacity(0.8),
                                      ),
                                      textAlign: TextAlign.justify,
                                      textDirection: TextDirection.rtl,
                                    ),
                                    SizedBox(
                                        height: getVerticalPadding() * 0.5),
                                    // Translation
                                    Text(
                                      surahAyahs.last['translation'] ?? '',
                                      style: TextStyle(
                                        fontSize: getQuranFontSize() * 0.65,
                                        height: 1.5,
                                        color:
                                            Color(0xFF2B4141).withOpacity(0.8),
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
    );
  }
}
