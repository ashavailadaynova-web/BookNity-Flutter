import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_application_1/view/Beranda/home_screen.dart';
import 'package:flutter_application_1/view/Pesanan/pesanan_screen.dart';
import 'package:flutter_application_1/view/Profile/profile_screen.dart'; // Menyesuaikan dengan sub-folder Profile terbarumu

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Default diatur ke index 0 (Halaman Home) agar saat pertama kali masuk, 
  // aplikasi langsung memuat Beranda utama Booknity.
  int _currentIndex = 0; 

  // Daftar halaman utama aplikasi Booknity yang sudah digabungkan secara utuh
  final List<Widget> _screens = [
    const HomeScreen(),      // Index 0: Halaman Beranda dari tim kelompok
    const PesananScreen(),   // Index 1: Halaman Daftar Pesanan (Koki/Controller)
    const Center(child: Text("Halaman Notifikasi (Segera Hadir)")), // Index 2
    const ProfileScreen(),   // Index 3: Halaman Profil asli buatanmu (Bukan teks placeholder lagi)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan extendBody agar konten halaman bisa bergulir mulus di belakang lengkungan navbar
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      
      // Floating Action Button (FAB) tombol tambah (+) di tengah menjorok ke dalam Navbar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi untuk menambah buku baru
        },
        backgroundColor: const Color(0xFFB13D14),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),

      // Perbaikan Struktur Bottom Navigation Bar agar tidak memicu double layout/garis ganda
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        // Mengatur padding bawaan BottomAppBar menjadi 0 agar tidak membuat navbar double/terlahu tinggi
        padding: EdgeInsets.zero, 
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 60,
          // Memberikan garis pembatas atas yang tipis dan bersih gantiin border bawaan yang sering nge-bug
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: _buildNavItem(Icons.home_filled, "HOME", 0)),
              Expanded(child: _buildNavItem(Icons.menu_book_rounded, "MY ORDER", 1)),
              const SizedBox(width: 48), // Jeda ruang kosong pas di bawah tombol FAB (+) tengah
              Expanded(child: _buildNavItem(Icons.notifications_outlined, "NOTIFIKASI", 2)),
              Expanded(child: _buildNavItem(Icons.person, "PROFIL", 3)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = _currentIndex == index;
    final activeColor = const Color(0xFFB13D14);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? activeColor : Colors.black, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: isActive ? activeColor : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}