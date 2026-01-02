class WeatherModel {
  final double temp;
  final double feelsLike;
  final String description;
  final String city;

  WeatherModel({
    required this.temp,
    required this.feelsLike,
    required this.description,
    required this.city,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temp: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      description: json['weather'][0]['main'],
      city: json['name'],
    );
  }
}
