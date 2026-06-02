import 'dart:async'; // Ditambahkan agar objek 'Timer' tidak error lagi
import 'package:flutter/material.dart';

// Mengimpor semua halaman dari folder view milik tim
import 'view/main_screen.dart';
import 'view/splash_screen.dart';
import 'view/onboarding_splash.dart';
import 'view/onboarding2_splash.dart';
import 'view/onboarding3_splash.dart';
import 'view/login_screen.dart';
import 'view/register_screen.dart';
import 'view/home_screen.dart';

// Mengimpor halaman baru buatan Vina
import 'view/profile_screen.dart';
import 'view/help_center_screen.dart';

void main() {
  runApp(const MyApp());
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
      ), // MEMPERBAIKI ERROR: kurung tutup ThemeData yang hilang di kode asli timmu
      home: const SplashScreen(),
      
      // Ditambahkan navigasi penamaan rute agar pemanggilan halaman kelompok lebih rapi
      routes: {
        '/main': (context) => const MainScreen(),
        '/onboarding_container': (context) => const MainOnboardingContainer(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/help_center': (context) => const HelpCenterScreen(),
      },
    );
  }
}

// Container Utama untuk menggeser halaman Onboarding secara otomatis/manual
class MainOnboardingContainer extends StatefulWidget {
  const MainOnboardingContainer({Key? key}) : super(key: key);

  @override
  State<MainOnboardingContainer> createState() => _MainOnboardingContainerState();
}

class _MainOnboardingContainerState extends State<MainOnboardingContainer> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _onboardingTimer;

  @override
  void initState() {
    super.initState();
    // Mengatur geser otomatis setiap 4 detik
    _onboardingTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
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
    // MEMPERBAIKI ERROR: Properti 'home' tidak boleh berada di dalam Scaffold.
    // Navbar bawah ditaruh sebagai bottomNavigationBar, atau halaman utama dimasukkan ke children PageView.
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: const [
          OnboardingScreen(),  // Halaman 1 (Curated for you)
          OnboardingScreen2(), // Halaman 2 (Discover your next read)
          OnboardingScreen3(), // Halaman 3 (Buy and Sell)
        ],
      ),
    );
  }
}