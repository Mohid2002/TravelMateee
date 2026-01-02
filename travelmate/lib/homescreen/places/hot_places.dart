import 'package:flutter/material.dart';
import 'package:travelmate/homescreen/places/popular_places.dart';
import 'suggested_places.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  int _selectedIndex = 0;

  // ✅ Removed const from the list
  final List<Widget> _pages = [
    PopularPlacesPage(),
    SuggestedPlaces(),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.10),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.only(top: height * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTopTab("Popular Places", 0, width),
                SizedBox(width: width * 0.05),
                _buildTopTab("Suggested Places", 1, width),
              ],
            ),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  Widget _buildTopTab(String title, int index, double width) {
    final bool isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
          SizedBox(height: width * 0.01),
          if (isSelected)
            Container(
              height: 3,
              width: width * 0.1,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
        ],
      ),
    );
  }
}
