import 'package:flutter/material.dart';
import 'package:travelmate/service/weather_notification_service.dart';
import 'package:travelmate/splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WeatherNotificationService.init();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Flutter Demo',
      home: Splashscreen(),
    );
  }
}


