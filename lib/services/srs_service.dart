import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard_model.dart';

class SRSService {
  static final SRSService _instance = SRSService._internal();

  factory SRSService() => _instance;

  SRSService._internal();

  Future<void> scheduleCard(String cardId, int easeFactor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> cardData = await getCardData(cardId);

    // Update card scheduling data based on easeFactor
    // Simplified SM-2 algorithm
    int interval = cardData['interval'] ?? 1;
    double ef = cardData['ef'] ?? 2.5;

    ef = ef + (0.1 - (5 - easeFactor) * (0.08 + (5 - easeFactor) * 0.02));
    if (ef < 1.3) ef = 1.3;

    if (easeFactor < 3) {
      interval = 1;
    } else if (interval == 1) {
      interval = 6;
    } else {
      interval = (interval * ef).round();
    }

    cardData['interval'] = interval;
    cardData['ef'] = ef;
    cardData['nextReview'] =
        DateTime.now().add(Duration(days: interval)).toIso8601String();

    // Remove from unknown ayahs if interval is large enough
    if (cardData['interval'] >= 21) {
      // You can adjust the threshold
      // Remove from unknown_ayahs
      List<String> unknownAyahs = prefs.getStringList('unknown_ayahs') ?? [];
      unknownAyahs.removeWhere((entry) => entry.contains(cardId));
      await prefs.setStringList('unknown_ayahs', unknownAyahs);
    }
    // Save updated card data
    await prefs.setString('card_$cardId', json.encode(cardData));
  }

  Future<Map<String, dynamic>> getCardData(String cardId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cardDataStr = prefs.getString('card_$cardId');
    if (cardDataStr != null) {
      return Map<String, dynamic>.from(json.decode(cardDataStr));
    } else {
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getDueCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> dueCards = [];

    Set<String> keys = prefs.getKeys();

    for (String key in keys) {
      if (key.startsWith('card_')) {
        String? cardDataStr = prefs.getString(key);
        if (cardDataStr != null) {
          Map<String, dynamic> cardData =
              Map<String, dynamic>.from(json.decode(cardDataStr));
          DateTime nextReview = DateTime.parse(
              cardData['nextReview'] ?? DateTime.now().toIso8601String());
          if (nextReview.isBefore(DateTime.now())) {
            dueCards.add(cardData);
          }
        }
      }
    }

    return dueCards;
  }
}
