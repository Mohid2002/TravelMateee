import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travelmate/model/weather_model.dart';

class WeatherService {
  static const String _apiKey = "879eaf43caaef36900491a7d34001eef";

  static Future<WeatherModel> getWeatherByLocation(
      double lat, double lon) async {
    final uri = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather"
      "?lat=$lat&lon=$lon&units=metric&appid=$_apiKey",
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Weather error ${response.statusCode}");
    }
  }
}

