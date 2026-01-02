import 'package:flutter/material.dart';
import 'package:travelmate/loginpage/loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/img1.png",
      "title": "Life is short and the world is wide",
      "subtitle":
          "As Friends tours and travel, we customize reliable and trustworthy educational tours to destinations all over the world.",
      "button": "Get Started"
    },
    {
      "image": "assets/img2.png",
      "title": "It’s a big world out there go explore",
      "subtitle":
          "To get the best of your adventure you just need to leave and go where you like, we are waiting for you.",
      "button": "Next"
    },
    {
      "image": "assets/img3.png",
      "title": "People don’t take trips, trips take people",
      "subtitle":
          "To get the best of your adventure you just need to leave and go where you like, we are waiting for you.",
      "button": "Next"
    },
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    width: width,
                    height: height * 0.6,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(onboardingData[index]["image"]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                width: width,
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06, vertical: height * 0.03),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            onboardingData[_currentPage]["title"]!,
                            key: ValueKey(_currentPage),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.015),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            onboardingData[_currentPage]["subtitle"]!,
                            key: ValueKey("sub$_currentPage"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: width * 0.04,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onboardingData.length,
                            (dotIndex) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: _currentPage == dotIndex ? 20 : 8,
                              decoration: BoxDecoration(
                                color: _currentPage == dotIndex
                                    ? Colors.blue
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        SizedBox(
                          width: double.infinity,
                          height: height * 0.065,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (_currentPage <
                                  onboardingData.length - 1) {
                                _pageController.nextPage(
                                  duration:
                                      const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              }
                            },
                            child: Text(
                              onboardingData[_currentPage]["button"]!,
                              style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}