import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodel/auth_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  // Logika penentu arah halaman
  Future<void> _startSplashScreen() async {
    // 🟢 REVISI 1: Tanda komentar dihapus agar Firebase menghapus sesi login lama kamu secara paksa
    await FirebaseAuth.instance.signOut();

    // Jalankan splash screen selama 3 detik agar estetik logo terlihat
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Panggil fungsi cek user ke AuthViewModel
    final authViewModel = context.read<AuthViewModel>();
    bool isLoggedIn = await authViewModel.checkCurrentUser();

    if (!mounted) return;

    // 🟢 REVISI 2: Kondisi dipaksa langsung masuk ke Onboarding Container untuk masa testing alur login
    Navigator.of(context).pushReplacementNamed('/onboarding_container');

    /* 🟡 Bagian ini dikomentari dulu agar tidak menembak beranda secara otomatis
    if (isLoggedIn) {
      // Jika sudah login: Langsung tembak ke Halaman Utama Kelompok
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      // Jika belum login / baru install: Arahkan ke Onboarding Container
      Navigator.of(context).pushReplacementNamed('/onboarding_container');
    }
    */
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
