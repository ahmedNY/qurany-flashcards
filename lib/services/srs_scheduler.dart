import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/srs_item.dart';
import 'notification_service.dart';

class SRSScheduler {
  // Singleton pattern
  static final SRSScheduler _instance = SRSScheduler._internal();
  factory SRSScheduler() => _instance;
  static const String _storageKey = 'srs_items';

  SRSScheduler._internal() {
    _loadItems();
    _notificationService.init();
  }

  final Map<int, Set<SRSItem>> _itemsByPage = {};

  // Review intervals (in minutes)
  final List<int> _intervals = [
    2, // 2 minute
    5, // 5 minutes
    30, // 30 minutes
    120, // 2 hours
    360, // 6 hours
    720, // 12 hours
    1440, // 1 day
    2880, // 2 days
    5760, // 4 days
    10080, // 1 week
    20160, // 2 weeks
    43200, // 1 month
    86400, // 2 months
    172800, // 4 months
    345600, // 8 months
    525600, // 1 year
    1051200, // 2 years
  ];

  final _notificationService = NotificationService();

  // Load items from storage
  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedItems = prefs.getString(_storageKey);

    if (storedItems != null) {
      final Map<String, dynamic> data = json.decode(storedItems);
      _itemsByPage.clear();

      data.forEach((key, value) {
        final pageNumber = int.parse(key);
        final items =
            (value as List).map((item) => SRSItem.fromJson(item)).toSet();
        _itemsByPage[pageNumber] = items;
      });
    }
  }

  // Save items to storage
  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> data = {};

    _itemsByPage.forEach((key, value) {
      data[key.toString()] = value.map((item) => item.toJson()).toList();
    });

    await prefs.setString(_storageKey, json.encode(data));
  }

  // Add new items to track
  void addItems(int pageNumber, Set<int> ayahNumbers) async {
    print('SRS: Adding items for page $pageNumber: $ayahNumbers');

    final items = ayahNumbers.map((ayah) => SRSItem(
          pageNumber: pageNumber,
          ayahNumber: ayah,
          nextReview: DateTime.now(),
        ));

    _itemsByPage.putIfAbsent(pageNumber, () => {});
    _itemsByPage[pageNumber]!.addAll(items);

    await _saveItems();
    print(
        'SRS: Current items for page $pageNumber: ${_itemsByPage[pageNumber]}');
  }

  // Mark item as reviewed with improved level handling
  void markReviewed(int pageNumber, int ayahNumber, bool wasCorrect) async {
    print(
        'SRS: Marking review for page $pageNumber, ayah $ayahNumber (correct: $wasCorrect)');

    _itemsByPage.putIfAbsent(pageNumber, () => {});
    final items = _itemsByPage[pageNumber]!;

    // Find all items with this ayah number
    final matchingItems =
        items.where((item) => item.ayahNumber == ayahNumber).toList();

    if (wasCorrect) {
      // If correct, remove all duplicate entries and update the level of the remaining one
      if (matchingItems.isNotEmpty) {
        items.removeWhere((item) => item.ayahNumber == ayahNumber);
        final newItem = SRSItem(
          pageNumber: pageNumber,
          ayahNumber: ayahNumber,
          consecutiveCorrect: 1,
          level: (matchingItems[0].level + 1).clamp(0, _intervals.length - 1),
          nextReview: DateTime.now()
              .add(Duration(minutes: _intervals[matchingItems[0].level + 1])),
        );
        items.add(newItem);
      }
    } else {
      // If incorrect, add a new entry
      final newItem = SRSItem(
        pageNumber: pageNumber,
        ayahNumber: ayahNumber,
        nextReview: DateTime.now(),
      );
      items.add(newItem);
    }

    await _saveItems();
    await mergeDuplicateItems(); // Clean up any remaining duplicates

    // Schedule notification for the next review
    final updatedItem =
        items.firstWhere((item) => item.ayahNumber == ayahNumber);
    await _notificationService.scheduleReviewNotification(
      pageNumber,
      ayahNumber,
      updatedItem.nextReview!,
    );
  }

  // Enhanced getDueItems to handle multiple records and priorities
  Set<int> getDueItems(int pageNumber) {
    final now = DateTime.now();
    final items = _itemsByPage[pageNumber] ?? {};

    // Get all due items with enhanced priority calculation
    final dueItems = items
        .where((item) => item.nextReview?.isBefore(now) ?? false)
        .map((item) {
      final overdueDuration = now.difference(item.nextReview!);
      final overdueHours = overdueDuration.inHours;

      // Enhanced priority calculation
      double priority = overdueDuration.inMinutes.toDouble();

      // Increase priority for:
      // 1. Lower level items (newer or recently failed items)
      priority *= (1 + (_intervals.length - item.level) / _intervals.length);

      // 2. Severely overdue items (more than 24 hours)
      if (overdueHours > 24) {
        priority *= 1.5;
      }

      // 3. Items with low consecutive correct answers
      if (item.consecutiveCorrect < 2) {
        priority *= 1.2;
      }

      return {
        'ayahNumber': item.ayahNumber,
        'overdue': overdueDuration.inMinutes,
        'level': item.level,
        'priority': priority,
        'consecutiveCorrect': item.consecutiveCorrect,
      };
    }).toList()
      ..sort((a, b) => (b['priority']! - a['priority']!).round());

    return dueItems.map((item) => item['ayahNumber'] as int).toSet();
  }

  // Get count of due items per page
  Map<int, int> getDueItemCounts() {
    final counts = <int, int>{};

    _itemsByPage.forEach((pageNumber, items) {
      final dueCount = getDueItems(pageNumber).length;
      if (dueCount > 0) {
        counts[pageNumber] = dueCount;
      }
    });

    // print('SRS: Due item counts by page: $counts');
    return counts;
  }

  // Add this method to SRSScheduler class
  String? getNextReviewDateTime(int pageNumber) {
    final items = _itemsByPage[pageNumber] ?? {};
    if (items.isEmpty) return null;

    final nextReview = items
        .map((item) => item.nextReview)
        .where((date) => date != null)
        .reduce((a, b) => a!.isBefore(b!) ? a : b);

    return nextReview
        ?.toString()
        .split('.')[0]
        .substring(0, 16); // YYYY-MM-DD HH:mm
  }

  // Add this method to check for scheduled reviews
  bool hasScheduledReviews(int pageNumber) {
    final items = _itemsByPage[pageNumber] ?? {};
    return items.any((item) => item.nextReview != null);
  }

  int getLevel(int pageNumber, int ayah) {
    final items = _itemsByPage[pageNumber] ?? {};
    final item = items.firstWhere(
      (item) => item.ayahNumber == ayah,
      orElse: () => SRSItem(pageNumber: pageNumber, ayahNumber: ayah, level: 0),
    );
    return item.level;
  }

  int getFirstScheduledAyah(int pageNumber) {
    final items = _itemsByPage[pageNumber] ?? {};
    return items.isEmpty ? 1 : items.first.ayahNumber;
  }

  // Add this method to SRSScheduler class
  Future<void> resetSchedule() async {
    _itemsByPage.clear();
    await _saveItems();
    print('SRS: Schedule reset completed');
  }

  // Add method to merge duplicate items
  Future<void> mergeDuplicateItems() async {
    bool hasChanges = false;

    for (final pageNumber in _itemsByPage.keys) {
      final items = _itemsByPage[pageNumber]!;
      final seenAyahs = <int>{};
      final duplicates = <SRSItem>{};

      for (final item in items) {
        if (seenAyahs.contains(item.ayahNumber)) {
          duplicates.add(item);
        } else {
          seenAyahs.add(item.ayahNumber);
        }
      }

      // Merge duplicates by keeping the one with the lower level
      for (final duplicate in duplicates) {
        final original = items.firstWhere((item) =>
            item.ayahNumber == duplicate.ayahNumber && item != duplicate);

        // Keep the more conservative (lower) level
        original.level = min(original.level, duplicate.level);
        // Keep the earlier review time
        original.nextReview = [original.nextReview, duplicate.nextReview]
            .where((date) => date != null)
            .reduce((a, b) => a!.isBefore(b!) ? a : b);

        items.remove(duplicate);
        hasChanges = true;
      }
    }

    if (hasChanges) {
      await _saveItems();
      print('SRS: Merged duplicate items');
    }
  }
}
