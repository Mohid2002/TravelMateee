import 'package:flutter/material.dart';
import 'package:travelmate/homescreen/map_screen.dart';
import 'home_page.dart';
import 'places/hot_places.dart';
import 'profile.dart';
import 'safe_places.dart';

class TravelHomeScreen extends StatefulWidget {
  const TravelHomeScreen({super.key});

  @override
  State<TravelHomeScreen> createState() => _TravelHomeScreenState();
}

class _TravelHomeScreenState extends State<TravelHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    PlacesScreen(),
    SavedPlaces(),
    EditProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Home", 0, screenWidth),
            _buildNavItem(Icons.hiking, "Hot Places", 1, screenWidth),

            // 🗺️ Map icon with navigation
            InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          destLat: 31.5880,    // Default lat if no specific place
          destLon: 74.3109,    // Default lon
          destName: "Default Location",
        ),
      ),
    );
  },
  child: Container(
    padding: EdgeInsets.all(screenWidth * 0.035),
    decoration: const BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
    ),
    child: Icon(
      Icons.place,
      color: Colors.white,
      size: screenWidth * 0.07,
    ),
  ),
),


            _buildNavItem(Icons.bookmark_add, "Saved", 2, screenWidth),
            _buildNavItem(Icons.person, "Profile", 3, screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, int index, double screenWidth) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey,
            size: screenWidth * 0.065,
          ),
          SizedBox(height: screenWidth * 0.01),
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
