import 'dart:async';
import 'package:flutter/material.dart';

// Mengimpor semua halaman dari folder view
import 'view/splash_screen.dart';
import 'view/onboarding_splash.dart';
import 'view/onboarding2_splash.dart';
import 'view/onboarding3_splash.dart';
import 'view/login_screen.dart';
import 'view/register_screen.dart';
import 'view/home_screen.dart';
import 'view/notifikasi_screen.dart';
import 'view/payment_screen.dart';

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
      home: PaymentScreen(),
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
    // Mengatur geser otomatis setiap 4 detik
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
        // Jika sudah di halaman onboarding terakhir (ke-3), matikan timer
        // dan langsung pindah ke halaman LoginScreen secara otomatis
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
          OnboardingScreen(), // Halaman 1 (Curated for you)
          OnboardingScreen2(), // Halaman 2 (Discover your next read)
          OnboardingScreen3(), // Halaman 3 (Buy and Sell)
        ],
      ),
    );
  }
}
