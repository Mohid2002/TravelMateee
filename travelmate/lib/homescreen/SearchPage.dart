import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<Map<String, String>> places = [
    {"title": "Badshahi Mosque", "location": "Lahore, Pakistan", "image": "assets/badshai.png"},
    {"title": "Lahore Fort", "location": "Lahore, Pakistan", "image": "assets/Lahore_Fort.png"},
    {"title": "Shalimar Gardens", "location": "Lahore, Pakistan", "image": "assets/shalimar.png"},
    {"title": "Wazir Khan Mosque", "location": "Lahore, Pakistan", "image": "assets/wazir_khan.png"},
    {"title": "Sheesh Mahal", "location": "Lahore, Pakistan", "image": "assets/sheeshmahal.png"},
    {"title": "Minar-e-Pakistan", "location": "Lahore, Pakistan", "image": "assets/Minar-e-Pakistan.png"},
    {"title": "Data Darbar", "location": "Lahore, Pakistan", "image": "assets/datadarbar.png"},
    {"title": "Faisal Mosque", "location": "Islamabad, Pakistan", "image": "assets/faisal_mosque.png"},
    {"title": "Lok Virsa Museum", "location": "Islamabad, Pakistan", "image": "assets/LokVirsaMuseum.png"},
    {"title": "Saidpur Village", "location": "Islamabad, Pakistan", "image": "assets/SaidpurVillage.png"},
    {"title": "Margalla Hills", "location": "Islamabad, Pakistan", "image": "assets/Margalla Hills.png"},
    {"title": "Rawal Lake", "location": "Islamabad, Pakistan", "image": "assets/Rawal Lake.png"},
    {"title": "Daman-e-Koh", "location": "Islamabad, Pakistan", "image": "assets/Daman-e-Koh.png"},
    {"title": "Hunza Valley", "location": "Gilgit-Baltistan, Pakistan", "image": "assets/hunza.png"},
    {"title": "Fairy Meadows", "location": "Gilgit-Baltistan, Pakistan", "image": "assets/feary.png"},
    {"title": "Skardu", "location": "Gilgit-Baltistan, Pakistan", "image": "assets/Skardu.png"},
    {"title": "Deosai Plains", "location": "Skardu, Pakistan", "image": "assets/Deosai Plains.png"},
    {"title": "K2 Base Camp", "location": "Skardu, Pakistan", "image": "assets/K2 Base Camp.png"},
    {"title": "Naltar Valley", "location": "Gilgit, Pakistan", "image": "assets/Naltar Valley.png"},
    {"title": "Khunjerab Pass", "location": "Hunza, Pakistan", "image": "assets/Khunjerab Pass.png"},
    {"title": "Rakaposhi Base Camp", "location": "Nagar, Pakistan", "image": "assets/Rakaposhi Base Camp.png"},
    {"title": "Swat Valley", "location": "KPK, Pakistan", "image": "assets/swat.png"},
    {"title": "Quaid-e-Azam Mausoleum", "location": "Karachi, Pakistan", "image": "assets/Quaid.png"},
  ];

  List<Map<String, String>> filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    filteredPlaces = places;
  }

  void _filterSearch(String query) {
    setState(() {
      filteredPlaces = places
          .where((place) =>
              place["title"]!.toLowerCase().contains(query.toLowerCase()) ||
              place["location"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Search Places", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: TextField(
                onChanged: _filterSearch,
                decoration: const InputDecoration(
                  hintText: "Search by place or city...",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            SizedBox(height: height * 0.025),
            Expanded(
              child: filteredPlaces.isEmpty
                  ? const Center(
                      child: Text(
                        'No matching places found',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredPlaces.length,
                      itemBuilder: (context, index) {
                        final place = filteredPlaces[index];
                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          margin: EdgeInsets.only(bottom: height * 0.015),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
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
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(place["location"]!),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
