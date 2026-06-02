import 'dart:async';
import 'package:flutter/material.dart';

// Mengimpor semua halaman dari folder view
// --- BAGIAN IMPORT YANG SUDAH DIPERBAIKI ---
import 'view/Login Register/splash_screen.dart';
import 'view/Login Register/onboarding_splash.dart';
import 'view/Login Register/onboarding2_splash.dart';
import 'view/Login Register/onboarding3_splash.dart';
import 'view/Login Register/login_screen.dart';
import 'view/Login Register/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booknity',
      // Halaman pertama yang dibuka tetap Splash Screen
      home: SplashScreen(),
    );
  }
}

// Container Utama untuk menggeser halaman Onboarding secara otomatis/manual
class MainOnboardingContainer extends StatefulWidget {
  const MainOnboardingContainer({Key? key}) : super(key: key);

  @override
  State<MainOnboardingContainer> createState() =>
      _MainOnboardingContainerState();
}

class _MainOnboardingContainerState extends State<MainOnboardingContainer> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _onboardingTimer;

  @override
  void initState() {
    super.initState();
    _onboardingTimer = Timer.periodic(const Duration(seconds: 4), (
      Timer timer,
    ) {
      if (_currentPage < 2) {
        _currentPage++;
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      } else {
        _onboardingTimer?.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _onboardingTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: const [
          OnboardingScreen(),
          OnboardingScreen2(),
          OnboardingScreen3(),
        ],
      ),
    );
  }
}
