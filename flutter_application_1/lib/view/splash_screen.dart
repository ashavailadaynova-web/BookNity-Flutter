import 'dart:async';
import 'package:flutter/material.dart';
// 1. WAJIB IMPORT main.dart agar MainOnboardingContainer bisa dikenali
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Mengatur timer selama 3 detik sebelum pindah
    Timer(const Duration(seconds: 6), () {
      // 2. GANTI NextScreen() menjadi MainOnboardingContainer()
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainOnboardingContainer(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF2),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Image.asset(
            'assets/logo.png',
            width: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
