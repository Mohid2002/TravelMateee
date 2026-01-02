import 'package:flutter/material.dart';
import 'package:travelmate/model/weather_model.dart';
import 'package:travelmate/service/weather_service.dart' show WeatherService;

class LahoreWeatherScreen extends StatelessWidget {
  const LahoreWeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lahore Weather"),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<WeatherModel>(
        // ✅ Pass actual coordinates
        future: WeatherService.getWeatherByLocation(31.5204, 74.3587),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load weather"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No weather data"));
          }

          final weather = snapshot.data!;

          return Center(
            child: Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wb_sunny,
                      size: 90, color: Colors.orange),
                  const SizedBox(height: 15),
                  Text(
                    weather.city,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${weather.temp.toStringAsFixed(1)}°C",
                    style: const TextStyle(
                        fontSize: 42, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weather.description,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Feels like ${weather.feelsLike.toStringAsFixed(1)}°C",
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
