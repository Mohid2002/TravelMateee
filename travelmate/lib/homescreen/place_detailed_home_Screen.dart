import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travelmate/homescreen/calander_schedule.dart';
import 'package:travelmate/homescreen/trip_model.dart';
import 'package:travelmate/service/weather_service.dart';
import 'package:travelmate/model/weather_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class PlaceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> place;

  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final translator = GoogleTranslator();

  String urduHistory = "";
  bool isUrdu = false;

  // 🌍 Open Google Maps
  void _openMap(String location) async {
    final Uri url =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$location");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // 🔊 Speak function
  Future<void> _speak(String text, String languageCode) async {
    await flutterTts.stop();
    await flutterTts.setLanguage(languageCode);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }

  Future<void> _getUrduText() async {
    if (urduHistory.isEmpty) {
      final translation = await translator.translate(widget.place['history'], to: 'ur');
      urduHistory = translation.text;
    }
  }

  void _speakEnglish() => _speak(widget.place['history'], "en-US");

  Future<void> _speakUrdu() async {
    await _getUrduText();
    _speak(urduHistory, "ur-PK");
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case "clouds":
        return FontAwesomeIcons.cloud;
      case "rain":
        return FontAwesomeIcons.cloudRain;
      case "clear":
        return FontAwesomeIcons.sun;
      case "snow":
        return FontAwesomeIcons.snowflake;
      default:
        return FontAwesomeIcons.cloudSun;
    }
  }

  Color _getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case "clouds":
        return Colors.blueGrey.shade200;
      case "rain":
        return Colors.blue.shade200;
      case "clear":
        return Colors.orange.shade100;
      case "snow":
        return Colors.blue.shade100;
      default:
        return Colors.orange.shade50;
    }
  }

  bool _isNight() {
    final hour = DateTime.now().hour;
    return hour < 6 || hour > 18;
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // ✅ Get lat/lon safely (default Lahore)
    final double lat = (widget.place['lat'] ?? 31.5880).toDouble();
    final double lon = (widget.place['lon'] ?? 74.3109).toDouble();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Image
          SizedBox(
            height: height * 0.4,
            width: double.infinity,
            child: Image.asset(
              widget.place['imageUrl'],
              fit: BoxFit.cover,
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Bottom Section
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height * 0.6,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.place['name'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                          const SizedBox(width: 4),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: width * 0.35),
                            child: Text(
                              widget.place['location'],
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: const TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // English + Urdu buttons
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _speakEnglish,
                        child: Row(
                          children: const [
                            Icon(Icons.play_circle_fill, color: Colors.blue, size: 20),
                            SizedBox(width: 4),
                            Text("Eng Voice", style: TextStyle(fontSize: 14, color: Colors.blue)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: _speakUrdu,
                        child: Row(
                          children: const [
                            Icon(Icons.play_circle_fill, color: Colors.green, size: 20),
                            SizedBox(width: 4),
                            Text("Urdu Voice", style: TextStyle(fontSize: 14, color: Colors.green)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // History Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("History", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () async {
                          if (!isUrdu) {
                            await _getUrduText();
                            setState(() => isUrdu = true);
                          } else {
                            setState(() => isUrdu = false);
                          }
                        },
                        child: Text(isUrdu ? "English" : "اردو", style: const TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        isUrdu ? urduHistory : widget.place['history'],
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Weather + Map
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Weather Container
                      FutureBuilder<WeatherModel>(
                        future: WeatherService.getWeatherByLocation(lat, lon),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              width: width * 0.4,
                              height: width * 0.25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.orange.shade200, width: 1),
                              ),
                              child: const CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError || snapshot.data == null) {
                            return Container(
                              width: width * 0.4,
                              height: width * 0.25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.orange.shade200, width: 1),
                              ),
                              child: const Text("Weather error"),
                            );
                          } else {
                            final weather = snapshot.data!;
                            final condition = weather.description;
                            final isNight = _isNight();

                            return Container(
                              width: width * 0.4,
                              height: width * 0.25,
                              decoration: BoxDecoration(
                                color: isNight ? Colors.indigo.shade200 : _getWeatherColor(condition),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(_getWeatherIcon(condition), color: isNight ? Colors.white : Colors.orange, size: 24),
                                  const SizedBox(height: 6),
                                  Text("${weather.temp.toStringAsFixed(1)}°C | ${weather.description}", style: TextStyle(color: isNight ? Colors.white : Colors.black87)),
                                ],
                              ),
                            );
                          }
                        },
                      ),

                      // Map Button
                      GestureDetector(
                        onTap: () => _openMap(widget.place['location']),
                        child: Container(
                          width: width * 0.4,
                          height: width * 0.25,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.blue.shade200, width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.map, color: Colors.blueAccent, size: 24),
                              SizedBox(height: 6),
                              Text("Get Directions", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Schedule Trip
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
  DateTime now = DateTime.now();

  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: now,
    lastDate: DateTime(now.year + 5),
  );

  if (pickedDate != null) {
    savedTrips.add(
      TripModel(
        image: widget.place['imageUrl'],
        name: widget.place['name'],
        location: widget.place['location'],
        date: pickedDate,
        history: widget.place['history'], // ✅ REQUIRED
        lat: (widget.place['lat'] ?? 31.5880).toDouble(), // ✅ REQUIRED
        lon: (widget.place['lon'] ?? 74.3109).toDouble(), // ✅ REQUIRED
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CalendarSchedule(),
      ),
    );
  }
},
                      child: const Text("Schedule a Trip", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
