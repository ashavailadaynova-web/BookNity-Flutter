import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'view/Pesanan/pesanan_screen.dart';
import 'view/Beranda/home_screen.dart';
import 'view/Notifikasi/notifikasi_screen.dart';
import 'view/Profile/profile_screen.dart';
import 'view/add_product_screen.dart';

class MainScreen extends StatefulWidget {
  final int selectedIndex;

  const MainScreen({
    super.key,
    this.selectedIndex = 0,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // @override
  //   void initState() {
  //     super.initState();
  //     _currentIndex = widget.selectedIndex;
  //   }

    @override
void initState() {
  super.initState();

  print("MASUK MAIN SCREEN");
  print(widget.selectedIndex);

  _currentIndex = widget.selectedIndex;
}

 late int _currentIndex;

  // 2. SESUAIKAN ISI LIST _SCREENS DI SINI
  final List<Widget> _screens = [
    const HomeScreen(),
    const PesananScreen(), // Ganti teks lama dengan class PesananScreen kamu!
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),

      // Floating Action Button (FAB) tombol tambah (+) di tengah
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddProductScreen(),
          ),
        );
      },
      backgroundColor: const Color(0xFFB13D14),
      elevation: 4,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 32,
      ),
    ),

      // Bottom Navigation Bar
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
              const SizedBox(width: 48), // Jeda ruang kosong untuk FAB (+)
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
