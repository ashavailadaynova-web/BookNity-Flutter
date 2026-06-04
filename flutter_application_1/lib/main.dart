import 'dart:async'; // Ditambahkan agar objek 'Timer' tidak error lagi
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// --- BAGIAN IMPORT ONBOARDING & LOGIN (SUDAH DIPERBAIKI) ---
import 'package:flutter_application_1/view/Login%20Register/splash_screen.dart';
import 'package:flutter_application_1/view/Login%20Register/onboarding_splash.dart';
import 'package:flutter_application_1/view/Login%20Register/onboarding2_splash.dart';
import 'package:flutter_application_1/view/Login%20Register/onboarding3_splash.dart';
import 'package:flutter_application_1/view/Login%20Register/login_screen.dart';
import 'package:flutter_application_1/view/Login%20Register/register_screen.dart';

// Mengimpor halaman utama & fitur baru dari tim kelompok
import 'main_screen.dart';
import 'view/Beranda/home_screen.dart';
import 'view/Profile/profile_screen.dart';
import 'view/Profile/help_center_screen.dart';
import 'view/Notifikasi/notifikasi_screen.dart';
import 'view/Pesanan/payment_screen.dart';
import 'view/product_detail_screen.dart';

import 'viewmodel/pesanan_view_model.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); 
  
  runApp(
    // Kita bungkus di sini agar fitur transaksi bisa diakses di halaman mana pun
    ChangeNotifierProvider(
      create: (context) => PesananViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booknity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ), 
      home: const SplashScreen(),

      // Navigasi penamaan rute (routes) agar pemanggilan halaman kelompok lebih rapi
      routes: {
        '/main': (context) => const MainScreen(),
        '/onboarding_container': (context) => const MainOnboardingContainer(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/help_center': (context) => const HelpCenterScreen(),
        '/notification': (context) => const NotificationScreen(), 
        '/product_detail': (context) => const ProductDetailScreen(), 
      },
    );
  }
}

// Container Utama untuk menggeser halaman Onboarding secara otomatis/manual
class MainOnboardingContainer extends StatefulWidget {
  const MainOnboardingContainer({super.key}); // 👈 REVISI: Menggunakan format super.key yang modern

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
        // dan langsung pindah ke halaman RegisterScreen secara otomatis
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
        children: [
OnboardingScreen(), // Halaman 1
OnboardingScreen2(), // Halaman 2 (sementara)
OnboardingScreen3(), // Halaman 3 (sementara)
        ],
      ),
    );
  }
}