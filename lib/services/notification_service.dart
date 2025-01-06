import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    await notifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
  }

  Future<void> scheduleReviewNotification(
      int pageNumber, int ayahNumber, DateTime reviewTime) async {
    await notifications.zonedSchedule(
      pageNumber * 1000 + ayahNumber, // Unique ID for each ayah
      'Review Time',
      'Time to review Page $pageNumber, Ayah $ayahNumber',
      tz.TZDateTime.from(reviewTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'srs_reviews',
          'SRS Reviews',
          channelDescription: 'Notifications for Quran review schedule',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
