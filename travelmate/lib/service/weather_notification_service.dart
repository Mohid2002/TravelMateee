import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:travelmate/service/weather_service.dart';

class WeatherNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// INIT (CALL IN main.dart)
  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);
  }

  /// ❌ CANCEL ALL NOTIFICATIONS
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// 🔔 PLACE BASED WEATHER NOTIFICATION
  static Future<void> scheduleHourlyWeather({
    required String placeName,
    required double lat,
    required double lon,
  }) async {
    await _notifications.cancelAll();

    final now = tz.TZDateTime.now(tz.local);

    for (int i = 1; i <= 12; i++) {
      final scheduledTime = now.add(Duration(hours: i));

      final weather = await WeatherService.getWeatherByLocation(lat, lon);

      await _notifications.zonedSchedule(
        i,
        "$placeName Weather 🌤",
        "${weather.temp.toStringAsFixed(1)}°C • ${weather.description}",
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'weather_channel',
            'Trip Weather',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}
