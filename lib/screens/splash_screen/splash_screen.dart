import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/screens/home_flow/home_page.dart';
import 'package:holy_bible_tamil/screens/home_flow/settings_page.dart';
import 'package:holy_bible_tamil/service.dart/theme_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    navigateToPages();
  }

  navigateToPages() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    Future.delayed(Duration(seconds: 3), () async {
      bool stat = await ThemeService.getFirstTime();
      if (stat) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with scale animation
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                "assets/app_logo_.png",
                width: 120,
              ),
            ),

            const SizedBox(height: 20),

            // English text
            const Text(
              "Word is God and God is Word",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            // Tamil text
            const Text(
              "வார்த்தையே கடவுள், கடவுள்தான் வார்த்தை.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'NotoSansTamil', // Optional: use Tamil font
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
