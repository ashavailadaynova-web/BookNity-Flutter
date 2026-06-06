import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/book_model.dart';
import '../../viewmodel/book_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Login Register/login_screen.dart';
// PASTIKAN PATH IMPORT DI BAWAH INI SESUAI DENGAN FOLDER KAMU:
import 'edit_profile_screen.dart'; 
import '../add_product_screen.dart';
import 'help_center_screen.dart';
import 'settings_screen.dart';

// IMPORT WIDGET PRODUCT CARD YANG BARU SAJA DIPISAH:
import '../../widgets/product_card.dart'; // Sesuaikan lokasi foldernya!

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFFFAF2);
    const primaryTextColor = Color(0xFF3E2723); 
    const accentColor = Color(0xFFFF7043); 
    const badgeCream = Color(0xFFF5EBE0);
    const badgePink = Color(0xFFFDE2E4);
    const badgeYellow = Color(0xFFFFF1C5);

    final List<String> myGenres = ["Horror", "Mystery"];
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "Belum login";
    final nama =
    email.split('@').first;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              Text(
                "Profil Saya",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              
              const SizedBox(height: 24),
              
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        image: const DecorationImage(
                          image: NetworkImage('https://i.imgur.com/8QjU0rU.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              
              Text(
                nama,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 20),

Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 24,
  ),
  child: SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const EditProfileScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(25),
        ),
      ),
      child: Text(
        "Edit Profile",
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ),
),

const SizedBox(height: 24),

Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 20,
  ),
  child: Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 24,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Text(
          "Aktivitas Saya",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF3E2723),
          ),
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: [

            _buildActivityItem(
              Icons.menu_book_rounded,
              "0",
              "Dijual",
              const Color(0xFFFFB74D),
            ),

            _buildActivityItem(
              Icons.local_shipping_rounded,
              "0",
              "Terjual",
              const Color(0xFF81C784),
            ),

            _buildActivityItem(
              Icons.star_rounded,
              "0.0",
              "Rating",
              const Color(0xFFFFD54F),
            ),
          ],
        ),
      ],
    ),
  ),
),

const SizedBox(height: 32),

const ProductSection(
  title: "Produk Saya",
  isSoldOutSection: false,
),

              const SizedBox(height: 28),

              // SECTION PRODUK TERJUAL
              const ProductSection(
                title: "Produk Terjual",
                isSoldOutSection: true,
              ),
              
              const SizedBox(height: 32),

              // MENU NAVIGASI TAMBAHAN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.favorite_rounded,
                        iconColor: const Color(0xFFFF7043),
                        title: "Wishlist Saya",
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Membuka Wishlist Saya...')),
                          );
                        },
                      ),
                      const Divider(color: Color(0xFFF5EBE0), height: 8, indent: 64),
                      _buildMenuItem(
                        icon: Icons.help_center_rounded,
                        iconColor: const Color(0xFF8D6E63),
                        title: "Pusat Bantuan",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                          );
                        },
                      ),
                      const Divider(color: Color(0xFFF5EBE0), height: 8, indent: 64),
                      _buildMenuItem(
                        icon: Icons.settings_rounded,
                        iconColor: Colors.grey[600]!,
                        title: "Pengaturan Akun",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsScreen()),
                          );
                        },
                      ),
                      const Divider(color: Color(0xFFF5EBE0), height: 8, indent: 64),
                     _buildMenuItem(
                      icon: Icons.logout_rounded,
                      iconColor: const Color(0xFFB13D14),
                      title: "Keluar Akun",
                      textColor: const Color(0xFFB13D14),

                      onTap: () async {

                        await FirebaseAuth.instance.signOut();

                        if (!context.mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 120), 
           ],
          ), // Column
        ), // SingleChildScrollView
      ), // SafeArea
    ); // Scaffold
  } // build

  Widget _buildFollowStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF3E2723)),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFC77A62), letterSpacing: 0.5),
        ),
      ],
    );
  }

  Widget _buildInfoCapsule(Color bgColor, Color iconColor, IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF3E2723)),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
  IconData icon,
  String value,
  String label,
  Color color,
) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),

      const SizedBox(height: 8),

      Text(
        value,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    ],
  );
}

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    Color textColor = const Color(0xFF3E2723),
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey[400],
        size: 24,
      ),
    );
  }
}

class ProductSection extends StatelessWidget {
  final String title;
  final bool isSoldOutSection;

  const ProductSection({
    super.key,
    required this.title,
    required this.isSoldOutSection,
  });

  @override
  Widget build(BuildContext context) {
    // 🛠️ HITUNG UKURAN DUA KARTU AGAR PAS DENGAN LEBAR LAYAR HP
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth - 20 - 20 - 16) / 2; // (Lebar Layar - Padding Kiri - Padding Kanan - Jarak Tengah) / 2
    double emptyCardHeight = (cardWidth * 4 / 3) + 102; // Menyeimbangkan tinggi Kotak Tambah dengan ProductCard

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF3E2723),
                ),
              ),
              Text(
                "Lihat Semua",
                style: GoogleFonts.poppins(
                  fontSize: 13, 
                  fontWeight: FontWeight.w600, 
                  color: const Color(0xFFFF7043),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
       SizedBox(
      height: 360,
      child: StreamBuilder<List<BookModel>>(
      stream: context.read<BookViewModel>().booksStream,
      builder: (context, snapshot) {
      if (snapshot.connectionState ==
      ConnectionState.waiting) {
      return const Center(
      child: CircularProgressIndicator(),
      );
      }


        final books = snapshot.data ?? [];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics:
              const BouncingScrollPhysics(),
          padding:
              const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              ...books.map((book) {
                return Padding(
                  padding:
                      const EdgeInsets.only(
                    right: 16,
                  ),
                  child: SizedBox(
                    width: cardWidth,
                    child: ProductCard(
                      imageUrl: book.image,
                      title: book.title,
                      author: book.author,
                      price: book.price,

                      onTap: () {},

                      onEditTap: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Edit ${book.title}',
                            ),
                          ),
                        );
                      },

                      onDeleteTap:
                          () async {
                        if (book.id !=
                            null) {
                          await context
                              .read<
                                  BookViewModel>()
                              .deleteBook(
                                book.id!,
                              );
                        }
                      },
                    ),
                  ),
                );
              }).toList(),

              if (!isSoldOutSection)
                SizedBox(
                  width: cardWidth,
                  child: _buildEmptyCard(
                    context,
                    emptyCardHeight,
                  ),
                ),
            ],
          ),
        );
 },
    ),
  ),
      ],
    );
  }
  Widget _buildEmptyCard(BuildContext context, double height) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddProductScreen(),
          ),
        );
      },
      child: Container(
        height: height, // Mengikuti tinggi kalkulasi seimbang
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_circle_outline,
                size: 40,
                color: Color(0xFFB13D14),
              ),
              const SizedBox(height: 12),
              Text(
                "Tambah Buku",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}