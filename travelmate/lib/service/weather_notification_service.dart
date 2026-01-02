import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:travelmate/service/weather_service.dart';

class WeatherNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// INIT
  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);
  }

  /// SCHEDULE HOURLY WEATHER (12 PM → 12 AM)
  static Future<void> scheduleHourlyLahoreWeather() async {
    await _notifications.cancelAll();

    final now = tz.TZDateTime.now(tz.local);

    // Start from 12 PM today
    tz.TZDateTime startTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      12,
    );

    // If already past 12 PM, start next hour
    if (now.isAfter(startTime)) {
      startTime = startTime.add(const Duration(hours: 1));
    }

    int notificationId = 0;

    // Schedule until 12 AM
    while (startTime.hour >= 12 && startTime.hour <= 23) {
      final weather =
          await WeatherService.getWeatherByLocation(31.5204, 74.3587);

      await _notifications.zonedSchedule(
        notificationId++,
        "Lahore Weather Update 🌤",
        "${weather.temp.toStringAsFixed(1)}°C • ${weather.description}",
        startTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'weather_channel',
            'Hourly Weather',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      startTime = startTime.add(const Duration(hours: 1));
    }
  }
}
