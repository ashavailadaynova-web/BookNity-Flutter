import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Set default ke index 3 supaya aplikasi langsung mengarah ke halaman profil saat dibuka
  int _currentIndex = 3; 

  // Daftar halaman utama aplikasi Booknity
  final List<Widget> _screens = [
    const Center(child: Text("Halaman Home (Segera Hadir)")),
    const Center(child: Text("Halaman My Order (Segera Hadir)")),
    const Center(child: Text("Halaman Notifikasi (Segera Hadir)")),
    const ProfileScreen(), // Halaman profil murni tanpa komponen navbar di dalamnya
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
        // Mengatur padding bawaan BottomAppBar menjadi 0 agar tidak membuat navbar double/terlalu tinggi
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