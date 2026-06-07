import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'view/Pesanan/pesanan_screen.dart';
import 'view/Beranda/home_screen.dart';
import 'view/Profile/profile_screen.dart';

// 🔥 SESUAI STRUKTUR PROYEKMU: Mengimport halaman tambah produk/buku
import 'view/add_product_screen.dart';


class MainScreen extends StatefulWidget {
  final int selectedIndex;

  const MainScreen({super.key, this.selectedIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();

  _currentIndex =
      widget.selectedIndex;
}

  // List halaman utama navigasi bawah
  final List<Widget> _screens = [
    const HomeScreen(),
    const PesananScreen(),
    const Center(child: Text("Halaman Notifikasi (Segera Hadir)")),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),

      // Floating Action Button (FAB) tombol tambah (+) di tengah bawah
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 🚀 SEKARANG SUDAH AKTIF: Meluncur ke halaman Add Product Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        },
        backgroundColor: const Color(0xFFB13D14),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),

      // Perbaikan Struktur Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 60,
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
              Expanded(
                child: _buildNavItem(Icons.menu_book_rounded, "MY ORDER", 1),
              ),
              const SizedBox(
                width: 48,
              ), // Jeda ruang kosong untuk FAB (+) di tengah
              Expanded(
                child: _buildNavItem(
                  Icons.notifications_outlined,
                  "NOTIFIKASI",
                  2,
                ),
              ),
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
