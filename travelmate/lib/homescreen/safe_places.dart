import 'package:flutter/material.dart';
import 'package:travelmate/homescreen/place_detailed_home_Screen.dart';
import 'package:travelmate/homescreen/safe_place_manager.dart';

class SavedPlaces extends StatefulWidget {
  const SavedPlaces({super.key});

  @override
  State<SavedPlaces> createState() => _SavedPlacesState();
}

class _SavedPlacesState extends State<SavedPlaces> {
  final manager = SavedPlacesManager();

  @override
  Widget build(BuildContext context) {
    final saved = manager.getSavedPlaces();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Saved Places",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: saved.isEmpty
          ? const Center(
              child: Text(
                "No Saved Places Yet",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: saved.length,
              itemBuilder: (context, index) {
                final place = saved[index];
                return GestureDetector(
                  onTap: () {
                    // ✅ Navigate to detail screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailScreen(
                          place: {
                            "name": place["title"],
                            "location": place["location"],
                            "imageUrl": place["image"],
                            "history": place["history"] ?? "No history available.",
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          place["image"]!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        place["title"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        place["location"]!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            manager.removePlace(place["title"]!);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${place["title"]} removed from Saved Places",
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
