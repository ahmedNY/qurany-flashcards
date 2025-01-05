import 'package:flutter/material.dart';

class TajweedParser {
  static final Map<String, bool> tajweedColorToggles = {
    'necessary': true,
    'obligatory': true,
    'permissible': true,
    'normal': true,
    'silent': true,
    'emphatic': true,
    'qalqalah': true,
    'nasalization': true,
    'idgham': true,
    'wasl': true,
    'combined': true,
    'ahkam': true,
  };

  final Map<String, Color> tajweedColors = {
    // Prolongation Rules (Madd)
    'm': TajweedColor.darkRed, // Necessary prolongation (6 vowels) مد لازم
    'u': TajweedColor
        .bloodRed, // Obligatory prolongation (4-5 vowels) مد واجب متصل
    'o': TajweedColor
        .orangeRed, // Permissible prolongation (2,4,6 vowels) مد جائز منفصل
    'p': TajweedColor.orangeRed, // Normal prolongation (2 vowels) مد طبيعي

    // Silent Letters
    'l': TajweedColor.gray, // Silent letters (not pronounced) حروف لا تنطق
    's': TajweedColor.gray, // Sukun signs (سكون)

    // Emphatic Pronunciation
    'h': TajweedColor.darkBlue, // Emphatic R (ra) pronunciation تفخيم الراء
    'q': TajweedColor.lightBlue, // Qalqalah (echoing sound) قلقلة

    // Nasalization Rules
    'g': TajweedColor.green, // Ghunnah (nasalization) غنة
    'n': TajweedColor.green, // Nasalization marks
    'f': TajweedColor.green, // Ikhfa (hidden noon/tanween) إخفاء

    // Additional Rules
    'i':
        TajweedColor.teal, // Idgham (ادغام) - When a letter merges into another
    'w': TajweedColor.olive, // Wasl (وصل) - Connection rules between words
    'c': TajweedColor
        .indigo, // Combined letters (حروف مركبة) - Letters that combine in pronunciation
    'a': TajweedColor
        .brown, // Ahkam (احكام) - Special rules for specific letter combinations
  };

  static List<TextSpan> parseWordByWord(String verse, double fontSize) {
    List<TextSpan> wordSpans = [];
    List<String> words = verse.split(' ');

    for (String word in words) {
      wordSpans.add(parseTajweedText(word, fontSize));
      // Add space after each word except the last one
      if (word != words.last) {
        wordSpans.add(TextSpan(
          text: ' ',
          style: TextStyle(
            fontFamily: 'Scheherazade',
            fontSize: fontSize,
          ),
        ));
      }
    }

    return wordSpans;
  }

  static TextSpan parseTajweedText(String verse, double fontSize) {
    List<TextSpan> spans = [];
    RegExp regex = RegExp(r'\[(.*?)\[(.*?)\]|[^\[]+');

    for (Match match in regex.allMatches(verse)) {
      String text = match.group(0) ?? '';

      if (text.startsWith('[')) {
        // Extract tajweed rule and text
        RegExp ruleRegex = RegExp(r'\[(\w+):?(\d*)\[(.*?)\]');
        Match? ruleMatch = ruleRegex.firstMatch(text);

        if (ruleMatch != null) {
          String rule = ruleMatch.group(1) ?? '';
          String content = ruleMatch.group(3) ?? '';

          spans.add(TextSpan(
            text: content,
            style: TextStyle(
              color: TajweedParser().getColorForRule(rule),
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

  // Helper method to get specific words from verse
  static TextSpan parseWordsRange(String verse, double fontSize,
      {int startWord = 0, int? endWord}) {
    List<String> words = verse.split(' ');
    endWord ??= words.length;

    String selectedWords = words.sublist(startWord, endWord).join(' ');

    return parseTajweedText(selectedWords, fontSize);
  }

  // Get first word with tajweed
  static TextSpan parseFirstWord(String verse, double fontSize) {
    String firstWord = verse.split(' ')[0];
    return parseTajweedText(firstWord, fontSize);
  }

  static String stripTajweedMarks(String verse) {
    return verse.replaceAll(RegExp(r'\[.*?\[(.*?)\]'), '\$1');
  }

  // Add this method to check if a rule should be colored
  Color? getColorForRule(String rule) {
    if (!TajweedParser.tajweedColorToggles[getRuleKey(rule)]!) {
      return Colors.black;
    }
    return tajweedColors[rule];
  }

  // Helper method to map rule to toggle key
  String getRuleKey(String rule) {
    switch (rule) {
      case 'm':
        return 'necessary';
      case 'u':
        return 'obligatory';
      case 'o':
        return 'permissible';
      case 'p':
        return 'normal';
      case 'l':
      case 's':
        return 'silent';
      case 'h':
        return 'emphatic';
      case 'q':
        return 'qalqalah';
      case 'g':
      case 'n':
      case 'f':
        return 'nasalization';
      case 'i':
        return 'idgham';
      case 'w':
        return 'wasl';
      case 'c':
        return 'combined';
      case 'a':
        return 'ahkam';
      default:
        return 'normal';
    }
  }
}

class TajweedColor {
  // Red colors for prolongation
  static const Color darkRed =
      Color(0xFFB31919); // Necessary prolongation (6 vowels)
  static const Color bloodRed =
      Color(0xFFFF1E1E); // Obligatory prolongation (4-5 vowels)
  static const Color orangeRed =
      Color(0xFFFF7E1E); // Permissible prolongation (2,4,6 vowels)
  static const Color cuminRed =
      Color(0xFFE0331E); // Normal prolongation (2 vowels)

  // Gray for non-pronounced letters
  static const Color gray = Color(0xFF969696); // Letters not pronounced

  // Blue colors for emphatic pronunciation
  static const Color darkBlue =
      Color(0xFF1E33FF); // Emphatic R (ra) pronunciation
  static const Color lightBlue = Color(0xFF4682B4); // Qalqalah (echoing sound)

  // Green for nasalization
  static const Color green = Color(0xFF169200); // Nasalization (ghunnah)

  // Additional colors
  static const Color brown = Color(0xFF8B4513); // For special combinations
  static const Color teal = Color(0xFF008080); // For specific combinations
  static const Color indigo = Color(0xFF4B0082); // For connected rules
  static const Color olive = Color(0xFF808000); // For special connections
}
