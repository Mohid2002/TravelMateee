// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class WeatherService {
//   final String apiKey = "YOUR_API_KEY";

//   Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
//     final url =
//         "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$apiKey";

//     final response = await http.get(Uri.parse(url));
//     return jsonDecode(response.body);
//   }
// }
