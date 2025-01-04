import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'dart:convert';

class SRSManager {
  static const String _prefsKey = 'srs_data';

  // Intervals in hours for each level (0-4)
  static const List<int> _intervals = [
    1,
    24,
    72,
    168,
    336
  ]; // 1h, 1d, 3d, 7d, 14d

  // Structure: {pageNumber: {ayahNumber: {level: int, nextReview: DateTime}}}
  static Map<String, Map<String, Map<String, dynamic>>> _srsData = {};

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString(_prefsKey);
    if (storedData != null) {
      final decoded = json.decode(storedData);
      _srsData = Map<String, Map<String, Map<String, dynamic>>>.from(
        decoded.map((key, value) => MapEntry(
              key,
              Map<String, Map<String, dynamic>>.from(
                value.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v))),
              ),
            )),
      );
    }
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, json.encode(_srsData));
  }

  static void addAyahForReview(int pageNumber, int ayahNumber) {
    final now = DateTime.now();
    final pageKey = pageNumber.toString();
    final ayahKey = ayahNumber.toString();

    _srsData.putIfAbsent(pageKey, () => {});
    _srsData[pageKey]![ayahKey] = {
      'level': 0,
      'nextReview': now.add(Duration(hours: _intervals[0])).toIso8601String(),
    };
    _save();
  }

  static void markAyahCorrect(int pageNumber, int ayahNumber) {
    final pageKey = pageNumber.toString();
    final ayahKey = ayahNumber.toString();

    if (_srsData[pageKey]?[ayahKey] != null) {
      final currentLevel = _srsData[pageKey]![ayahKey]!['level'] as int;
      if (currentLevel < _intervals.length - 1) {
        _srsData[pageKey]![ayahKey]!['level'] = currentLevel + 1;
        _srsData[pageKey]![ayahKey]!['nextReview'] = DateTime.now()
            .add(Duration(hours: _intervals[currentLevel + 1]))
            .toIso8601String();
      } else {
        // Ayah mastered, remove from review
        _srsData[pageKey]!.remove(ayahKey);
        if (_srsData[pageKey]!.isEmpty) {
          _srsData.remove(pageKey);
        }
      }
      _save();
    }
  }

  static void markAyahIncorrect(int pageNumber, int ayahNumber) {
    final pageKey = pageNumber.toString();
    final ayahKey = ayahNumber.toString();

    if (_srsData[pageKey]?[ayahKey] != null) {
      // Reset to level 0
      _srsData[pageKey]![ayahKey]!['level'] = 0;
      _srsData[pageKey]![ayahKey]!['nextReview'] =
          DateTime.now().add(Duration(hours: _intervals[0])).toIso8601String();
      _save();
    }
  }

  static Set<int> getDueAyahsForPage(int pageNumber) {
    final now = DateTime.now();
    final pageKey = pageNumber.toString();

    if (!_srsData.containsKey(pageKey)) return {};

    return _srsData[pageKey]!
        .entries
        .where((entry) {
          final nextReview = DateTime.parse(entry.value['nextReview']);
          return nextReview.isBefore(now);
        })
        .map((entry) => int.parse(entry.key))
        .toSet();
  }

  static Map<int, int> getReviewCountsForAllPages() {
    final now = DateTime.now();
    Map<int, int> counts = {};

    for (var pageEntry in _srsData.entries) {
      final pageNumber = int.parse(pageEntry.key);
      final dueCount = pageEntry.value.entries.where((ayahEntry) {
        final nextReview = DateTime.parse(ayahEntry.value['nextReview']);
        return nextReview.isBefore(now);
      }).length;

      if (dueCount > 0) {
        counts[pageNumber] = dueCount;
      }
    }

    return counts;
  }
}
