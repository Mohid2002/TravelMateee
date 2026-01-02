import 'package:flutter/material.dart';
import 'dart:async';
import 'package:travelmate/onboardingscreen/onboardingscreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

  double fontSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: const Color(0xFF0A74FF),
      body: Center(
        child: Text(
          "TRAVEL MATE",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize, 
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: screenWidth * 0.002, // responsive spacing
          ),
        ),
      ),
    );
  }
}

