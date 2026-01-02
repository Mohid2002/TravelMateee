import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SuggestedPlaces extends StatefulWidget {
  const SuggestedPlaces({super.key});

  @override
  State<SuggestedPlaces> createState() => _SuggestedPlacesState();
}

class _SuggestedPlacesState extends State<SuggestedPlaces> {
  List<Map<String, dynamic>> allPlaces = [];
  String? selectedInterest;
  final TextEditingController budgetCTRL = TextEditingController();
  int? selectedWeather;

  List<Map<String, dynamic>> filteredPlaces = [];
  bool showResults = false;
  bool isLoading = false;
  bool hasError = false;

  final Map<int, String> weathers = {
    0: "clear sky",
    1: "mainly clear",
    2: "partly cloudy",
    3: "overcast",
    45: "fog",
    48: "depositing rime fog",
    51: "light drizzle",
    53: "moderate drizzle",
    55: "dense drizzle",
    56: "freezing drizzle",
    57: "dense freezing drizzle",
    61: "slight rain",
    63: "moderate rain",
    65: "heavy rain",
    66: "freezing rain",
    67: "heavy freezing rain",
    71: "slight snow",
    73: "moderate snow",
    75: "heavy snow",
    77: "snow grains",
    80: "rain showers",
    81: "heavy rain showers",
    82: "violent rain showers",
    85: "snow showers",
    86: "heavy snow showers",
    95: "thunderstorm",
    96: "thunderstorm with hail",
    99: "heavy thunderstorm with hail"
  };

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchPlaces() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    final url = Uri.parse("http://192.168.0.103:5000/api/travel/recommend");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "interest": selectedInterest ?? "historical",
          "budget": double.tryParse(budgetCTRL.text) ?? 9999999,
          "weather_code": selectedWeather ?? 0,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          List<Map<String, dynamic>> placesList = [];
          for (var cityData in data["prediction"]) {
            for (var place in cityData["recommended_places"]) {
              placesList.add({
                "title": place,
                "city": cityData["city"],
                "weather_code": cityData["city_weather_code"],
                "image": "assets/placeholder.png", // default image, replace with backend URL if available
              });
            }
          }

          setState(() {
            allPlaces = placesList;
            filteredPlaces = List.from(allPlaces);
            showResults = true;
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            showResults = true;
            allPlaces = [];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          showResults = true;
          allPlaces = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching places: $e");
      setState(() {
        hasError = true;
        showResults = true;
        allPlaces = [];
        isLoading = false;
      });
    }
  }

  void filterPlaces() {
    double maxBudget = double.tryParse(budgetCTRL.text) ?? 9999999;

    setState(() {
      filteredPlaces = allPlaces.where((place) {
        if (selectedInterest != null &&
            !place["title"].toString().toLowerCase().contains(selectedInterest!.toLowerCase())) return false;
        if (selectedWeather != null && place["weather_code"] != selectedWeather) return false;
        return true;
      }).toList();
      showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(child: showResults ? buildResults(width) : buildForm(width)),
          ],
        ),
      ),
    );
  }

  Widget buildForm(double width) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Your Interest",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ["historical", "nature", "cultural", "adventure"].map((e) {
              bool isSelected = selectedInterest == e;
              return ChoiceChip(
                label: Text(e),
                selected: isSelected,
                onSelected: (_) => setState(() => selectedInterest = e),
                selectedColor: Colors.blue.shade700,
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text("Enter Maximum Budget (PKR)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          textField("Budget", budgetCTRL),
          const SizedBox(height: 20),
          Text("Select Weather Preference",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButton<int>(
            value: selectedWeather,
            hint: Text("Any Weather"),
            isExpanded: true,
            items: [
              DropdownMenuItem<int>(
                value: null,
                child: Text("Any Weather"),
              ),
              ...weathers.entries.map((entry) => DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  ))
            ],
            onChanged: (value) {
              setState(() {
                selectedWeather = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: fetchPlaces,
                    icon: const Icon(Icons.search),
                    label: const Text("Show Recommendations"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildResults(double width) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 10),
            const Text("Failed to fetch places 😞",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchPlaces,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (filteredPlaces.isEmpty) {
      return const Center(
        child: Text("No places match your preference 😢",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );
    }

    return GridView.builder(
      itemCount: filteredPlaces.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width < 600 ? 2 : 3,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (_, i) => placeCard(filteredPlaces[i]),
    );
  }

  Widget placeCard(Map<String, dynamic> place) {
    return Container(
      margin: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black26,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Image background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(place["image"] ?? "assets/placeholder.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.25), Colors.black.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Text info
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place["title"] ?? "Unknown",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [Shadow(blurRadius: 3, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    place["city"] ?? "Unknown City",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Weather: ${weathers[place["weather_code"]] ?? "Unknown"}",
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
