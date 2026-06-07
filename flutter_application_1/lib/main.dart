import 'dart:async'; // Ditambahkan agar objek 'Timer' tidak error lagi
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// --- BAGIAN IMPORT UTAMA, ONBOARDING & LOGIN ---
import 'package:flutter_application_1/main_screen.dart';
import 'package:flutter_application_1/view/Login%20Register/splash_screen.dart';
import 'package:flutter_application_1/view/Login%20Register/onboarding_splash.dart';
import 'package:flutter_application_1/view/Login%20Register/onboarding2_splash.dart';
import 'package:flutter_application_1/view/Login%20Register/onboarding3_splash.dart';
import 'package:flutter_application_1/view/Login%20Register/login_screen.dart';
import 'package:flutter_application_1/view/Login%20Register/register_screen.dart';

// --- BAGIAN IMPORT FITUR & VIEWMODEL ---
import 'view/Beranda/home_screen.dart';
import 'view/Profile/profile_screen.dart';
import 'view/Profile/help_center_screen.dart';
import 'view/Notifikasi/notifikasi_screen.dart';
import 'view/Pesanan/payment_screen.dart';
import 'view/product_detail_screen.dart';
import 'viewmodel/book_viewmodel.dart';
import 'viewmodel/pesanan_view_model.dart';
import 'viewmodel/auth_viewmodel.dart';
import 'viewmodel/address_viewmodel.dart';
import 'viewmodel/user_viewmodel.dart';
import 'viewmodel/chat_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PesananViewModel()),
        ChangeNotifierProvider(create: (_) => BookViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),

        ListenableProvider<ChatViewModel>(create: (_) => ChatViewModel()),
      ],
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
      theme: ThemeData(useMaterial3: true),

      // 🟢 KODE YANG DIUBAH: Langsung arahkan ke SplashScreen agar tidak langsung loncat ke Beranda
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

        // 🟢 CATATAN: Rute '/product_detail' sengaja DIHAPUS dari sini agar tidak eror const.
        // Proses perpindahan ke halaman detail produk sekarang menggunakan MaterialPageRoute langsung di dalam widget kartu produk (onTap).
      },
    );
  }
}

// Container Utama untuk menggeser halaman Onboarding secara otomatis/manual
class MainOnboardingContainer extends StatefulWidget {
  const MainOnboardingContainer({super.key});

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
        // dan langsung pindah ke halaman LoginScreen secara otomatis
        _onboardingTimer?.cancel();
        Navigator.of(context).pushReplacementNamed('/login');
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
          OnboardingScreen(),  // Halaman 1
          OnboardingScreen2(), // Halaman 2
          OnboardingScreen3(), // Halaman 3
        ],
      ),
    );
  }
}